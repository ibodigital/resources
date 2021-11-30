# Installation Guide for Raspberry PI


### Requirements

* Raspberry PI 4 (4GB+)
* 16GB SD Card (Class 10)
* Open Ports 3306, 8080, 8081
* Raspberry PI OS (bullseye)
* MariaDB 10 or MySql 8
* mail server (optional)


## Installation

Execute the following script

```
curl -L https://raw.githubusercontent.com/ibodigital/resources/main/InstallTrustkeyPi | bash
```

The installation will take around 5 minutes

We recommend to reboot your PI after the installation has completed

The installation will make use of the local installed MariaDB database.  To use a remote database see configration of the database below.

No mail server is installed or setup. If you wish to receive emails see configurate mail server below

Install the docker container for trustkey.  You will need an autorizsed docker hub account to download the docker container

```
docker login
docker pull ibodigital/trustkey-premise-pi
docker run --env-file env_trustkey.conf --name trustkey-premise-pi -p 8080:8080 -p 8081:8081 --restart=on-failure -d ibodigital/trustkey-premise-pi
```

To complete the setup point your browser at:

```
http://<your server id>:8080/view/register
```

Once logged into trustkey, it is highly recommended that you change your password.  If you have not setup the mailserver, recovery of a forgotton password will be difficult.

* Click on the profile icon (top right) --> Profile --> Change Password

## Upgrades

trustkey provide weekly updates.  To perform an upgrade of the docker container perform the following

```
docker login
docker ps
docker stop <container id>
docker rm <container id>
docker pull ibodigital/trustkey-premise-pi
docker run --env-file env_trustkey.conf --name trustkey-premise-pi -p 8080:8080 -p 8081:8081 --restart=on-failure -d ibodigital/trustkey-premise-pi
```



## Configuration

The confgiuration for the local

### Database Configuration

Configuration is set in the `env_trustkey.conf` file.

MySQL is, by default, configured to use the locally install MariaDB on the PI.

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

* Only basic search is available, full content text indexing is not currently supported.
* PDF generation is not supported (although you can create a print preview and generate the PDF from there)

