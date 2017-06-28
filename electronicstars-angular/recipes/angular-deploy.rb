node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  include_recipe "nodejs::npm"
  execute 'npm install ' do
    cwd ::File.join(deploy[:deploy_to], 'current')
    user deploy[:user]
    group deploy[:group]
  end
  execute 'bower install -F ' do
    cwd ::File.join(deploy[:deploy_to], 'current')
    user deploy[:user]
    group deploy[:group]
    environment ({'HOME' => '/home/deploy'})
  end

  execute 'gulp build' do
    cwd ::File.join(deploy[:deploy_to], 'current')
    user deploy[:user]
    group deploy[:group]
    environment ({'HOME' => '/home/deploy'})
  end

end