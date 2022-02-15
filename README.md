# README

### Set up Postgres

The motivation to use postgres in development is to avoid the bugs in production cause by sqlite3 -> pg implicit conversion.

```bash
sudo apt-get install postgresql # see Mac/brew or  yum/Centos variations on install or is postgres.app on mac
sudo service postgresql start   # or systemctl/gui instead of service depending on version/distro of unix
sudo vi /etc/postgresql/*/main/pg_hba.conf # modify to use trust auth instead of peer auth ref: https://stackoverflow.com/questions/18664074/getting-error-peer-authentication-failed-for-user-postgres-when-trying-to-ge 
```

Once pg is set up, run:
```bash
bundle && yarn && rails db:create db:migrate
```

### Setting up Redis
Please use this quick start to install redis for locally. Redis is used to
run the background jobs on heroku. To test locally, run
```bash
redis-server

# in separate terminal
bundle exec sideqik
```