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
RUN yum -y install yum-utils ; yum-config-manager --enable remi-php70 ; yum -y update ; yum clean all

# Update base configuration
RUN firewall-cmd --zone=public --add-service=http --permanent ; firewall-cmd --zone=public --add-service=https --permanent


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

