# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant::Config.run do |config|
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.define :core do |django_config|

    django_config.vm.box = "hashicorp/precise32"
    django_config.vm.box_url = "https://vagrantcloud.com/hashicorp/precise32/version/1/provider/virtualbox.box"
    django_config.vm.forward_port 80, 8080
    django_config.gui = true
    # django_config.vm.provision :shell, :inline => 'apt-get update;  apt-get install python-software-properties --no-upgrade --yes; add-apt-repository ppa:brightbox/ruby-ng-experimental; apt-get update'
    # django_config.vm.provision :shell, :inline => 'if [[ `chef-solo --version` != *11.10* ]]; then apt-get install build-essential bash-completion ruby2.0 ruby2.0-dev --no-upgrade --yes; gem2.0 install chef --version 11.10.0 --no-rdoc --no-ri --conservative; fi'

    django_config.vm.provision :chef_solo do |chef|
      chef.log_level = :info


      chef.json = {
          "deploy" => {
              "core" => {
                  "custom_type" => "django"
              }
          }
      }
      chef.run_list = [
          "recipe[electronic-python::django]",
      # "recipe[electronic-python::django-configure]",
      ]
    end
  end
end