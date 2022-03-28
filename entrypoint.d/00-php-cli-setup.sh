#!/bin/sh

# Exit the script if any statement returns a non-true return value
set -e

PHP_PATH=/etc/php8.1
EXTENSIONS_INI_PATH=$( php-config --ini-dir )

if [ -r "${PHP_PATH}/php-cli.ini" ]; then
  return 0
fi

# Create separate php-cli config
cp ${PHP_PATH}/php.ini ${PHP_PATH}/php-cli.ini

# Enable pcntl extension only for cli mode
PCTNL_EXTENSION=$( cat "${EXTENSIONS_INI_PATH}/docker-php-ext-pcntl.ini" )
rm "${EXTENSIONS_INI_PATH}/docker-php-ext-pcntl.ini"
echo "${PCTNL_EXTENSION}" >> ${PHP_PATH}/php-cli.ini
