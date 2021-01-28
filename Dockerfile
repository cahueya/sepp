FROM	ubuntu:18.04
EXPOSE	80
RUN	apt-get update
RUN	apt-get install -y nginx
CMD	service nginx start ; sleep inf
