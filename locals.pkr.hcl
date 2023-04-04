local cloud-init {
  expression = {
    "/meta-data"   = ""
    "/vendor-data" = ""
    "/user-data"   = <<-EOT
    #cloud-config
    fqdn: builder.nethserver.org
    manage_etc_hosts: localhost
    ssh_authorized_keys:
      - ${data.sshkey.install.public_key}
    chpasswd:
      expire: True
      list:
      - root:Nethesis,1234
    EOT
  }
}
