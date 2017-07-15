#!/usr/bin/env bash

if ! ansible --version | grep ansible;
then
    echo "Installing Ansible"
    sudo apt-get -y install software-properties-common
    sudo apt-add-repository -y ppa:ansible/ansible
    sudo apt-get -y update
    sudo apt-get -y install ansible
else
        echo "Ansible already Installed!"
fi

echo "Installing Ansible Galaxy Modules"
roles_list[0]='geerlingguy.composer,1.4.1'
roles_list[1]='geerlingguy.git,1.1.0'

for role_and_version in "${roles_list[@]}"
do
    role_and_version_for_grep="${role_and_version/,/, }"

    if ! sudo ansible-galaxy list | grep -qw "$role_and_version_for_grep";
    then
            echo "Installing ${role_and_version}"
            sudo ansible-galaxy -f install $role_and_version
    else
        echo "Already installed ${role_and_version}"
    fi
done

# Execute Ansible
echo "-> Executing Ansible"
ansible-playbook /ansible/provision_vagrant.yml -e hostname=vagrant -i /ansible/inventories/hosts --connection=local
