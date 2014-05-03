FROM	ubuntu:latest

RUN		apt-get update
RUN		apt-get -y install software-properties-common
RUN		add-apt-repository ppa:chris-lea/node.js
RUN		apt-get update
RUN		apt-get -y upgrade
RUN		apt-get -y install git
RUN		apt-get -y install nodejs
RUN		npm update npm -g
RUN		npm update -g

ADD		./install-app.sh
RUN		./install-app.sh 8000

EXPOSE  8000