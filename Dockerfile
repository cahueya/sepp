#---------------------------------------------------------------------------
# Hinweise:
# - SIGTERM ist abgestimmt auf die Bash-Trap in start_services.sh
# - Bei docker stop <container> wird dieses Signal an das PID 1 gesendet
# - Bei CMD ganz unten müssen wir die Schreibweise in [...] nehmen, da ansonsten 
#   unser start_services.sh Script nicht als PID 1 läuft!
# - DEBIAN_FRONTEND="noninteractive" machen wir damit das install php7.3 nicht
#   interaktiv fragt, wenn es im Zuge der Dependencies tzdata installiert
# - Unklar ob EXPOSE wirklich notendig ist
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
RUN		apt-get install -y curl
RUN		apt-get install -y php7.3-fpm
RUN		apt-get install -y php7.3-mysql
RUN		apt-get install -y php7.3-xml
RUN		apt-get install -y php7.3-gd
RUN		apt-get install -y php7.3-mbstring
RUN		apt-get install -y php7.3-zip
RUN		apt-get install -y php7.3-curl
COPY		start_services.sh   /start_services.sh
#---------------------------------------------------------------------------
# Hinweise:
# - Wir ziehen uns die gewünschte Version vom Concrete5
# - Die Option -L heist lediglich dass curl Redirects nachgehen soll
# - Wir entpacken das Concrete5 in den Zielordner /var/www/html
# - Die Rechte auf www-data setzen wir nur ausgewählt
# - Der Rest bleibt root
#
RUN		curl -L https://www.concrete5.org/download_file/-/view/115589/ > /concrete5-8.5.5.zip
#RUN             curl -L https://www.concrete5.org/download_file/-/view/113632/ > /concrete5-8.5.4.zip
RUN		unzip -d /var/www /concrete5-8.5.5.zip
#RUN		unzip -d /var/www /concrete5-8.5.4.zip
RUN		rm -r    /var/www/html
RUN		mv       /var/www/concrete5-8.5.5 /var/www/html
#RUN		mv       /var/www/concrete5-8.5.4 /var/www/html
RUN		chown -R www-data:www-data /var/www/html/updates/
RUN		chown -R www-data:www-data /var/www/html/packages/
RUN		chown -R www-data:www-data /var/www/html/application/config/
RUN		chown -R www-data:www-data /var/www/html/application/files/
RUN		chown -R www-data:www-data /var/www/html/application/languages/
#---------------------------------------------------------------------------
# Hinweise:
# - Hier überschreiben wir die nginx-Config
# - Der Einfachheit halber überschreiben wir die default-Config
#
COPY		newspusher.conf /etc/nginx/sites-available/default
#-------------------------------------------------------------------------------------
# Hinweise:
# - Ab hier legen wir die DB und den DB-User an
# - Dazu müssen wir kurz die MySQL hochfahren (muss innerhalb eines RUN passieren)
#
COPY		create_database.sql /create_database.sql
RUN		service mysql start && \
		mysql -u root < create_database.sql && \
		service mysql stop
#-------------------------------------------------------------------------------------
# Hinweise:
# - Ab hier installieren wir das Concrete5 von der Kommandozeile aus
# - Dazu müssen wir kurz die MySQL hochfahren (muss innerhalb eines RUN passieren)
# - Wir führen den Installer *nicht* als root aus
# - Bei den Sprachen/Locales ist nicht ganz klar, ob alle Stellen notwendig sind,
#   bei denen wir de_DE setzen
#
RUN		service mysql start 								&& \
		runuser -u www-data -- /var/www/html/concrete/bin/concrete5 c5:install		\
			-n									\
			--language		de_DE						\
			--site-locale		de_DE						\
			--db-server		localhost					\
			--db-username		newspusher					\
			--db-password		newspusher					\
			--db-database		newspusher					\
			--starting-point	elemental_full					\
			--site			newspusher					\
			--admin-password	admin						&& \
		runuser -u www-data -- /var/www/html/concrete/bin/concrete5 c5:language-install	\
			--add de_DE								&& \
#		runuser -u www-data -- /var/www/html/concrete/bin/concrete5 c5:config		\
#			set concrete.multilingual.default_source_locale de_DE			&& \
		service mysql stop
#-------------------------------------------------------------------------------------
# Hinweise:
# - Ab hier legen wir die DB und den DB-User an
# - Dazu müssen wir kurz die MySQL hochfahren
#
#-------------------------------------------------------------------------------------
# Hinweise:
# - Ab hier installieren wir den composer
# - Die Installation machen wir als der User www-data
# - Damit der Composer überhaupt geht, wir müssen vorher die Rechte im Home des Users .config/composer setzten
# - Wir setzen absichtlich *nicht* die Rechte vom gesamten /var/www
#
RUN		mkdir                   /composer									&& \
		chown www-data:www-data /composer									&& \
		mkdir -p                /var/www/.config/composer							&& \
		chown www-data:www-data /var/www/.config/composer							&& \
		cd                      /composer									&& \
		runuser -u www-data -- php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"	&& \
		runuser -u www-data -- php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
		runuser -u www-data -- php composer-setup.php								&& \
		runuser -u www-data -- php -r "unlink('composer-setup.php');"
#-------------------------------------------------------------------------------------
# Hinweise:
# - Ab hier ziehen und entpacken wir unser Package nach .../packages/
# - Der Einfachheit halber entpacken wir als User www-data und sparen uns dadurch den chown
# - Im Anschluss ziehen wir die Dependencies des Packages mittels Composer-Aufruf
#
RUN		curl -L https://github.com/cahueya/newspush_master/archive/main.zip > /newspush_master.zip
RUN		cd /var/www/html/packages/								&& \
		runuser -u www-data -- unzip /newspush_master.zip					&& \
		mv /var/www/html/packages/newspush_master-main /var/www/html/packages/newspush_master	&& \
		cd /var/www/html/packages/newspush_master						&& \
		runuser -u www-data -- php /composer/composer.phar install
#-------------------------------------------------------------------------------------
# Hinweise:
# - Ab hier entpacken installieren wir das entpackte Package im Concrete5
# - Das spart uns den entsprechenden Klick
# - Dazu müssen wir kurz die MySQL hochfahren (muss innerhalb eines RUN passieren)
#
RUN		service mysql start && \
		cd /var/www/html/packages/newspush_master && \
		runuser -u www-data -- /var/www/html/concrete/bin/concrete5 c5:package:install newspush_master && \
		service mysql stop
CMD		["/start_services.sh"]
