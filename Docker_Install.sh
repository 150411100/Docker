#!/bin/bash

# Install Docker Service 
# Tyrone.Zhao
# 2020-07-08

echo "Check This OS Enviorment ..........."
sleep 5
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
systemctl stop firewalld
systemctl disable firewalld


echo "Now Install Docker ..........."
sleep 5

# step 1: 安装必要的一些系统工具
yum install -y yum-utils device-mapper-persistent-data lvm2
# Step 2: 添加软件源信息
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# Step 3: 更新并安装Docker-CE
yum makecache fast
yum -y install docker-ce

echo "Update Docker Image Speed Config ......."
sleep 5
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://3z8aa6ul.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload

echo "Start Docker Service ......"
systemctl start docker

status=`systemctl  status docker|grep 'Active:'|awk '{print $2}'`
if [ $status == "active" ]
then
  echo "Docker is running....."
else
  echo "Start Docker Failure!"
fi
