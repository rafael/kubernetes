# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # The number of minions to provision
  master_ip = "10.245.1.2"
  num_minion = 1
  minion_ip_base = "10.245.2."
  minion_ips = ""
  for i in 1..num_minion
    minion_ips = minion_ips + minion_ip_base + "#{i+1} "
  end

  # Determine the OS platform to use
  kube_os = ENV['KUBE_OS']
  kube_os = "fedora" unless kube_os && kube_os != ""

  # OS platform to box information
  kube_box = {
    "fedora" => {
      "name" => "fedora20",
      "box_url" => "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_fedora-20_chef-provisionerless.box"
    },
    "debian" => {
      "name" => "debian74",
      "box_url" => "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_debian-7.4_chef-provisionerless.box"
    }
  }

  # Kubernetes master
  config.vm.define "master" do |config|
    config.vm.box = kube_box[kube_os]["name"]
    config.vm.box_url = kube_box[kube_os]["box_url"]
    config.vm.provision "shell", inline: "/vagrant/cluster/provisioners/provision-master.sh #{master_ip} #{num_minion} #{minion_ips}"
    config.vm.network "private_network", ip: "#{master_ip}"
    config.vm.hostname = "kubernetes-master"
  end

  # Kubernetes minion
  for i in 1..num_minion
    config.vm.define "minion-#{i}" do |config|
      config.vm.box = kube_box[kube_os]["name"]
      config.vm.box_url = kube_box[kube_os]["box_url"]
      config.vm.provision "shell", inline: "/vagrant/cluster/provisioners/provision-minion.sh #{master_ip} #{num_minion} #{minion_ips}"
      config.vm.network "private_network", ip: "#{minion_ip_base}#{i+1}"
      config.vm.hostname = "kubernetes-minion-#{i}"
    end
  end

end