#!/usr/bin/env bash

server=$1
hostname=$2
hostip=$3

sudo su - root -c "echo $hostname > /etc/hostname"

sudo cat << EOF >> /etc/bash.bashrc
sudo hostname $hostname
EOF

sudo cat << EOF >> /etc/hosts
$hostip $hostname $server
EOF
sudo hostname $hostname

sudo su - root -c "echo redhat|passwd --stdin root"
sudo su - root -c "sed -i '/PasswordAuthentication/ s/no/yes/' /etc/ssh/sshd_config && service sshd restart"

