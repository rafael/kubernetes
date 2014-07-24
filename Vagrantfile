# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Require a recent version of vagrant otherwise some have reported errors setting host names on boxes
Vagrant.require_version ">= 1.6.2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # The number of minions to provision
  num_minion = (ENV['KUBERNETES_NUM_MINIONS'] || 3).to_i

  # ip configuration
  master_ip = "10.245.1.2"
  minion_ip_base = "10.245.2."
  minion_ips = num_minion.times.collect { |n| minion_ip_base + "#{n+2}" }
  minion_ips_str = minion_ips.join(",")

  # Determine the OS platform to use
  kube_os = ENV['KUBERNETES_OS'] || "fedora"

  # OS platform to box information
  kube_boxes = YAML.load_file('vagrant_kube_boxes.yml')
  fail "Couldn't find box #{kube_os} in vagrant_kube_boxes.yml" unless kube_boxes[kube_os]
  # Kubernetes master
  config.vm.define "master" do |master|
    master.vm.box = kube_boxes[kube_os]["name"]
    master.vm.box_url = kube_boxes[kube_os]["box_url"]
    master.vm.provision "shell", inline: "/vagrant/cluster/vagrant/provision-master.sh #{master_ip} #{num_minion} #{minion_ips_str}"
    master.vm.network "private_network", ip: "#{master_ip}"
    master.vm.hostname = "kubernetes-master"
  end

  # Kubernetes minion
  num_minion.times do |n|
    config.vm.define "minion-#{n+1}" do |minion|
      minion_index = n+1
      minion_ip = minion_ips[n]
      minion.vm.box = kube_boxes[kube_os]["name"]
      minion.vm.box_url = kube_boxes[kube_os]["box_url"]
      minion.vm.provision "shell", inline: "/vagrant/cluster/vagrant/provision-minion.sh #{master_ip} #{num_minion} #{minion_ips_str} #{minion_ip}"
      minion.vm.network "private_network", ip: "#{minion_ip}"
      minion.vm.hostname = "kubernetes-minion-#{minion_index}"
    end
  end
end
