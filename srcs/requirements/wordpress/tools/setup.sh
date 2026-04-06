#!/bin/bash

# 1. Installation de WP-CLI
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# 2. Config PHP-FPM pour écouter sur le port 9000
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

cd /var/www/

# 3. Installation de WordPress si wp-config n'existe pas
if [ ! -f wp-config.php ]; then
    
    # Téléchargement des fichiers
    wp core download --allow-root

    # Création du wp-config.php
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root \
		--url="http://$DOMAIN_NAME"

    # 4. Attente de la base de données (Crucial pour éviter les crashs au démarrage)
    echo "Vérification de la connexion à MariaDB..."
    while ! wp db check --allow-root; do
        sleep 3
    done

    # 5. Installation du site et création de l'ADMINISTRATEUR
    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    # 6. Création de l'UTILISATEUR CLASSIQUE (Ton login 42)
    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root

    echo "WordPress est installé et les utilisateurs sont créés !"
fi

# 7. Lancement de PHP-FPM en premier plan
echo "Démarrage de PHP-FPM..."
exec php-fpm7.4 -F