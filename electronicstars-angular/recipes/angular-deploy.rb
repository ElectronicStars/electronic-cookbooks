execute 'bower install' do
  cwd ::File.join(deploy[:deploy_to], 'current')
  user deploy[:user]
  group deploy[:group]
  command 'bower install -F'
end