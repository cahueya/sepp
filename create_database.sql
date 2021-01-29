CREATE DATABASE newspusher;
CREATE USER 'newspusher'@'localhost' IDENTIFIED BY 'newspusher';
GRANT ALL PRIVILEGES ON newspusher.* TO 'newspusher'@'localhost';
FLUSH PRIVILEGES;
