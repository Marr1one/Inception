-- Ce fichier est exécuté automatiquement au premier démarrage si /var/lib/mysql est vide

CREATE DATABASE IF NOT EXISTS `${MYSQL_DATABASE}`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON `${MYSQL_DATABASE}`.* TO '${MYSQL_USER}'@'%';

-- Change root pour utiliser un mot de passe (mysql_native_password)
-- Important pour que WordPress puisse se connecter sans problème
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_ROOT_PASSWORD}');
FLUSH PRIVILEGES;