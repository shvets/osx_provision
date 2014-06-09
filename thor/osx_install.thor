$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'osx_provision/osx_installer'

class OsxInstall < Thor
  attr_reader :installer

  def initialize *params
    @installer = OsxProvision.new ".osx_provision.json", "osx_provision_scripts.sh"

    super *params
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

    invoke :postgres_create
  end

  desc "prepare", "prepare"
  def prepare
    installer.prepare
  end

  desc "brew", "Installs homebrew"
  def brew
    installer.homebrew_install
  end

  desc "rvm", "Installs rvm"
  def rvm
    installer.rvm_install
  end

  desc "npm", "Installs npm"
  def npm
    installer.npm_install
  end

  desc "qt", "Installs qt"
  def qt
    installer.qt_install
  end

  desc "init_launch_agent", "Inits launch agent"
  def init_launch_agent
    installer.init_launch_agent
  end

  desc "mysql", "Installs mysql server"
  def mysql
    installer.mysql_install
  end

  # brew uninstall mysql

  desc "mysql_restart", "Restarts mysql server"
  def mysql_restart
    installer.mysql_restart
  end

  desc "postgres", "Installs postgres server"
  def postgres
    installer.postgres_install
  end

  desc "postgres_restart", "Restarts postgres server"
  def postgres_restart
    installer.postgres_restart
  end

  desc "postgres_stop", "Stop postgres server"
  def postgres_stop
    installer.postgres_stop
  end

  desc "postgres_start", "Start postgres server"
  def postgres_start
    installer.postgres_start
  end

  desc "ruby", "Installs ruby"
  def ruby
    installer.ruby_install
  end

  desc "jenkins", "Installs jenkins server"
  def jenkins
    installer.jenkins_install
  end

  desc "jenkins_restart", "Restart jenkins server"
  def jenkins_restart
    installer.jenkins_restart
  end

  desc "selenium", "Installs selenium server"
  def selenium
    installer.selenium_install
  end

  desc "selenium_restart", "Restarts selenium server"
  def selenium_restart
    installer.selenium_restart
  end

  desc "postgres_create", "Initializes postgres project schemas"
  def postgres_create
    installer.postgres_create env["app_user"], env["app_schemas"]
  end

  desc "postgres_drop", "Drops postgres project schemas"
  def postgres_drop
    installer.postgres_drop env["app_user"], env["app_schemas"]
  end

  desc "postgres_test", "Test postgres schemas"
  def postgres_test
    installer.postgres_test env["app_user"]
  end

  desc "test", "test"
  def test
    puts "test"
  end

end
