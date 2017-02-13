source "https://supermarket.getchef.com"

cookbook 'apt', '3.0.0'
cookbook 'build-essential' , '3.2.0'
cookbook 'line'
cookbook 'mongodb'
cookbook 'npm'
cookbook 'nodejs'
cookbook 'rabbitmq'
cookbook 'redisio'
cookbook 'runit'
cookbook 'supervisor', {:git => "git@github.com:poise/supervisor.git", :branch => 'master'}
cookbook 'python'
cookbook 'ulimit'
cookbook 'uwsgi', {:gitbub => "git@github.com:50onRed/uwsgi.git"}
cookbook 'varnish'
cookbook 'yum'
cookbook 'yum-epel','0.7.1'
cookbook 'ohai', '= 3.0.1'
cookbook 'homebrew', '= 2.1.2'
cookbook 'git', '= 4.6.0'



def opsworks_cookbook(name)
    cookbook name, {:github => "aws/opsworks-cookbooks", :rel => name, :tag => 'release-chef-11.10'}
end

# opsworks_cookbook 'deploy'
# opsworks_cookbook 'dependencies'
# opsworks_cookbook 'gem_support'
# opsworks_cookbook 'scm_helper'
# opsworks_cookbook 'ssh_users'
# opsworks_cookbook 'haproxy'
# opsworks_cookbook 'mod_php5_apache2'
# opsworks_cookbook 'opsworks_agent_monit'
# opsworks_cookbook 'opsworks_commons'
# opsworks_cookbook 'opsworks_initial_setup'
# opsworks_cookbook 'opsworks_java'
# opsworks_cookbook 'opsworks_nodejs'
# cookbook 'electronic-python', {:path => 'electronic-python/'}

# opsworks_cookbook 'ssh_host_keys'
# opsworks_cookbook 'memcached'
# opsworks_cookbook 'mysql'
# opsworks_cookbook 'nginx'
# opsworks_cookbook 'apache2'
# # opsworks_cookbook 'opsworks_bundler'
# # opsworks_cookbook 'opsworks_cleanup'
# # opsworks_cookbook 'opsworks_custom_cookbooks'
# # opsworks_cookbook 'opsworks_ganglia'
# # opsworks_cookbook 'opsworks_rubygems'
# # opsworks_cookbook 'opsworks_shutdown'
# # opsworks_cookbook 'opsworks_stack_state_sync'
# # opsworks_cookbook 'packages'
# # opsworks_cookbook 'passenger_apache2'
# # opsworks_cookbook 'php'
# # opsworks_cookbook 'rails'
# # opsworks_cookbook 'ruby'
# # opsworks_cookbook 'unicorn'
# # opsworks_cookbook 'agent_version'
# # opsworks_cookbook 'ebs'