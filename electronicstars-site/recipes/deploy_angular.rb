

 # provisions npm application dependencies
execute 'npm install' do
    cwd default[:deploy][application][:deploy_to]
    command '/usr/local/bin/npm install'
end

# provisions bower application dependencies
execute 'bower install' do
    cwd default[:deploy][application][:deploy_to]
    command 'bower install'
end