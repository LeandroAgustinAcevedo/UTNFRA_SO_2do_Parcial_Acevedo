#!/bin/bash

PRIMER_DISCO="$(sudo fdisk -l | grep "2 GiB" | head -n1 | awk -F' ' '{print $2}' | awk -F':' '{print $1}')"
SEGUNDO_DISCO="$(sudo fdisk -l | grep "1 GiB" | head -n1 | awk -F' ' '{print $2}' | awk -F':' '{print $1}')"

echo "Trabajando en el disco de 2GB: '${PRIMER_DISCO}'"
sudo fdisk "$PRIMER_DISCO" << EOF
n




t

8E
w
EOF

echo "Trabajando en el disco de 1GB: '${SEGUNDO_DISCO}'"
sudo fdisk "$SEGUNDO_DISCO" << EOF
n




t

82
w
EOF

sudo wipefs -a ${PRIMER_DISCO}1

sudo vgcreate vg_datos ${PRIMER_DISCO}1
sudo vgcreate vg_temp ${SEGUNDO_DISCO}1

sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap

sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_workareas
sudo mkswap /dev/mapper/vg_temp-lv_swap

sudo mkdir /work/

sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker/
sudo mount /dev/mapper/vg_datos-lv_workareas /work/
sudo swapon /dev/mapper/vg_temp-lv_swap

sudo systemctl restart docker
sudo systemctl status docker

