# Installation Guide for Raspberry PI


## Quick Start

1. Create Docker account at https://hub.docker.com/
2. Send docker username to IBODigital so that you can be registered to download the trustkey images
3. Install your Raspberry PI
4. Execute the following script `curl -L https://raw.githubusercontent.com/ibodigital/resources/main/InstallTrustkeyPi | bash`
5. Reboot `sudo reboot`
6. Ask IBODigital for the release {tag} of the docker image
7. Execute the following

```
docker login
docker pull ibodigital/trustkey-premise-pi:{tag}
docker run --env-file env_trustkey.conf --name trustkey-premise-pi -p 80:8080 -p 8081:8081 --restart on-failure:5 -d ibodigital/trustkey-premise-pi:{tag}
```

7. Complete trustkey setup at `http://<your server id>/view/register`

### Requirements

* Raspberry PI 4 (4GB+)
* 16GB SD Card (Class 10)
* Fixed IP Address (or DNS name)
* Open Ports 80, 8081
* Raspberry PI OS (bullseye)
* MariaDB 10 or MySql 8
* mail server (optional)

## Installation Details

Execute the following script

```
curl -L https://raw.githubusercontent.com/ibodigital/resources/main/InstallTrustkeyPi | bash
```

The installation will take around 5 minutes

We recommend to reboot your PI after the installation has completed

The installation will make use of the local installed MariaDB database.  To use a remote database see configration of the database below.

No mail server is installed or setup. If you wish to receive emails see configurate mail server below

Install the docker container for trustkey.  You will need an autorizsed docker hub account to download the docker container

Please ask IBODigital for the latest release tag to ensure that you pull the correct production release.

```
docker login
docker pull ibodigital/trustkey-premise-pi:{tag}
docker run --env-file env_trustkey.conf --name trustkey-premise-pi -p 80:8080 -p 8081:8081 --restart on-failure:5 -d ibodigital/trustkey-premise-pi:{tag}
```

To complete the setup point your browser at:

```
http://<your server id>/view/register
```

Once logged into trustkey, it is highly recommended that you change your password.  If you have not setup the mailserver, recovery of a forgotton password will not be possible.

* Click on the profile icon (top right) --> Profile --> Change Password

## Upgrades

To perform an upgrade of the docker container perform the following

```
curl -L https://raw.githubusercontent.com/ibodigital/resources/main/UpgradeTrustkeyPi | bash
```

You can also perform the manual upgrade as follows:

```
docker login
docker ps
docker rm -f  <container id>
docker pull ibodigital/trustkey-premise-pi:{tag}
docker run --env-file env_trustkey.conf --name trustkey-premise-pi -p 80:8080 -p 8081:8081 --restart on-failure:5 -d ibodigital/trustkey-premise-pi:{tag}
```


## Configuration

The install script will create a standard configuration to use out-of-the-box.
However, you may wish to configure a different database & the mail server

Configuration is set in the `env_trustkey.conf` file.


### Database Configuration

trustkey is compatible with MySQL 8+ and MariaDB 10+.

The database is, by default, configured to use the locally install MariaDB on the PI.

You may wish to consider to modify the default password.

Using a different MySQL or MariaDB is possible, just modify the database configuration parameters in `env_trustkey.conf`

```
MYSQL_USER=trustkeyadmin
MYSQL_PASSWORD=
MYSQL_SERVER=
MYSQL_DISABLE_SSL=true
```

After modification you will need to restart the docker container

```
docker ps
docker stop <container id>
docker start <container id>
```

trustkey will install the require database. To complete the setup point your browser at:

```
http://<your server id>:8080/view/register
```

### Mail Server Configuration

You can send outgoing mails via many supported mail servers such as postfix, gmail, outlook.com

```
MAIL_HOST=
MAIL_PORT=
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_SSL=
MAIL_ERROR="support@trustkey.eu"
MAIL_SENDER="noreply@trustkey.eu"
```

For TLS encryption set `MAIL_SSL=tsl` otherwise leave blank


## Limitations

There are some limitations to running trustkey on arm processor of the raspberry.

* Only http is supported by default. https is available on request. Please contact IBODigital support.
* Only basic search is available, full content text indexing is not currently supported on the PI.
* PDF generation is not supported (although you can create a print preview and generate the PDF this way)

# Troubleshooting

### Email Validation

If the emails are not working, you can call the following url to determine any possible errors:

http://<your server id>/api/public/sendmail


### Container not running

Check the container status:

```
docker ps -a
```

check the logs:

```
docker logs <container id>
```


restart the container (or just start the container if it is not running).  A restart of the container should generally fix most problems.

```
docker contaier stop <container id>
docker container start <container id>
```

