Chef::Log.info("lolazo")
Chef::Log.info(node[:deploy])
node[:deploy].each do |application, deploy|
  Chef::Log.info("lolazo2")
  django_setup do
    deploy_data deploy
    app_name application
  end
end
