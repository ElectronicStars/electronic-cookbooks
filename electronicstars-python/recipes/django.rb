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


  command = "#{::File.join(deploy[:deploy_to], 'shared', 'env', 'bin', 'uwsgi')} --socket /tmp/core.socket --chmod-socket=644 --buffer-size=32768 --workers=5 --master --module core.wsgi"
  supervisor_service application do
    directory ::File.join(deploy[:deploy_to], "current")
    command command
    user deploy[:user]

    autostart true
    autorestart true
    action :enable
    stderr_logfile ::File.join(deploy[:deploy_to], "shared", "log", "error.log")
    stdout_logfile ::File.join(deploy[:deploy_to], "shared", "log", "current.log")
  end
  websocket = "ws-#{application}"
  websocket_command = "#{::File.join(deploy[:deploy_to], 'shared', 'env', 'bin', 'uwsgi')} --http-socket /tmp/ws-core.socket --chmod-socket=644 --gevent 5000 --workers=2 --master --module core.wswsgi"
  supervisor_service websocket do
    directory ::File.join(deploy[:deploy_to], "current")
    command websocket_command
    user deploy[:user]

    autostart true
    autorestart true
    action :enable
    stderr_logfile ::File.join(deploy[:deploy_to], "shared", "log", "ws-error.log")
    stdout_logfile ::File.join(deploy[:deploy_to], "shared", "log", "ws-current.log")
  end
  celery = "celery-#{application}"
  celery_command = "#{::File.join(deploy[:deploy_to], 'shared', 'env', 'bin', 'celery')} worker --app=core.celery -B"
  supervisor_service celery do
    directory ::File.join(deploy[:deploy_to], "current")
    command celery_command
    user deploy[:user]
    autostart true
    autorestart true
    action :enable
    stderr_logfile ::File.join(deploy[:deploy_to], "shared", "log", "error_celery.log")
    stdout_logfile ::File.join(deploy[:deploy_to], "shared", "log", "current_celery.log")
  end
  supervisor_service celery do
    action :restart
  end
  supervisor_service application do
    action :restart
  end
  supervisor_service websocket do
    action :restart
  end


end
