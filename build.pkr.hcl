build {

  sources = [
    "source.digitalocean.rl",
    "source.digitalocean.cs",
    "source.digitalocean.al",
    "source.qemu.dn",
    "source.qemu.cs",
    "source.qemu.rl",
    "source.qemu.al",
  ]

  provisioner "shell" {
    inline = [
      "systemctl is-system-running --wait || true",
    ]
  }

  provisioner "shell" {
    env = {
      "NS8_TWO_STEPS_INSTALL" : "1"
    }
    execute_command = "sudo env {{ .Vars }} {{ .Path }}"
    inline = [
      "curl https://raw.githubusercontent.com/NethServer/ns8-core/main/core/install.sh > install.sh",
      "chmod +x install.sh",
      "./install.sh ghcr.io/nethserver/core:two_steps_install",
    ]
  }

  provisioner "file" {
    content     = <<-EOT
    [Unit]
    Wants=network-online.target
    After=network-online.target
    ConditionFirstBoot=yes
    ConditionPathExists=!/var/lib/nethserver/node/ready
    [Service]
    Type=oneshot
    ExecStart=/bin/bash /var/lib/nethserver/node/install-finalize.sh
    ExecStartPost=/usr/bin/touch /var/lib/nethserver/node/ready
    RemainAfterExit=yes
    [Install]
    WantedBy=multi-user.target
    EOT
    destination = "/tmp/ns8-install-finalize.service"
  }

  provisioner "shell" {
    execute_command = "sudo env {{ .Vars }} {{ .Path }}"
    inline = ["mv /tmp/ns8-install-finalize.service /etc/systemd/system/"]
  }

  provisioner "shell" {
    except = ["qemu.dn"]
    execute_command = "sudo env {{ .Vars }} {{ .Path }}"
    inline = [ "/sbin/restorecon -v /etc/systemd/system/ns8-install-finalize.service"]
  }

  provisioner "shell" {
    execute_command = "sudo env {{ .Vars }} {{ .Path }}"
    inline = [
      "systemctl daemon-reload",
      "systemctl enable ns8-install-finalize.service",
    ]
  }

  provisioner "shell" {
    execute_command = "sudo env {{ .Vars }} {{ .Path }}"
    inline = [
      "rm install.sh",
      "echo uninitialized > /etc/machine-id",
    ]
  }
}
