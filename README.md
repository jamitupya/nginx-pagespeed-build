dockerfiles-centos-nginx
========================

TO BE COMPLETED

ENV variables that can be set to manage the versions; please not this only supports dynamic module compiles so nginx 1.9.12 onwards
note that the defaults will be as below also
NPS_VERSION=1.11.33.0
NGINX_VERSION=1.9.13
OPENSSL_VERSION=1.0.2g



CentOS 7 dockerfile for nginx

To build:

Copy the sources down -

    # docker build --rm --tag <username>/nginx:centos7 .

To run:

    # docker run -d -p 80:80 <username>/nginx:centos7

To test:

    # curl http://localhost

