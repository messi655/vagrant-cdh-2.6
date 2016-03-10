#!/bin/bash
export JAVA_HOME=/usr/local/java
JAVA_ARCHIVE=jdk-7u51-linux-x64.gz
	
function fileExists {
	FILE=/vagrant/resources/$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

function disableFirewall {
	echo "disabling firewall"
	service iptables save
	service iptables stop
	chkconfig iptables off
}

function installLocalJava {
	echo "installing oracle jdk"
	FILE=/vagrant/resources/$JAVA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteJava {
	echo "install open jdk"
	yum install -y java-1.7.0-openjdk.x86_64
}

function setupJava {
	echo "setting up java"
	if fileExists $JAVA_ARCHIVE; then
		ln -s /usr/local/jdk1.7.0_51 /usr/local/java
	else
		ln -s /usr/lib/jvm/jre /usr/local/java
	fi
}

function setupEnvVars {
	echo "creating java environment variables"
	#if fileExists $JAVA_ARCHIVE; then
	#	echo export JAVA_HOME=/usr/local/jdk1.7.0_51 >> /etc/profile.d/java.sh
	#else
	#	echo export JAVA_HOME=/usr/lib/jvm/jre >> /etc/profile.d/java.sh
	#fi
	echo export JAVA_HOME=/usr/local/java >> /etc/profile.d/java.sh
	echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile.d/java.sh
}

function installJava {
	if fileExists $JAVA_ARCHIVE; then
		installLocalJava
	else
		installRemoteJava
	fi
}

function installCDHRepo {
	echo "install CDH repo"
	rpm -Uvh http://archive.cloudera.com/cdh5/one-click-install/redhat/6/x86_64/cloudera-cdh-5-0.x86_64.rpm
	rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
}

function cleanRepo {
	echo "install hadoop from remote file"
	yum clean all
}

function installHadoop {
	echo "install hadoop by yum"
	yum install -y hadoop-yarn-resourcemanager hadoop-hdfs-namenode hadoop-yarn-nodemanager hadoop-hdfs-datanode hadoop-mapreduce hadoop-mapreduce-historyserver
}

function addHDFSVagranttoSudo {
	echo "Add vagrant and hdfs to sudo files"
	echo "hdfs    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
	echo "vagrant ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
}

function copyHadoopConfigfile {
	echo "Copy hadoop config file"
	FILE=/vagrant/resources/*
	cp $FILE /etc/hadoop/conf/
}

function formatNamenode {
	echo "Format namenode"
	sudo mkdir /var/lib/hadoop-hdfs/cache/hdfs/dfs/name/current
	sudo chown hdfs:hdfs -R /var/lib/hadoop-hdfs/cache/hdfs/
	sudo -u hdfs hadoop namenode -format
}

function startHadoopService {
	echo "start hadoop services"
	service hadoop-hdfs-namenode start
	service hadoop-hdfs-datanode start
	service hadoop-yarn-resourcemanager start
	service hadoop-yarn-nodemanager start
}

function createTmp {
	echo "Create tmp folder and set permission"
	sudo -u hdfs hadoop dfs -mkdir /tmp/
	sudo -u hdfs hadoop dfs -chmod 755 /tmp/
	sudo -u hdfs hadoop dfs -chown -R mapred /tmp/
}

function startHistoryserver {
	echo "Start History server"
	service hadoop-mapreduce-historyserver start
}



disableFirewall
installJava
setupJava
setupEnvVars
installCDHRepo
cleanRepo
installHadoop
addHDFSVagranttoSudo
copyHadoopConfigfile
formatNamenode
startHadoopService
createTmp
startHistoryserver