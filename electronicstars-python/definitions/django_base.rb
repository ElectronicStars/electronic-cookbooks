define :django_setup do
  deploy = params[:deploy_data]
  application = params[:app_name]
  python_base_setup do
    deploy_data deploy
    app_name application
  end
  celery = Hash.new
  celery.update node["deploy_django"]["celery"] || {}
  celery.update deploy["django_celery"] || {}
  node.normal[:deploy][application]["django_celery"] = celery

end

define :django_configure do
  deploy = params[:deploy_data]
  application = params[:app_name]
  run_action = params[:run_action] || :restart
  Chef::Log.info("Run Actions:")
  Chef::Log.info(run_action)
  # Make sure we have up to date attribute settings
  deploy = node[:deploy][application]
  if deploy[:deploy_to] && (node[:deploy][application]["initially_deployed"] || ::File.exist?(deploy[:deploy_to]))
    celery = Hash.new
    celery.update node["deploy_django"]["celery"] || {}
    celery.update deploy["django_celery"] || {}
    node.normal[:deploy][application]["django_celery"] = celery

    if celery["djcelery"] && celery["enabled"]
      django_djcelery do
        deploy_data node[:deploy][application]
        app_name application
      end
    elsif celery["enabled"]
      django_celery do
        deploy_data node[:deploy][application]
        app_name application
      end
    end
    # if run_action
    #   supervisor_service application do
    #     action run_action
    #   end
    # end
  end
end
