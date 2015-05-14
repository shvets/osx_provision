#!/bin/sh

#######################################
[prepare]
# Initial work

#xcodebuild -license

mkdir #{home}/Library/LaunchAgents/


#######################################
[brew]
# Installs homebrew

ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

brew update
brew doctor

brew tap homebrew/dupes
brew tap homebrew/versions


#######################################
[brew_cask]

PATH=$PATH:/usr/local/bin

brew install caskroom/cask/brew-cask


#######################################
[cask_apps]

PATH=$PATH:/usr/local/bin

brew cask install firefox
brew cask install google-chrome
brew cask install flux
brew cask install iterm2
brew cask install jenkins-menu
brew cask install sublime-text3
brew cask install unrarx
brew cask install iterm2
brew cask install vlc


#######################################
[rvm]
# Installs rvm

PATH=$PATH:/usr/local/bin
USER_HOME="#{node.home}"

curl -L https://get.rvm.io | bash

source $USER_HOME/.rvm/scripts/rvm


#######################################
[git]
# Installs git

PATH=$PATH:/usr/local/bin

brew install git


#######################################
[svn]
# Installs svn

PATH=$PATH:/usr/local/bin

brew install svn


#######################################
[ruby]
# Installs ruby

PATH=$PATH:/usr/local/bin

rvm install 1.9.3


#######################################
[node]
# Installs node

brew install node


#######################################
[jenkins]

PATH=$PATH:/usr/local/bin
USER_HOME="#{node.home}"

brew install jenkins

ln -sfv /usr/local/opt/jenkins/homebrew.mxcl.jenkins.plist $USER_HOME/Library/LaunchAgents


#######################################
[selenium]

PATH=$PATH:/usr/local/bin
USER_HOME="#{node.home}"

brew install selenium-server-standalone

ln -sfv /usr/local/opt/selenium-server-standalone/*.plist $USER_HOME/Library/LaunchAgents


#######################################
[qt]
# Installs qt

PATH=$PATH:/usr/local/bin

brew install qt


#######################################
[mysql]
# Installs mysql server

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
# Restarts mysql server

STARTED='[#{started}]'
USER_HOME='#{node.home}'

if [ "$STARTED" = "[true]" ] ; then
  launchctl unload $USER_HOME/Library/LaunchAgents/homebrew.mxcl.mysql.plist
fi

launchctl load $USER_HOME/Library/LaunchAgents/homebrew.mxcl.mysql.plist


#######################################
[postgres]
# Installs postgresql server

PATH=$PATH:/usr/local/bin
USER_HOME="#{node.home}"

brew install postgres

ln -sfv /usr/local/opt/postgresql/homebrew.mxcl.postgresql.plist $USER_HOME/Library/LaunchAgents

initdb /usr/local/var/postgres -E utf8

mkdir /var/pgsql_socket/
ln -s /private/tmp/.s.PGSQL.5432 /var/pgsql_socket/


#######################################
[postgres_start]
# Starts postgresql server

USER_HOME="#{node.home}"

launchctl load -w $USER_HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist


#######################################
[postgres_stop]
# Stops postgresql server

USER_HOME="#{node.home}"

launchctl unload -w $USER_HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist



#######################################
[postgres_restart]
# Restarts postgresql server

STARTED="[#{started}]"
USER_HOME="#{node.home}"

if [ "$STARTED" = "[true]" ] ; then
  launchctl unload -w $USER_HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
fi

launchctl load -w $USER_HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist


#######################################
[postgres_create_user]
# Creates postgres user

PATH=$PATH:/usr/local/bin

APP_USER='#{postgres.app_user}'

createuser -s -d -r $APP_USER


#######################################
[postgres_drop_user]
# Drops postgres user

PATH=$PATH:/usr/local/bin

APP_USER='#{postgres.app_user}'

dropuser $APP_USER


#######################################
[postgres_create_schema]
# Creates postgres schema

PATH=$PATH:/usr/local/bin

APP_USER='#{postgres.app_user}'
SCHEMA='#{schema}'

createdb -U $APP_USER $SCHEMA


#######################################
[postgres_drop_schema]
# Drops postgres schema`

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'

dropdb $SCHEMA


#######################################
[mysql_create_user]
# Creates mysql user

PATH=$PATH:/usr/local/bin

HOST_NAME='#{mysql.hostname}'
APP_USER='#{mysql.app_user}'
MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE USER '$APP_USER'@'$HOST_NAME' IDENTIFIED BY '$APP_USER';"
mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* to '$APP_USER'@'$HOST_NAME' IDENTIFIED BY '$APP_USER' WITH GRANT OPTION;"


#######################################
[mysql_drop_user]
# Drops mysql user

PATH=$PATH:/usr/local/bin

HOST_NAME='#{mysql.hostname}'
USER='#{mysql.user}'
PASSWORD='#{mysql.password}'
APP_USER='#{mysql.app_user}'

mysql -h $HOST_NAME -u$USER -p$PASSWORD -e "DROP USER '$APP_USER'@'$HOST_NAME';"


#######################################
[mysql_create_schema]
# Creates mysql schema

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'

HOST_NAME='#{mysql.hostname}'
MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "create database $SCHEMA;"


#######################################
[mysql_drop_schema]
# Drops mysql schema

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'

HOST_NAME='#{mysql.hostname}'
MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "drop database $SCHEMA;"


#######################################
[jenkins_restart]

STARTED="[#{started}]"
USER_HOME="#{node.home}"

if [ "$STARTED" = "[true]" ] ; then
  launchctl unload $USER_HOME/Library/LaunchAgents/homebrew.mxcl.jenkins.plist
fi

launchctl load $USER_HOME/Library/LaunchAgents/homebrew.mxcl.jenkins.plist


#######################################
[selenium_restart]

STARTED="[#{started}]"
USER_HOME="#{node.home}"

if [ "$STARTED" = "[true]" ] ; then
  launchctl unload $USER_HOME/Library/LaunchAgents/homebrew.mxcl.selenium-server-standalone.plist
fi

launchctl load $USER_HOME/Library/LaunchAgents/homebrew.mxcl.selenium-server-standalone.plist


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
