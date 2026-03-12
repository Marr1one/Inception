FROM debian:bullseye

# Installation de MariaDB et procps (pour la gestion des processus)
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    procps && \
    rm -rf /var/lib/apt/lists/*

# Création du dossier pour le socket MariaDB et gestion des permissions
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# Configuration pour autoriser les connexions depuis l'extérieur (le réseau Docker)
RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Copie et préparation du script d'initialisation
COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

# On lance le script au démarrage
ENTRYPOINT ["/usr/local/bin/setup.sh"]