# So TF knows what to do with "cloudinit" resources:
provider "cloudinit" {}

# Template for the cloud-init's cloud-config:
resource "template_file" "cloud-config-bastard" {
  template = "cloud-config.tpl"

  vars {
    role = "bastard"
    environment = "cruft"
  }
}

# Cloud-init config with 3 parts:
resource "cloudinit_config" "myconfig" {
  gzip = false
  base64_encode = false

  # Part 1: "Wait for internet" boothook:
  part {
    order = 1
    content_type = "text/cloud-boothook"
    content = "${file("files/wait-for-internet.sh")}"
  }

  # Part 2: "Cloud-config":
  part {
    order = 2
    content_type = "text/cloud-config"
    content = "${template_file.cloud-config-bastard.rendered}"
  }

  # Part 3: "stripe ephemeral volumes" script:
  part {
    order = 3
    merge_type = "list(append)+dict(recurse_array)+str()"
    content_type = "text/x-shellscript"
    content = "${file("files/stripe-ephemeral-volumes.sh")}"
  }

}

# Print in stdout (but could just as easily go into a launch-configs userdata):
output "cloud-init-cruft" {
  value = "${cloudinit_config.myconfig.rendered}"
}
