# README

### Set up Postgres

The motivation to use postgres in development is to avoid the bugs in production cause by sqlite3 -> pg implicit conversion.

```bash
sudo apt-get install postgresql # see Mac/brew or  yum/Centos variations on install or is postgres.app on mac
sudo service postgresql start   # or systemctl instead of service depending on version/distro of unix
sudo -u postgres psql
postgres=# create user "bimaguide_dev" with password 'dev';
CREATE ROLE
postgres=# create database "bima_dev_pg" owner "bimaguide_dev";
CREATE DATABASE
postgres=# create database "bima_test_pg";
postgres=# GRANT ALL PRIVILEGES ON  DATABASE "bima_dev_pg" to "bimaguide_dev";
GRANT
```

Once pg is set up, run:

```bash
bundle && yarn
```
