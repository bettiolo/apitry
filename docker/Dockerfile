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

RUN		mkdir /app
ADD		./install-app.sh /app/
RUN		chmod +x /app/install-app.sh
RUN		echo "cd /app" > ~/.bash_login
RUN		echo "./install-app.sh 8000" >> ~/.bash_login
RUN		echo "cd apitry/src/" >> ~/.bash_login
RUN		echo "npm test" >> ~/.bash_login

EXPOSE  8000