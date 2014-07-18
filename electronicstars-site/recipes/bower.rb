
include_recipe 'nodejs::install_from_source'
include_recipe 'nodejs::npm'

# defines npm packages to install globally
default.admin.application.npm_packages = {
  'grunt-cli' => '0.1.6',
  'bower'     => '0.8.5'
}


# provisions global npm packages
node.admin.application.npm_packages.each_pair do |pkg, ver|
  npm_package pkg do
    version ver
  end
end