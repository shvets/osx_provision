$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'osx_provision/osx_provision'

class OsxInstall < Thor
  @installer = OsxProvision.new self, ".osx_provision.json"

  class << self
    attr_reader :installer
  end

  desc "general", "Installs general packages"
  def general
    invoke :prepare

    invoke :brew
    invoke :qt

    invoke :rvm
    invoke :ruby

    invoke :mysql
    invoke :postgres
    invoke :jenkins
    invoke :selenium

    invoke :mysql_restart
    invoke :postgres_restart
    invoke :jenkins_restart
    invoke :selenium_restart
  end

  desc "app", "Installs app"
  def app
    invoke :postgres_create_user
    invoke :postgres_create_schemas

    invoke :mysql_create_user
    invoke :mysql_create_schemas
  end

  desc "all", "Installs all required packages"
  def all
    invoke :general
    invoke :app
  end

  desc "postgres_create_schemas", "Initializes postgres schemas"
  def postgres_create_schemas
    OsxInstall.installer.postgres_create_schemas
  end

  desc "postgres_drop_schemas", "Drops postgres schemas"
  def postgres_drop_schemas
    OsxInstall.installer.postgres_drop_schemas
  end

  desc "mysql_create_schemas", "Initializes mysql schemas"
  def mysql_create_schemas
    OsxInstall.installer.mysql_create_schemas
  end

  desc "mysql_drop_schemas", "Drops mysql schemas"
  def mysql_drop_schemas
    OsxInstall.mysql_drop_schemas
  end

end
