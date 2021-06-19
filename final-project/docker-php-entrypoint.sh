#!/bin/sh
set -e

cd /var/www/html
chown -R www-data:www-data storage
chown -R www-data:www-data bootstrap
composer i --no-interaction
php artisan migrate --force

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi
exec "$@"
