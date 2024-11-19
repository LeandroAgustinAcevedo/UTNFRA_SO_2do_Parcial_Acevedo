#!/bin/bash

cd $HOME/UTN-FRA_SO_Examenes/202406/ansible/roles/2do_parcial

mkdir -p templates
cd templates

cat << EOF > alumno_template.j2
Nombre: Leandro Agustin		Apellido: Acevedo
Division: 115
EOF 

IP="$(curl ifconfig.me)"
DISTRIBUCION="$(grep -i PRETTY_NAME /etc/os-release | awk -F'=' '{print $2}')"
CORES="$(nproc)"

cat << EOF > equipo_template.j2
IP: $IP
Distribucion: $DISTRIBUCION
Cantidad de Cores: $CORES
EOF

cd ../

cat << EOF > tasks/main.yml
- name: Crear directorio alumno
  file:
    path: /tmp/2do_parcial/alumno
    state: directory
    mode: '0755'

- name: Crear directorio equipo
  file:
    path: /tmp/2do_parcial/equipo
    state: directory
    mode: '0755'

- name: Generar archivo datos_alumno.txt
  template:
    src: alumno_template.j2
    dest: /tmp/2do_parcial/alumno/datos_alumno.txt
    mode: '0644'

- name: Generar archivo datos_equipo.txt
  template:
    src: equipo_template.j2
    dest: /tmp/2do_parcial/equipo/datos_equipo.txt
    mode: '0644'

- name: Validar y configurar sudoers para grupo 2PSupervisores
  ansible.builtin.lineinfile:
    path: /etc/sudoers
    state: present
    regexp: '^%2PSupervisores ALL='
    line: '%2PSupervisores ALL=(ALL) NOPASSWD:ALL'
    validate: /usr/sbin/visudo -cf %s
EOF

cd $HOME/UTN-FRA_SO_Examenes/202406/ansible/

ansible-playbook -i inventory playbook.yml

