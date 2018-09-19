FROM swift

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y lsof

#nginx
RUN apt-get install nginx -y

RUN /bin/bash -c "$(wget -qO- https://apt.vapor.sh)"

#Vim
RUN apt-get install vim -y

#Vapor + lib for BlogCore
RUN apt-get install -y vapor 

# Supervisor
RUN apt-get install supervisor -y

RUN mkdir ./home/vapor

COPY ./docker/nginx/ /etc/nginx/sites-enabled/
COPY ./ ./home/vapor/SwiftBlogKit

WORKDIR ./home/vapor/SwiftBlogKit/

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
