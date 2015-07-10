From centos:centos6
MAINTAINER yexing@edanzgroup.com

ENV VERSION=4.4.11

#Base:
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#ADD docker-scripts/CentOS-Base.repo  /etc/yum.repos.d/
RUN yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y supervisor

#APP package dependence:
RUN yum -y install httpd php php-mysql php-gd php-mbstring php-cli wget tar
RUN yum clean all 

#APP software:
RUN  cd /var/www/html && \
     wget -O pma.tar.gz https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-english.tar.gz && \
     tar --strip-components=1 -zxf pma.tar.gz  && \
     rm -rf *.md .coveralls.yml ChangeLog composer.json DCO doc examples phpunit.* README RELEASE-DATE-* setup pma.tar.gz

RUN chown -R apache.apache /var/www/html

#APP daemon start config:
ADD docker-scripts/php.ini  /etc/php.ini
ADD docker-scripts/supervisord.conf  /etc/supervisord.conf
ADD docker-scripts/start.sh /

#APP start:
EXPOSE 80
CMD ["bash","/start.sh"]

