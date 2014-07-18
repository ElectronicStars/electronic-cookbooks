include_recipe "rabbitmq::default"
include_recipe "rabbitmq::mgmt_console"

rabbitmq_user "mike" do
  password "123456"
  action :add
end