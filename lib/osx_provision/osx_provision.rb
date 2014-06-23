require 'osx_provision/generic_provision'

class OsxProvision < GenericProvision
  USER_LOCAL_BIN = "/usr/local/bin"

  def initialize config_file_name=".osx_provision.json", scripts_file_names=[]
    scripts_file_names.unshift(File.expand_path("osx_provision_scripts.sh", File.dirname(__FILE__))) # make it first

    super
  end

  def prepare
    env['password'] = ask_password("Enter password for #{env[:node][:user]}: ")

    run(server_info.merge(capture_output: false, sudo: true), "prepare", env)
  end

  def brew
    installed = package_installed("#{USER_LOCAL_BIN}/brew")

    if installed
      puts "homebrew already installed."
    else
      run(server_info, "brew", env)
    end
  end

  def rvm
    installed = package_installed "#{ENV['HOME']}/.rvm/bin/rvm"

    if installed
      puts "rvm already installed."
    else
      run(server_info, "rvm", env)
    end
  end

  def npm
    installed = package_installed "#{USER_LOCAL_BIN}/npm"

    if installed
      puts "npm already installed."
    else
      run(server_info, "npm", env)
    end
  end

  def qt
    installed = package_installed "#{USER_LOCAL_BIN}/qmake"

    if installed
      puts "qt already installed."
    else
      run(server_info, "qt", env)
    end
  end

  def init_launch_agent
    run(server_info, "init_launch_agent", env)
  end

  def mysql
    installed = package_installed "#{USER_LOCAL_BIN}/mysql"

    if installed
      puts "mysql already installed."
    else
      run(server_info, "mysql", env)
    end
  end

  def mysql_restart
    started = service_started("homebrew.mxcl.mysql")

    run(server_info, "mysql_restart", env.merge({started: started}))
  end

  def postgres
    installed = package_installed "#{USER_LOCAL_BIN}/postgres"

    if installed
      puts "postgres already installed."
    else
      run(server_info, "postgres", env)
    end
  end

  def postgres_restart
    started = service_started("homebrew.mxcl.postgres")

    run(server_info, "postgres_restart", env.merge({started: started}))
  end

  def postgres_stop
    run server_info, "postgres_stop", env
  end

  def postgres_start
    run server_info, "postgres_start", env
  end

  def ruby
    installed = package_installed "#{ENV['HOME']}/.rvm/rubies/ruby-1.9.3-p527/bin/ruby"

    if installed
      puts "ruby already installed."
    else
      run(server_info, "ruby", env)
    end
  end

  def jenkins
    installed = package_installed "/usr/local/opt/jenkins/libexec/jenkins.war"

    if installed
      puts "jenkins already installed."
    else
      run(server_info, "jenkins", env)
    end
  end

  def jenkins_restart
    started = service_started("homebrew.mxcl.jenkins")

    run(server_info, "jenkins_restart", env.merge({started: started}))
  end

  def selenium
    installed = package_installed "/usr/local/opt/selenium-server-standalone/selenium-server-standalone*.jar"

    if installed
      puts "selenium already installed."
    else
      run(server_info, "selenium", env)
    end
  end

  def selenium_restart
    started = service_started("homebrew.mxcl.selenium-server-standalone")

    run(server_info, "selenium_restart", env.merge({started: started}))
  end

  def postgres_create_user
    run(server_info, "postgres_create_user", env)
  end

  def postgres_create_schemas
    env[:postgres][:app_schemas].each do |schema|
      run(server_info, "postgres_create_schema", env.merge(schema: schema))
    end
  end

  def postgres_drop_schemas
    env[:postgres][:app_schemas].each do |schema|
      run(server_info, "postgres_drop_schema", env.merge(schema: schema))
    end
  end

  def postgres_drop_user
    run(server_info, "postgres_drop_user", env)
  end

  def mysql_create_user
    run(server_info, "mysql_create_user", env)
  end

  def mysql_drop_user
    run(server_info, "mysql_drop_user", env)
  end

  def mysql_create_schemas
    env[:mysql][:app_schemas].each do |schema|
      run(server_info, "mysql_create_schema", env.merge(schema: schema))
    end
  end

  def mysql_drop_schemas
    env[:mysql][:app_schemas].each do |schema|
      run(server_info, "mysql_drop_schema", env.merge(schema: schema))
    end
  end

  private

  def service_started name
    result = run server_info.merge(:suppress_output => true, :capture_output => true),
                 "service_started", env.merge({name: name})

    result.chomp.size > 0
  end

  def package_installed package_path
    result = run server_info.merge(:suppress_output => true, :capture_output => true),
                 "package_installed", env.merge({package_path: package_path})

    result.chomp == package_path
  end

end
