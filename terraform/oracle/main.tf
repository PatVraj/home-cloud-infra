# Fetch all available ADs in your current region
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_core_instance" "generated_oci_core_instance" {
  # Dynamically pick the AD based on the bash script's loop
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.ad_index].name
  compartment_id      = var.compartment_id
  display_name        = "oracle-edge"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    memory_in_gbs = "24"
    ocpus         = "4"
  }

  source_details {
    boot_volume_size_in_gbs = "200"
    boot_volume_vpus_per_gb = "20"
    source_id               = var.image_id
    source_type             = "image"
  }

  create_vnic_details {
    assign_ipv6ip             = "false"
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    subnet_id                 = var.subnet_id
  }

  metadata = {
    "ssh_authorized_keys" = file(var.ssh_public_key_path)
  }

  is_pv_encryption_in_transit_enabled = "true"

  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }

  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }

  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "OS Management Hub Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute RDMA GPU Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Auto-Configuration"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Authentication"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Cloud Guard Workload Protection"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
}
