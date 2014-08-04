node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  execute 'bower install' do
    cwd ::File.join(deploy[:deploy_to], 'current')
    user deploy[:user]
    group deploy[:group]
    command 'bower install '
  end
end