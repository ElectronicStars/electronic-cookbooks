

 # provisions npm application dependencies
execute 'npm install' do
    cwd '/srv/www/admin'
    command '/usr/local/bin/npm install'
end

# provisions bower application dependencies
execute 'bower install' do
    cwd '/srv/www/admin'
    command 'bower install'
end