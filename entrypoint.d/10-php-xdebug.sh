#!/bin/sh

# Exit the script if any statement returns a non-true return value
set -e

# Note: if XDEBUG_CONFIG variable is present - selected xdebug. setting should be removed from .ini file
# Not all settings can be configured with this env variable. More details: https://xdebug.org/docs/all_settings

CONFIG_FILE=/usr/local/etc/php/conf.d/xdebug.ini
# check if config file has been created already
if [ -f "${CONFIG_FILE}" ] ; then
  return 0
fi

XDEBUG_ENABLED=false
if [ "${XDEBUG_ENABLE}" == 1 ]; then
  XDEBUG_ENABLED=true
fi
XDEBUG_CONFIG_MODE=off
if [ ! -z "${XDEBUG_MODE}" ]; then
  XDEBUG_CONFIG_MODE=${XDEBUG_MODE}
fi

#
# Xdebug config: enable xdebug extension
#
if ${XDEBUG_ENABLED} ; then
  cat <<EOF >> ${CONFIG_FILE}
#
# Generated automatically by entrypoint script: /entrypoint.d/10-php-xdebug.sh
#
zend_extension=xdebug.so
EOF
  echo "xdebug.mode=${XDEBUG_CONFIG_MODE}" >> ${CONFIG_FILE};
  echo "xdebug.start_with_request=true"  >> ${CONFIG_FILE};
  echo "xdebug.idekey=PHPSTORM"  >> ${CONFIG_FILE};
  if [ ! -z ${XDEBUG_CLIENT_HOST} ] ; then
     echo "xdebug.client_host=${XDEBUG_CLIENT_HOST}" >> ${CONFIG_FILE};
  fi
  if [ ! -z ${XDEBUG_CLIENT_PORT} ] ; then
     echo "xdebug.client_port=${XDEBUG_CLIENT_PORT}" >> ${CONFIG_FILE};
  fi

  if [ ! -z ${XDEBUG_CONFIG_EXTRA} ] ; then
    echo -e ${XDEBUG_CONFIG_EXTRA//';'/'\n'} >> ${CONFIG_FILE};
  fi
fi
