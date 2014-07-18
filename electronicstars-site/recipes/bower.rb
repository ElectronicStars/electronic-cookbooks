include_recipe "npm"

npm_package "bower" do
  action :install
end
