node[:deploy].each do |application, deploy|

  django_setup do
    deploy_data deploy
    app_name application
  end
  # include_recipe 'nginx::default'

end
