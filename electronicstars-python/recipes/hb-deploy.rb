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
  celery = "celery-#{application}"
  commandCelery = "#{::File.join(deploy[:deploy_to], 'shared', 'env', 'bin', 'celery')} worker --app=backend.celery --loglevel INFO"
  supervisor_service celery do
    directory ::File.join(deploy[:deploy_to], "current")
    command commandCelery
    user deploy[:user]
    autostart true
    autorestart true
    action :enable
  end
  

  supervisor_service celery do
    action :restart
  end
 


end
