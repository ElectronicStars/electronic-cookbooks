include_recipe 'nodejs'
npm_package "bower" do
  action :install
end

