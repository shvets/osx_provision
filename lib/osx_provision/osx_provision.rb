require 'osx_provision/generic_provision'

class OsxProvision < GenericProvision
  USER_LOCAL_BIN = "/usr/local/bin"

  def prepare
    env['password'] = ask_password("Enter password for #{env[:node][:user]}: ")

    run(server_info.merge(capture_output: false, sudo: true), "prepare", env)
  end

  def homebrew_install
    installed = package_installed("#{USER_LOCAL_BIN}/brew")

    if installed
      puts "homebrew already installed."
    else
      run(server_info, "brew", env)
    end
  end

  def rvm_install
    installed = package_installed "#{ENV['HOME']}/.rvm/bin/rvm"

    if installed
      puts "rvm already installed."
    else
      run(server_info, "rvm", env)
    end
  end

  def npm_install
    installed = package_installed "#{USER_LOCAL_BIN}/npm"

    if installed
      puts "npm already installed."
    else
      run(server_info, "npm", env)
    end
  end

  def qt_install
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

  def mysql_install
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

  def postgres_install
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

  def ruby_install
    installed = package_installed "#{ENV['HOME']}/.rvm/rubies/ruby-1.9.3-p429/bin/ruby"

    if installed
      puts "ruby already installed."
    else
      run(server_info, "ruby", env)
    end
  end

  def jenkins_install
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

  def selenium_install
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

  def postgres_create user, schemas
    create_postgres_user user, schemas.first

    schemas.each do |schema|
      create_postgres_schema user, schema
    end
  end

  def postgres_drop user, schemas
    schemas.each do |schema|
      drop_postgres_schema schema
    end

    drop_postgres_user user, schemas.first
  end

  def postgres_test schema
    result = get_postgres_schemas schema

    puts result
  end

  private

  def service_started name
    result = run server_info.merge(:suppress_output => true, :capture_output => true),
                 "service_started", env.merge({name: name})

    result.chomp.size > 0
  end

  def create_mysql_user app_user
    run(server_info, "create_mysql_user", env.merge({app_user: app_user}))
  end

  def create_mysql_schema schema
    schema_exists = mysql_schema_exist?(config[:mysql][:hostname], config[:mysql][:user], config[:mysql][:password], schema)

    run(server_info, "create_mysql_schema", env) unless schema_exists
  end

  def mysql_schema_exist?(hostname, user, password, schema)
    get_mysql_schemas(hostname, user, password, schema).include?(schema)
  end

  def get_mysql_schemas hostname, user, password, schema
    command = "#{USER_LOCAL_BIN}/mysql -h #{hostname} -u #{user} -p\"#{password}\" -e \"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA;\""

    run_command server_info.merge(:suppress_output => true, :capture_output => true), command
  end

  def postgres_schema_exist?(schema)
    get_postgres_schemas(schema).include?(schema)
  end

  def get_postgres_schemas schema
    command = "#{USER_LOCAL_BIN}/psql -d #{schema} -c '\\l'"

    run_command server_info.merge(:suppress_output => true, :capture_output => true), command
  end

  def create_postgres_user app_user, schema
    run(server_info, "create_postgres_user", env.merge({app_user: app_user, schema: schema}))
  end

  def drop_postgres_user app_user, schema
    command = "#{USER_LOCAL_BIN}/dropuser #{app_user}"

    run_command server_info, command
  end

  def create_postgres_schema app_user, schema
    run(server_info, "create_postgres_schema", env.merge({app_user: app_user, schema: schema}))
  end

  def drop_postgres_schema schema
    command = "#{USER_LOCAL_BIN}/dropdb #{schema}"

    run_command server_info, command
  end

  def package_installed package_path
    result = run server_info.merge(:suppress_output => true, :capture_output => true),
                 "package_installed", env.merge({package_path: package_path})

    result.chomp == package_path
  end

end
