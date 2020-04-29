#!/bin/bash

##############
# Install archlinux workstation
##############

install_system_packages()
{
        pacman -Syyu
        pacman -S git wget 
}

configure_dotfiles()
{
        
        git clone https://github.com/andecy64/dotfiles /tmp
        cp -rf /tmp/dotfiles /home/arch
}

prepare_env()
{
        echo 'export PATH=$PATH:/home/arch/.local/bin' >> /home/arch/.bashrc
}

install_workstation_private_key()
{
cat << 'EOF' > /home/arch/.ssh/id_pub
${workstation_private_key}
EOF
}

prepare_env
install_workstation_private_key
