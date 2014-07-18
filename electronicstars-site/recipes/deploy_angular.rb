# provisions npm application dependencies
execute 'npm install' do
    command '/usr/local/bin/npm install'
end

# provisions bower application dependencies
execute 'bower install' do
    command 'bower install'
end