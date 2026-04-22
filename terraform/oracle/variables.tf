variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_id" {}

variable "ad_index" {
  description = "The index of the Availability Domain to try (0, 1, or 2)"
  type        = number
  default     = 0
}

variable "subnet_id" {}
variable "image_id" {}
variable "ssh_public_key_path" {
  description = "Path to the public SSH key on the host machine"
  default     = "~/.ssh/id_rsa.pub"
}
