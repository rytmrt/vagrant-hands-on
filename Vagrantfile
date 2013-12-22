# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "CentOS-release-6.5"

  # http://localhost:8080$B$G%&%'%V%Z!<%8$K%"%/%;%9$G$-$k$h$&$K$9$k@_Dj(B
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # $B30It%M%C%H%o!<%/$N(BIP$B%"%I%l%9$r<hF@$9$k(B
  config.vm.network :public_network

  # $B6&M-%U%)%k%@$r@_Dj(B
  config.vm.synced_folder "./share", "/vagrant"

  # $B<+F0%$%s%9%H!<%k@_Dj(B
  config.vm.provision :shell, :path => "provisons/install.sh"
end
