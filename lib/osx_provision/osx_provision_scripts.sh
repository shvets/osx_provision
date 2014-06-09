#!/bin/sh

#######################################
[prepare]

xcodebuild -license


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
[qt]

PATH=$PATH:/usr/local/bin

brew install qt


#######################################
[init_launch_agent]

mkdir #{home}/Library/LaunchAgents/


#######################################
[mysql]

PATH=$PATH:/usr/local/bin
USER_HOME="#{node.home}"

brew install mysql

mkdir -p $USER_HOME/Library/LaunchAgents

ln -sfv /usr/local/opt/mysql/*.plist $USER_HOME/Library/LaunchAgents

mysqladmin -u root password 'root'


#######################################
[mysql_restart]

STARTED="[#{started}]"
USER_HOME="#{node.home}"

if [ "$STARTED" = "[true]" ] ; then
  launchctl unload $USER_HOME/Library/LaunchAgents/homebrew.mxcl.mysql.plist
fi

launchctl load $USER_HOME/Library/LaunchAgents/homebrew.mxcl.mysql.plist


#######################################
[create_mysql_user]

PATH=$PATH:/usr/local/bin

APP_USER='#{app_user}'
HOST_NAME='#{mysql[:hostname]}'
USER='#{mysql[:user]}'
PASSWORD='#{mysql][:password]}'

mysql -h $HOST_NAME -u root -p"root" -e "DROP USER '$APP_USER'@'$HOST_NAME';"
mysql -h $HOST_NAME -u root -p"root" -e "CREATE USER '$APP_USER'@'$HOST_NAME' IDENTIFIED BY '$APP_USER';"

mysql -h $HOST_NAME -u root -p"root" -e "grant all privileges on *.* to '$APP_USER'@'$HOST_NAME' identified by '$APP_USER' with grant option;"
mysql -h $HOST_NAME -u root -p"root" -e "grant all privileges on *.* to '$APP_USER'@'%' identified by '$APP_USER' with grant option;"


#######################################
[create_mysql_schema]

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'
HOST_NAME='#{mysql[:hostname]}'
USER='#{mysql[:user]}'
PASSWORD='#{mysql[:password]}'

mysql -h $HOST_NAME -u root -p"root" -e "create database $SCHEMA;"


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
[create_postgres_user]

PATH=$PATH:/usr/local/bin

APP_USER='#{app_user}'

createuser -s -d -r $APP_USER


#######################################
[create_postgres_schema]

PATH=$PATH:/usr/local/bin

APP_USER='#{app_user}'
SCHEMA='#{schema}'

createdb -U $APP_USER $SCHEMA


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

if [ "$STARTED" = "true" ] ; then
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

NAME="#{name%}"

TEMPFILE="$(mktemp XXXXXXXX)"
launchctl list | grep $NAME > $TEMPFILE
cat $TEMPFILE
rm $TEMPFILE
