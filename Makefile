CONTAINERNAME=phpmyadmin
PORT=8888
USER=$(shell whoami)
ifdef HOST
else
    HOST=mysql
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
	docker run -d --restart=always --name $(CONTAINERNAME) -p $(PORT):80  -e HOST=$(HOST) $(USER)/$(CONTAINERNAME) 
start: 
	docker start $(CONTAINERNAME)
stop:
	docker stop  $(CONTAINERNAME)
test:   run 
	docker ps
	sleep 5
	curl --retry 5 --retry-delay 5 -v http://localhost:$(PORT)/

.PHONY: clean

clean:  stop
	docker rm $(CONTAINERNAME) 
