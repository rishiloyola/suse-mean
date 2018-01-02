FROM opensuse:latest

MAINTAINER rishi<rishiloyola98245@gmail.com>

# 80 = HTTP, 443 = HTTPS, 3000 = MEAN.JS server, 35729 = livereload, 8080 = node-inspector
EXPOSE 80 443 3000 35729 8080

# install nodejs
RUN zypper -n install nodejs6

# install npm
RUN zypper -n install npm

# Install MEAN.JS Prerequisites
RUN npm install --quiet -g gulp bower yo mocha karma-cli pm2 && npm cache clean

RUN mkdir -p /opt/mean.js/public/lib
WORKDIR /opt/mean.js

# Copies the local package.json file to the container
# and utilities docker container cache to not needing to rebuild
# and install node_modules/ everytime we build the docker, but only
# when the local package.json file changes.
# Install npm packages
COPY package.json /opt/mean.js/package.json
RUN npm install --quiet && npm cache clean

# Install bower packages
COPY bower.json /opt/mean.js/bower.json
COPY .bowerrc /opt/mean.js/.bowerrc
RUN bower install --quiet --allow-root --config.interactive=false

COPY . /opt/mean.js

# Run MEAN.JS server
CMD npm install && npm start
