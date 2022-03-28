#!/bin/sh

# Exit the script if any statement returns a non-true return value
set -e

if [ ! -f "/etc/supervisor/conf.d/consul-template.conf" ] ; then
  return 0
fi

if [ ! -z "${CONSUL_TEMPLATE_COMMAND}" ]
then
  TEMPLATE_COMMAND=${CONSUL_TEMPLATE_COMMAND}
elif [ -r "/app/docker/provision/consul.sh" ]
then
  TEMPLATE_COMMAND="bash /app/docker/provision/consul.sh"
else
  echo "WARNING! Consul template command not found. Removing supervisor consul template config"
  rm /etc/supervisor/conf.d/consul-template.conf
fi

if [ ! -z "${TEMPLATE_COMMAND}" ]
then
  # Replace consul template command with CONSUL_TEMPLATE_COMMAND env variable
  sed -i "s|CONSUL_TEMPLATE_COMMAND|${TEMPLATE_COMMAND}|g" /etc/supervisor/conf.d/consul-template.conf
fi
