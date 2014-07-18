

 # provisions npm application dependencies


# provisions bower application dependencies
execute 'bower install' do
    cwd '/srv/www/admin/current/'
    command 'bower install'
end