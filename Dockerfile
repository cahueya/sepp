#---------------------------------------------------------------------------
# Hinweise:
# - SIGTERM ist abgestimmt auf die Bash-Trap in start_services.sh
# - Bei docker stop <container> wird dieses Signal an das PID 1 gesendet
# - Bei CMD müssen wir die Schreibweise in [...] nehmen, da ansonsten 
#   unser start_services.sh Script nicht als PID 1 läuft!
# - DEBIAN_FRONTEND="noninteractive" machen wir damit das install php7.3 nicht
#   interaktiv fragt, wenn es im Zuge der Dependencies tzdata installiert
#
FROM		ubuntu:18.04
EXPOSE		80
STOPSIGNAL	SIGTERM
RUN		apt-get update
RUN		apt-get install -y software-properties-common
RUN		add-apt-repository -y ppa:ondrej/php
RUN		apt-get update
RUN		DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN		apt-get install -y nginx
RUN		apt-get install -y mysql-server-5.7
RUN		apt-get install -y unzip
RUN		apt-get install -y nano
RUN		apt-get install -y php7.3-fpm
RUN		apt-get install -y php7.3-mysql
RUN		apt-get install -y php7.3-xml
RUN		apt-get install -y php7.3-gd
RUN		apt-get install -y php7.3-mbstring
RUN		apt-get install -y php7.3-zip
COPY		start_services.sh   /start_services.sh
COPY		concrete5-8.5.4.zip /concrete5-8.5.4.zip
RUN		unzip -d /var/www   /concrete5-8.5.4.zip
RUN		rm -r /var/www/html
RUN		mv    /var/www/concrete5-8.5.4 /var/www/html
COPY		newspusher.conf /etc/nginx/sites-available/default
RUN		chown -R www-data:www-data /var/www/html/updates/
RUN		chown -R www-data:www-data /var/www/html/packages/
RUN		chown -R www-data:www-data /var/www/html/application/config/
RUN		chown -R www-data:www-data /var/www/html/application/files/
RUN		chown -R www-data:www-data /var/www/html/application/languages/
COPY		create_database.sql /create_database.sql
RUN		service mysql start && \
		mysql -u root < create_database.sql && \
		runuser -u www-data -- /var/www/html/concrete/bin/concrete5 c5:install -n --db-server localhost --db-username newspusher --db-password newspusher --db-database newspusher --starting-point elemental_full --site newspusher --admin-password admin && \
		service mysql stop
CMD		["/start_services.sh"]
