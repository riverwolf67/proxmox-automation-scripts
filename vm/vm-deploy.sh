#!/bin/bash

VM_TYPE=${1:-"debian"} && echo "VM_TYPE $VM_OS"
VMID=$(pvesh get /cluster/nextid) && echo "VMID $VMID"
source /dev/stdin <<< "$(wget -qLO - https://raw.githubusercontent.com/riverwolf67/proxmox-automation-scripts/main/vm/vm-functions.sh)"

bash -c "$(wget -qLO - https://github.com/community-scripts/ProxmoxVE/raw/main/vm/debian-vm.sh)"
bash -c "$(wget -qLO - https://github.com/riverwolf67/proxmox-automation-scripts/raw/main/vm/debian-up.sh)"

echo "Verify functions sourced correctly..."
echo "function expand_disk" && functions | grep expand_disk

# qm disk resize $VMID scsi0 20G
