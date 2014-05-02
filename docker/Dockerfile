FROM	ubuntu:latest

RUN		apt-get update
RUN		apt-get -y upgrade
RUN		apt-get -y install nodejs npm

ADD		../vagrant/install.sh ./install.sh
RUN		./install.sh

EXPOSE  8000

CMD ["node", "/src/index.js"]