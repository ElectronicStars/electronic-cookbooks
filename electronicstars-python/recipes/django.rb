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

  # cmd = deploy["django_collect_static"].is_a?(String) ? deploy["django_collect_static"] : "collectstatic --noinput"
  # execute "#{::File.join(node[:deploy][application]["venv"], "bin", "python")} manage.py #{cmd}" do
  #   cwd ::File.join(deploy[:deploy_to], 'current')
  #   user deploy[:user]
  #   group deploy[:group]
  # end

  command = "#{::File.join(deploy[:deploy_to], 'shared', 'env', 'bin', 'uwsgi')} --http :80 --http-websockets  --gevent 100 --module wswsgi --socket /tmp/mike.sock"
  supervisor_service application do
    directory ::File.join(deploy[:deploy_to], "current")
    command command
    user 'root'
    autostart true
    autorestart true
    action :enable
    stderr_logfile ::File.join(deploy[:deploy_to], "current", "log", "error.log")
    stdout_logfile ::File.join(deploy[:deploy_to], "current", "log", "current.log")
  end

  celery = "celery-#{application}"
  celery_command = "#{::File.join(deploy[:deploy_to], 'shared', 'env', 'bin', 'python')} manage.py celeryd"
  supervisor_service celery do
    directory ::File.join(deploy[:deploy_to], "current")
    command celery_command
    user deploy[:user]
    autostart true
    autorestart true
    action :enable
    stderr_logfile ::File.join(deploy[:deploy_to], "current", "log", "error_celery.log")
    stdout_logfile ::File.join(deploy[:deploy_to], "current", "log", "current_celery.log")
  end
  supervisor_service celery do
    action :restart
  end
  supervisor_service application do
    action :restart
  end


end
