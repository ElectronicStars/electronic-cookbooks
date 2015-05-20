include_recipe 'nginx'
application = node[:deploy][application_name]
if application[:ssl_support]


  # certificate

  directory "#{node[:nginx][:dir]}/ssl" do
    action :create
    owner "root"
    group "root"
    mode 0600
  end

  template "#{node[:nginx][:dir]}/ssl/#{application[:domains].first}.crt" do
    cookbook 'nginx'
    mode '0600'
    source "ssl.key.erb"
    variables :key => application[:ssl_certificate]
    notifies :restart, "service[nginx]"
    only_if do
      application[:ssl_support]
    end
  end

  template "#{node[:nginx][:dir]}/ssl/#{application[:domains].first}.key" do
    cookbook 'nginx'
    mode '0600'
    source "ssl.key.erb"
    variables :key => application[:ssl_certificate_key]
    notifies :restart, "service[nginx]"
    only_if do
      application[:ssl_support]
    end
  end

  template "#{node[:nginx][:dir]}/ssl/#{application[:domains].first}.ca" do
    cookbook 'nginx'
    mode '0600'
    source "ssl.key.erb"
    variables :key => application[:ssl_certificate_ca]
    notifies :restart, "service[nginx]"
    only_if do
      application[:ssl_support] && application[:ssl_certificate_ca]
    end
  end

end
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
