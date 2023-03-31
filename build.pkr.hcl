build {

  sources = [
    "source.digitalocean.dn",
    "source.digitalocean.rl",
    "source.digitalocean.cs",
    "source.digitalocean.al",
  ]

  provisioner "shell" {
    inline = [
      "systemctl is-system-running --wait || true",
    ]
  }

  provisioner "shell" {
    env = {
      "NS8_TWO_STEPS_INSTALL":  "1"
    }
    inline = [
      "curl https://raw.githubusercontent.com/NethServer/ns8-core/main/core/install.sh > install.sh",
      "chmod +x install.sh",
      "./install.sh ghcr.io/nethserver/core:two_steps_install",
      ]
  }

  provisioner "file" {
    content = <<-EOT
    #!/bin/bash
    /var/lib/nethserver/node/install-finalize.sh
    EOT
    destination = "/var/lib/cloud/scripts/per-once/99_ns8-final"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /var/lib/cloud/scripts/per-once/99_ns8-final",
      "rm /var/lib/cloud/sem/config_scripts_per_once.once",
      "rm install.sh",
      "echo uninitialized > /etc/machine-id",
    ]
  }
}
