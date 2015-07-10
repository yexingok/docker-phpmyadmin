# PHPMYADMIN
Prepare a simple ready to use phpmyadmin web container, see Makefile for how to use it.

# Dependence:
Docker

# How to use:
1. Build the container:
make build

2. Run it and tcp connect to mysql host www.mycompany.com
make HOST=www.mycompany.com PORT=3306  run

For more options: check the Makefile.
Enjoy!

# Build Status:
[![Circle CI](https://circleci.com/gh/yexingok/docker-phpmyadmin.svg?style=svg)](https://circleci.com/gh/yexingok/docker-phpmyadmin)

