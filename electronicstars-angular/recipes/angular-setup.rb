include_recipe 'nodejs::install_from_source'
include_recipe 'nodejs::npm'

include_recipe "npm"
node[:deploy].each do |application, deploy|

  npm_package "bower" do
    action :install
  end

end