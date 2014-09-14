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

    invoke :mysql_restart
    invoke :postgres_restart
    invoke :jenkins_restart
    invoke :selenium_restart
  end

  desc "special", "Installs special packages"
  def special
    invoke :node
    invoke :jenkins

    invoke :selenium
  end

  desc "create_env", "Installs environment"
  def create_env
    invoke :postgres_create_user
    invoke :postgres_create_schemas

    invoke :mysql_create_user
    invoke :mysql_create_schemas
  end

  desc "delete_env", "Deletes environment"
  def delete_env
    invoke :postgres_drop_schemas
    invoke :postgres_drop_user

    invoke :mysql_drop_schemas
    invoke :mysql_drop_user
  end

  desc "all", "Installs all required packages"
  def all
    invoke :general
    invoke :special
    invoke :create_env
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
