# Introduction

# Getting Started

1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
3. Run ```vagrant box add centos65 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box```
4. Run ```vagrant up``` to create the VM (Change to this folder).
5. Run ```vagrant ssh``` to get into your VM.
6. Run ```vagrant destroy``` when you want to destroy and get rid of the VM.

# Make the VM setup faster
You can make the VM setup even faster if you pre-download Oracle JDK into the /resources directory.

1. /resources/jdk-7u51-linux-x64.gz

The setup script will automatically detect if these files (with precisely the same names) exist and use them instead. If you are using slightly different versions, you will have to modify the script accordingly.

# Web UI
You can check the following URLs to monitor the Hadoop daemons.

1. [NameNode] (http://localhost:50070/dfshealth.html)
2. [DataNode] (http://localhost:50075/dataNodeHome.jsp)
3. [ResourceManager] (http://localhost:8088/cluster)
4. [NodeManager] (http://localhost:8042/node)
5. [JobHistory] (http://localhost:19888/jobhistory)

Note that you point your browser to "localhost" because when the VM is created, it is specified to perform port forwarding from your desktop to the VM.

# Vagrant boxes
A list of available Vagrant boxes is shown at http://www.vagrantbox.es. 

# Vagrant box location
The Vagrant box is downloaded to the ~/.vagrant.d/boxes directory. On Windows, this is C:/Users/{your-username}/.vagrant.d/boxes.

