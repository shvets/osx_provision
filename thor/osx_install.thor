$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'osx_provision/osx_provision'

class OsxInstall < Thor
  def self.installer
    @@installer ||= OsxProvision.new ".osx_provision.json"
  end

  def self.create_thor_script_methods parent_class
    installer.script_list.each do |name, value|
      title = installer.script_title(value)

      title = title.nil? ? name : title

      parent_class.send :desc, name, title
      parent_class.send(:define_method, name.to_sym) do
        self.class.installer.send "#{name}".to_sym
      end
    end
  end

  create_thor_script_methods self

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
    self.class.installer.postgres_create_schemas
  end

  desc "postgres_drop_schemas", "Drops postgres schemas"
  def postgres_drop_schemas
    self.class.installer.postgres_drop_schemas
  end

  desc "mysql_create_schemas", "Initializes mysql schemas"
  def mysql_create_schemas
    self.class.installer.mysql_create_schemas
  end

  desc "mysql_drop_schemas", "Drops mysql schemas"
  def mysql_drop_schemas
    self.class.installer.mysql_drop_schemas
  end

end
