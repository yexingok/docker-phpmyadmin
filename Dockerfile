From centos:centos6
MAINTAINER yexing@edanzgroup.com

ENV VERSION=4.4.7

#Base:
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#ADD docker-scripts/CentOS-Base.repo  /etc/yum.repos.d/
RUN yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install monit

#APP package dependence:
RUN yum -y install httpd php php-mysql php-gd php-mbstring php-cli wget tar
RUN yum clean all 

#APP software:
RUN  cd /var/www/html && \
     wget -O pma.zip http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-english.tar.gz && \
     tar --strip-components=1 -zxf pma.zip  && \
     rm -rf *.md .coveralls.yml ChangeLog composer.json DCO doc examples phpunit.* README RELEASE-DATE-* setup pma.zip

RUN chown -R apache.apache /var/www/html

#APP daemon start config:
ADD docker-scripts/monitrc  /etc/monitrc
ADD docker-scripts/start.sh /
RUN chmod 600 /etc/monitrc && chmod +x /start.sh

#APP start:
EXPOSE 80
CMD ["bash","/start.sh"]

