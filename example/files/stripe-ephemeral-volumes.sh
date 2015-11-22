#!/bin/bash
logFile="/var/log/volume-setup.log"
mountPoint="/media/striped-ephemeral"
stripeDevice="/dev/md127"
declare -a blockDevices=(`find /dev/xvd* |grep -v xvda |tr '\n' ' '`)

# Umount the pre-mounted devices:
function unmountPreMountedDevices {
    echo "Unmounting /mnt ..." >>${logFile}
    umount /mnt
}


# Create a striped volume:
function createStripeVolume {
    echo "Creating striped volume (${stripeDevice}) using {{ '${#blockDevices[@]}' }} devices (${blockDevices[@]}) ..." >>${logFile}
    echo y | mdadm --create ${stripeDevice} --level=raid0 --raid-devices=${#blockDevices[@]} ${blockDevices[@]}
}


# Make an ext4 FS:
function formatVolume {
    echo "Creating ext4 filesystem ($1) ..." >>${logFile}
    mkfs.ext4 $1
}


# Mount the FS:
function mountFS {
    echo "Creating mount-mount (${mountPoint}) ..." >>${logFile}
    mkdir -p ${mountPoint}

    echo "Adding $1 to /etc/fstab ..." >>${logFile}
    echo "$1 ${mountPoint} auto defaults,nobootwait,noatime 0 0" >>/etc/fstab

    echo "Mounting new device ($1) to ${mountPoint} ..." >>${logFile}
    mount ${mountPoint}
}


################ Begin:
echo "Preparing volume ..." >${logFile}

# Un-mount any pre-mounted devices (/mnt):
unmountPreMountedDevices

# Make a striped volume (if we were given more than 1 device):
if [ ${#blockDevices[@]} -eq 1 ]
then
    stripeDevice=${blockDevices[0]}
else
    createStripeVolume
fi

# Format the striped-volume:
formatVolume "${stripeDevice}"

# Mount the striped-volume:
mountFS "${stripeDevice}"

echo "Done." >>${logFile}


