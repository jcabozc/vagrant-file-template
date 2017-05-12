#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

# for centos6 only
#doc http://mirrors.ustc.edu.cn/salt/

# bash salt_install.sh 14.04 2016.11 master/minion minionid saltMaster
# sysVersion could be [12.04, 14.04, 16.04]
sysVersion=$1
# saltVersion could be 2016.11 or latest
saltVersion=$2
# Type: master or minion
salttype=$3
# minion id
minionid=$4
# salt server
saltMaster=$5



# install saltstack repo
#wget -O - https://repo.saltstack.com/apt/ubuntu/$sysVersion/amd64/$saltVersion/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
#echo deb http://repo.saltstack.com/apt/ubuntu/$sysVersion/amd64/$saltVersion `lsb_release -sc` main | sudo tee /etc/apt/sources.list.d/saltstack.list
#yum  install https://repo.saltstack.com/yum/redhat/salt-repo-latest-1.el6.noarch.rpm -y
yum install https://mirrors.ustc.edu.cn/salt/yum/redhat/salt-repo-2016.11-1.el6.noarch.rpm -y
sed -i '/baseurl/ s/repo\.saltstack\.com/mirrors\.ustc\.edu\.cn\/salt/' /etc/yum.repos.d/salt-2016.11.repo
yum clean expire-cache


if [ $salttype == "master" ]; then
    yum install salt-master salt-minion -y 
    cat << EOF > master
fileserver_backend:
  - roots
  # - git

file_ignore_regex:
  - '/\.svn($|/)'
  - '/\.git($|/)'

hash_type: sha512

file_roots:
  base:
    - /srv/salt

pillar_roots:
  base:
    - /srv/pillar
EOF
    sudo su - root -c "cat /home/vagrant/master > /etc/salt/master && service salt-master start && chkconfig salt-master on"

else 
    yum -y install salt-minion -y
fi

cat << EOF > /etc/salt/minion
master: $saltMaster
id: $minionid
EOF


# test part
# sleep 10
# salt-key -a $(cat /etc/salt/minion_id) -y
# master_finger: $(salt-key -F | grep master.pub | awk '{print $2}')

# automatically add salt-key
service salt-minion restart && chkconfig salt-minion on
sleep 3
if [ $salttype == "master" ]; then
    yes|salt-key -A
fi

