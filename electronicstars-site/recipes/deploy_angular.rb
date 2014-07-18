

 # provisions npm application dependencies


# provisions bower application dependencies
execute 'bower install' do
    cwd '/srv/www/admin/'
    command 'bower install -v'
end