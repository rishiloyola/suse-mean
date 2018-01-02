FROM opensuse:latest


MAINTAINER rishi<rishiloyola98245@gmail.com>


# 80 = HTTP, 443 = HTTPS, 3000 = MEAN.JS server, 35729 = livereload, 8080 = node-inspector
EXPOSE 80 443 3000 35729 8080


# Set development environment as default
ENV NODE_ENV development


# Install Utilities
RUN zypper -n install curl
RUN zypper -n install git
RUN zypper -n install openssh
RUN zypper -n install gcc
RUN zypper -n install make


# install nodejs
RUN zypper -n install nodejs6


# install npm
RUN zypper -n install npm


# Install MEAN.JS Prerequisites
RUN npm install --quiet -g gulp bower yo mocha karma-cli pm2 && npm cache clean


RUN mkdir -p /opt/mean.js/public/lib
WORKDIR /opt/mean.js


# Clone mean.js
RUN git clone https://github.com/meanjs/mean.git


RUN cp -a mean/. .


# Install npm packages
RUN npm install --quiet && npm cache clean


# Install bower packages
RUN bower install --quiet --allow-root --config.interactive=false


# Run MEAN.JS server
CMD npm install && npm start