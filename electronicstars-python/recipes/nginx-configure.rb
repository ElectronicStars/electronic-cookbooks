include_recipe 'nginx'

template "#{node[:nginx][:dir]}/sites-available/core" do
  source "core.nginx.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[nginx]", :delayed
end

link "#{node[:nginx][:dir]}/sites-enabled/default" do
  action :delete
end

link "#{node[:nginx][:dir]}/sites-enabled/core" do
  to "#{node[:nginx][:dir]}/sites-available/core"
  owner "root"
  group "root"
  mode 0644
end