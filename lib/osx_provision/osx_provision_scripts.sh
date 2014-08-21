#!/bin/sh

#######################################
[prepare]

mkdir #{home}/Library/LaunchAgents/


#######################################
[brew]

ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

brew update
brew doctor

brew tap homebrew/dupes
brew tap homebrew/versions


#######################################
[rvm]

PATH=$PATH:/usr/local/bin
USER_HOME="#{node.home}"

curl -L https://get.rvm.io | bash

source $USER_HOME/.rvm/scripts/rvm


#######################################
[git]

brew install git


#######################################
[svn]

brew install svn


#######################################
[qt]

PATH=$PATH:/usr/local/bin

brew install qt


#######################################
[mysql]

PATH=$PATH:/usr/local/bin

USER_HOME='#{node.home}'

MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

brew install mysql

mkdir -p $USER_HOME/Library/LaunchAgents

sudo ln -sfv /usr/local/opt/mysql/*.plist $USER_HOME/Library/LaunchAgents

mysqladmin -u$MYSQL_USER password $MYSQL_PASSWORD
#mysqladmin -u$MYSQL_USER -p$MYSQL_PASSWORD

#######################################
[mysql_restart]

STARTED='[#{started}]'
USER_HOME='#{node.home}'

if [ "$STARTED" = "[true]" ] ; then
  launchctl unload $USER_HOME/Library/LaunchAgents/homebrew.mxcl.mysql.plist
fi

launchctl load $USER_HOME/Library/LaunchAgents/homebrew.mxcl.mysql.plist


#######################################
[postgres]

PATH=$PATH:/usr/local/bin
USER_HOME="#{node.home}"

brew install postgres

ln -sfv /usr/local/opt/postgresql/homebrew.mxcl.postgresql.plist $USER_HOME/Library/LaunchAgents

initdb /usr/local/var/postgres -E utf8


#######################################
[postgres_stop]

USER_HOME="#{node.home}"

launchctl unload -w $USER_HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist


#######################################
[postgres_start]

USER_HOME="#{node.home}"

launchctl load -w $USER_HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist


#######################################
[postgres_restart]

STARTED="[#{started}]"
USER_HOME="#{node.home}"

if [ "$STARTED" = "[true]" ] ; then
  launchctl unload -w $USER_HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
fi

launchctl load -w $USER_HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist


#######################################
[postgres_create_user]

PATH=$PATH:/usr/local/bin

APP_USER='#{postgres.app_user}'

createuser -s -d -r $APP_USER


#######################################
[postgres_create_schema]

PATH=$PATH:/usr/local/bin

APP_USER='#{postgres.app_user}'
SCHEMA='#{schema}'

createdb -U $APP_USER $SCHEMA


#######################################
[postgres_drop_schema]

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'

dropdb $SCHEMA


#######################################
[postgres_drop_user]

PATH=$PATH:/usr/local/bin

APP_USER='#{postgres.app_user}'

dropuser $APP_USER


#######################################
[mysql_create_user]

PATH=$PATH:/usr/local/bin

HOST_NAME='#{mysql.hostname}'
APP_USER='#{mysql.app_user}'
MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE USER '$APP_USER'@'$HOST_NAME' IDENTIFIED BY '$APP_USER';"
mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* to '$APP_USER'@'$HOST_NAME' IDENTIFIED BY '$APP_USER' WITH GRANT OPTION;"


#######################################
[mysql_drop_user]

PATH=$PATH:/usr/local/bin

HOST_NAME='#{mysql.hostname}'
USER='#{mysql.user}'
PASSWORD='#{mysql.password}'
APP_USER='#{mysql.app_user}'

mysql -h $HOST_NAME -u$USER -p$PASSWORD -e "DROP USER '$APP_USER'@'$HOST_NAME';"


#######################################
[mysql_create_schema]

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'

HOST_NAME='#{mysql.hostname}'
MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "create database $SCHEMA;"


#######################################
[mysql_drop_schema]

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'

HOST_NAME='#{mysql.hostname}'
MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "drop database $SCHEMA;"


#######################################
[ruby]

PATH=$PATH:/usr/local/bin

rvm install 1.9.3


#######################################
[jenkins]

PATH=$PATH:/usr/local/bin
USER_HOME="#{node.home}"

brew install jenkins

ln -sfv /usr/local/opt/jenkins/homebrew.mxcl.jenkins.plist $USER_HOME/Library/LaunchAgents


#######################################
[jenkins_restart]

STARTED="[#{started}]"
USER_HOME="#{node.home}"

if [ "$STARTED" = "[true]" ] ; then
  launchctl unload $USER_HOME/Library/LaunchAgents/homebrew.mxcl.jenkins.plist
fi

launchctl load $USER_HOME/Library/LaunchAgents/homebrew.mxcl.jenkins.plist


#######################################
[selenium]

PATH=$PATH:/usr/local/bin
USER_HOME="#{node.home}"

brew install selenium-server-standalone

ln -sfv /usr/local/opt/selenium-server-standalone/*.plist $USER_HOME/Library/LaunchAgents


#######################################
[selenium_restart]

STARTED="[#{started}]"
USER_HOME="#{node.home}"

if [ "$STARTED" = "[true]" ] ; then
  launchctl unload $USER_HOME/Library/LaunchAgents/homebrew.mxcl.selenium-server-standalone.plist
fi

launchctl load $USER_HOME/Library/LaunchAgents/homebrew.mxcl.selenium-server-standalone.plist


#######################################
[npm]

brew install node


#######################################
[package_installed]

ls #{package_path}


#######################################
[service_started]

NAME="#{name}"

TEMPFILE="$(mktemp XXXXXXXX)"
launchctl list | grep $NAME > $TEMPFILE
cat $TEMPFILE
rm $TEMPFILE
