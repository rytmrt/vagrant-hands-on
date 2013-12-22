# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "CentOS-release-6.5"

  # http://localhost:8080でウェブページにアクセスできるようにする設定
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # 外部ネットワークのIPアドレスを取得する
  config.vm.network :public_network

  # 共有フォルダを設定
  config.vm.synced_folder "./share", "/vagrant"

  # 自動インストール設定
  config.vm.provision :shell, :path => "provisons/install.sh"
end
