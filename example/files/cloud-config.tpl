#cloud-config
user:
disable_root: 0
bootcmd:
 - sed -e /^PermitRootLogin/s/yes/without-password/ -i /etc/ssh/sshd_config

apt_sources:
- source: deb-src http://security.ubuntu.com/ubuntu $RELEASE-security multiverse

repo_update: true
repo_upgrade: all

packages:
 - wget
 - puppet
 - mdadm

runcmd:
 - "pip install awscli"
 - "pip install boto"
 - echo "export MACHINE_CLASS=${role}" > /etc/profile.d/machineclass.tags.sh
 - echo "export ENV_NAME=${environment}" > /etc/profile.d/env.tags.sh

# set the locale
locale: en_GB.UTF-8

# timezone: set the timezone for this instance (ALWAYS user UTC!)
timezone: UTC

final_message: "System boot (via cloud-init) is COMPLETE, after $UPTIME seconds. Finished at $TIMESTAMP"

output:
  all: '| tee -a /var/log/cloud-init-output.log'
