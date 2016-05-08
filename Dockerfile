# "adopted" by jamitupya@gmail.com for use in a reverse proxy template
# 
# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>

FROM centos:centos7
#MAINTAINER The CentOS Project <cloud-ops@centos.org>
MAINTAINER Jamitupya <jamitupya@gmail.com>

# Update to latests builds
RUN yum -y update; yum clean all
RUN yum -y install epel-release tar ; yum clean all
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm ; yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm ; yum clean all
RUN yum -y install yum-utils ; yum-config-manager --enable remi,remi-php70 ; yum -y update ; yum clean all

# Install compile tools + prerequisites
RUN yum -y --enablerepo=remi,remi-php56 install \
git gcc-c++ pcre-devel libxml2 libxml2-devel g++ libcurl-devel doc-base gd autoconf automake1.9 wget bison \
libtool zlib-devel libgssapi libunwind automake libatomic unzip bzip2-devel libnet-devel python2 python2-devel jansson-devel libxml2 libxslt libcap-ng-devel \
libnet-devel readline-devel libpcap-devel libcap-ng-devel libyaml-devel GeoIP-devel lm_sensors-libs net-snmp-libs net-snap gd-devel libnetfilter_queue-devel \
libnl-devel popt-devel lsof ipvsadm nss-devel ncurses-devel glib2-devel file-devel geoip-devel luajit-devel luajit lua-devel ; yum clean all

# setup source folders

# compile brotli + prerequisites
RUN cd /usr/src/ && git clone https://github.com/bagder/libbrotli && cd libbrotli && ./autogen.sh && ./configure && make && make install ; rm -rf /usr/src/libbrotli 

# get openssl + pagespeed sources
RUN cd /usr/src/ && wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION:+1.10.33.6}-beta.zip && sudo unzip release-${NPS_VERSION:+1.10.33.6}-beta.zip && cd ngx_pagespeed-release-${NPS_VERSION}-beta && wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION:+1.10.33.6}.tar.gz && tar -xzvf ${NPS_VERSION:+1.10.33.6}.tar.gz && cd /usr/src/ && wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && tar -xvzf openssl-${OPENSSL_VERSION:+1.0.2g}.tar.gz && cd /usr/src/
# get nginx sources
RUN cd /usr/src/ && wget http://nginx.org/download/nginx-${NGINX_VERSION:+1.9.12}.tar.gz && tar -xvzf nginx-${NGINX_VERSION:+1.9.12}.tar.gz 

# get nginx module prerequisites
RUN cd /usr/src/ && git clone https://github.com/simpl/ngx_devel_kit && git clone https://github.com/kyprizel/testcookie-nginx-module && git clone https://github.com/Lax/ngx_http_accounting_module.git && git clone https://github.com/openresty/headers-more-nginx-module && git clone https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng && git clone https://github.com/openresty/lua-nginx-module && git clone https://github.com/openresty/lua-upstream-nginx-module && git clone https://github.com/openresty/lua-resty-limit-traffic && git clone https://github.com/vozlt/nginx-module-vts && git clone https://github.com/google/ngx_brotli && git clone https://github.com/yzprofile/ngx_http_dyups_module && git clone https://github.com/cubicdaiya/ngx_dynamic_upstream && git clone https://github.com/leev/ngx_http_geoip2_module
RUN ls -la /usr/src 
# compile nginx prerequisites

RUN yum -y install nginx ; yum clean all
ADD nginx.conf /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN curl https://git.centos.org/sources/httpd/c7/acf5cccf4afaecf3afeb18c50ae59fd5c6504910 \
    | tar -xz -C /usr/share/nginx/html \
    --strip-components=1
RUN sed -i -e 's/Apache/nginx/g' -e '/apache_pb.gif/d' \ 
    /usr/share/nginx/html/index.html

EXPOSE 80
EXPOSE 443

CMD [ "/usr/sbin/nginx" ]

