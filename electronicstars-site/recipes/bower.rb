
include_recipe 'nodejs::install_from_source'
include_recipe 'nodejs::npm'

include_recipe "npm"

npm_package "bower" do
  action :install
end