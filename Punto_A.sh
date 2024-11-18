#!/bin/bash
PRIMER_DISCO="$(sudo fdisk -l | grep "2 GiB" | awk -F' ' '{print $2}' | awk -F':' '{print $1}')"
echo "Trabajando en el disco de 2GB: '${PRIMER_DISCO}'"
sudo fdisk "$PRIMER_DISCO" << EOF
n



+1.5G
t

8E
n



+5M
t

8E
w
EOF
echo "Trabajando en el disco de 1GB: '${SEGUNDO_DISCO}'"
sudo fdisk "$SEGUNDO_DISCO" << EOF
n



+512M
t

82
w
EOF
sudo wipefs -a ${PRIMER_DISCO}1
sudo wipefs -a ${PRIMER_DISCO}2
sudo vgcreate vg_datos ${PRIMER_DISCO}1 ${PRIMER_DISCO}2
sudo vgcrate vg_temp ${SEGUNDO_DISCO}1
sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap
sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_workareas
sudo mkswap /dev/mapper/vg_temp-lv_swap
sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker/
sudo mount /dev/mapper/vg_datos-lv_workareas /work/
sudo swapon /dev/mapper/vg_temp-lv_swap

