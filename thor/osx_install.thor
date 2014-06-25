$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'osx_provision/osx_provision'

class OsxInstall < Thor
  @installer = OsxProvision.new self, ".osx_provision.json", [File.expand_path("project_scripts.sh", File.dirname(__FILE__))]

  class << self
    attr_reader :installer
  end

  desc "all", "Installs all required packages"
  def all
    invoke :brew
    invoke :rvm
    invoke :qt

    invoke :mysql
    invoke :mysql_restart

    invoke :init_launch_agent

    invoke :postgres
    invoke :postgres_restart

    invoke :jenkins
    invoke :jenkins_restart

    invoke :selenium

    invoke :ruby

    invoke :postgres_create_user
    invoke :postgres_create_schemas

    invoke :mysql_create_user
    invoke :mysql_create_schemas
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
