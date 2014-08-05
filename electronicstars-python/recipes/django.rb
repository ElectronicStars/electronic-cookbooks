node[:deploy].each do |application, deploy|
  django_setup do
    deploy_data deploy
    app_name application
  end

  # We don't want to run migrations before updating config files
  migrate = deploy[:migrate]
  node.override[:deploy][application][:migrate] = false
  deploy = node[:deploy][application]
  python_base_deploy do
    deploy_data deploy
    app_name application
  end
  # Back to normal
  node.override[:deploy][application][:migrate] = migrate
  deploy = node[:deploy][application]

  # install requirements
  requirements = Helpers.django_setting(deploy, 'requirements', node)
  if requirements
    Chef::Log.info("Installing using requirements file: #{requirements}")
    pip_cmd = ::File.join(deploy["venv"], 'bin', 'pip')
    execute "#{pip_cmd} install --source=#{Dir.tmpdir} -r #{::File.join(deploy[:deploy_to], 'current', requirements)}" do
      cwd ::File.join(deploy[:deploy_to], 'current')
      user deploy[:user]
      group deploy[:group]
      environment 'HOME' => ::File.join(deploy[:deploy_to], 'shared')
    end
  else
    Chef::Log.debug("No requirements file found")
  end

  django_configure do
    deploy_data deploy
    app_name application
    run_action [] # Don't run actions here
  end
  
  base_command = "#{::File.join(deploy[:deploy_to], 'shared', 'env', 'bin', 'uwsgi')} --http :8080 --module wsgi"
  supervisor_service application do
    action :enable
    command base_command
    directory ::File.join(deploy[:deploy_to], "current")
    autostart true
    user deploy[:user]
  end

  # supervisor_service application do
  #   action :start
  #
  # end


  # execute "uwsgi --http :8080 --module #{application}.wsgi" do
  #   cwd ::File.join(deploy[:deploy_to], 'current')
  #   user deploy[:user]
  #   group deploy[:group]
  #
  # end
  # uwsgi_bin = File.join(deploy[:deploy_to], 'shared/env/bin/uwsgi')
  # Chef::Log.info("uwsgi_bin :" + uwsgi_bin)
  # uwsgi_service application do
  #   uwsgi_bin uwsgi_bin
  #   home_path ::File.join(deploy[:deploy_to], 'current')
  #   host "127.0.0.1"
  #   port 8080
  #   pid_path "/var/run/uwsgi-app.pid"
  #   worker_processes 1
  #   uid deploy[:user]
  #   gid deploy[:group]
  #   app "wsgi:application"
  #
  # end


end
