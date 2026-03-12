#!/bin/bash
set -e

# 1. Vérifier si la database est déjà là
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de la base de données..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# 2. Créer un fichier de configuration temporaire
# On écrit toutes les commandes SQL dans un fichier
cat << EOF > /tmp/init.sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# 3. Lancer MariaDB en mode bootstrap pour exécuter le fichier init.sql
# C'est magique : ça configure TOUT sans lancer le serveur réseau
echo "Configuration de MariaDB via bootstrap..."
mysqld --user=mysql --bootstrap < /tmp/init.sql
rm -f /tmp/init.sql

# 4. Lancer MariaDB normalement
echo "Démarrage normal de MariaDB..."
exec mysqld_safe