CONTAINERNAME=phpmyadmin
USER=$(shell whoami)
ifdef HOST
else
    HOST=mysql
endif
ifdef PORT
else
    PORT=3306
endif

build:
	docker build -t $(USER)/$(CONTAINERNAME) .
rebuild:
	docker build --no-cache -t $(USER)/$(CONTAINERNAME) .
debug:
	docker exec -it $(CONTAINERNAME) /bin/bash
logs:
	docker exec -it $(CONTAINERNAME) tail -f /var/log/httpd/error_log /var/log/httpd/access_log
ip:
	docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(CONTAINERNAME)
run:
	docker run -d --restart=always --name $(CONTAINERNAME) -p 8888:80  -e HOST=$(HOST) -e PORT=$(PORT) $(USER)/$(CONTAINERNAME) 
start: 
	docker start $(CONTAINERNAME)
stop:
	docker stop  $(CONTAINERNAME)
test:   run 
	docker ps
	sleep 5
	curl --retry 5 --retry-delay 5 -v http://localhost:8888/

.PHONY: clean

clean:  stop
	docker rm $(CONTAINERNAME) 
