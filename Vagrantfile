# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.define :web do |web|
    web.vm.hostname = "web"
    web.vm.network :private_network, ip: "192.168.33.10"
  end
  config.vm.define :app do |app|
    app.vm.hostname = "app"
    app.vm.network :private_network, ip: "192.168.33.20"
  end
end
