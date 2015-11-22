The files under "builtin" were taken from a PR on the Terraform repo (https://github.com/hashicorp/terraform/pull/3416). I applied these to the master branch of Terraform and built it according to the README.md. The configuration in the "example" directory works as expected, and generates what appears to be a proper multi-part userdata.

I've included two sample outputs to show the difference between plain, base64, and gzipped base64.
