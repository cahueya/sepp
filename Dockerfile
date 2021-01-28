#---------------------------------------------------------------------------
# Hinweise:
# - SIGTERM ist abgestimmt auf die Bash-Trap in start_services.sh
# - Bei docker stop <container> wird dieses Signal an das PID 1 gesendet
# - Bei CMD müssen wir die Schreibweise in [...] nehmen, da ansonsten 
#   unser start_services.sh Script nicht als PID 1 läuft!
#
FROM		ubuntu:18.04
EXPOSE		80
STOPSIGNAL	SIGTERM
RUN		apt-get update
RUN		apt-get install -y nginx
RUN		apt-get install -y mysql-server-5.7
COPY		start_services.sh /start_services.sh
CMD		["/start_services.sh"]
