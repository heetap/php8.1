# Intro

This is universal base image of `Debian` Linux with `nginx` & `php-fpm8`. It is pre-configured. 
Basically, you can put Laravel application into `/app` folder, and all should work.
This image is based on official PHP image with Debian linux OS, so you should be able to update it with minimal effort.

# Usage

## Consul template command
Application image should declare consul template command. Otherwise the supervisor config will be removed with warning message.
### 1st way: Pass `CONSUL_TEMPLATE_COMMAND` environment variable
Example:

```ENV CONSUL_TEMPLATE_COMMAND="bash /some/command.sh"```
### 2st way: Create consul template command file in /app/docker/provision/consul.sh
This file will be auto discovered by container entrypoint and used as consul template command. Make sure the file is readable and executable.
## Cron
This image uses the following cron folders:
```
/etc/periodic/15min
/etc/periodic/hourly
/etc/periodic/daily
/etc/periodic/weekly
/etc/periodic/monthly
/etc/periodic/minute
```
Executable files should be placed in corresponding folders. For example if some command have to be run once per day `/etc/periodic/daily` folder should be used.

Another ways to schedule command run - modify crontab in usual way - `crontab -e` or change `/etc/crontabs/root` file content.

## Xdebug
`xdebug` extension can be configured with environment variables:

| Variable                                                       | Description                                                                                         |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `XDEBUG_ENABLE=1`                                              | This will enable Xdebug. |
| `XDEBUG_CONFIG=client_host=172.17.0.1 client_port=9000 ...`    | Internal Xdebug environment variable. A select set of settings can be set through an `XDEBUG_CONFIG` environment variable. In this situation, the `xdebug.` settings should not be passed in another way. Details: https://xdebug.org/docs/all_settings. | 
| `XDEBUG_MODE=debug`                                            | Setup Xdebug mode. Default - `off`. Details: https://xdebug.org/docs/all_settings#mode |
| `XDEBUG_CLIENT_HOST=192.168.0.1`                               | Setup Xdebug client host. Details: https://xdebug.org/docs/all_settings#client_host |
| `XDEBUG_CLIENT_PORT=9003`                                      | Setup Xdebug client port. Details: https://xdebug.org/docs/all_settings#client_host |
| `XDEBUG_CONFIG_EXTRA=xdebug.remote_log = /var/log/xdebug.log;` | Setup other Xdebug options |

Also `xdebug` can be configured using `/etc/php8/conf.d` folder or modifying `php.ini` file directly.
