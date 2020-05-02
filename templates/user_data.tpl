#!/bin/bash

##############
# Install archlinux workstation
##############

prepare_env()
{
        echo 'export PATH=$PATH:/home/arch/.local/bin' >> /home/arch/.bashrc
        pacman -Sy --noconfirm git
}

install_workstation_private_key()
{
cat << 'EOF' > /home/arch/.ssh/id_pub
${workstation_private_key}
EOF
}

prepare_env
install_workstation_private_key

git clone https://github.com/coregen/terraform-aws-archlinux-workstation.git /tmp/workstation

chmod +x /tmp/workstation/modules/install-workstation/install-workstation
/tmp/workstation/modules/install-workstation/install-workstation
