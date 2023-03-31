source "digitalocean" "dn" {
  image         = "debian-11-x64"
  region        = "ams3"
  size          = "s-1vcpu-1gb"
  ssh_username  = "root"
  snapshot_name = "ns8-debian-11-{{isotime \"2006-01-02 15:04:05 MST\"}}"
}

source "digitalocean" "rl" {
  image         = "rockylinux-9-x64"
  region        = "ams3"
  size          = "s-1vcpu-1gb"
  ssh_username  = "root"
  snapshot_name = "ns8-rockylinux-9-{{isotime \"2006-01-02 15:04:05 MST\"}}"

}

source "digitalocean" "cs" {
  image         = "centos-stream-9-x64"
  region        = "ams3"
  size          = "s-1vcpu-1gb"
  ssh_username  = "root"
  snapshot_name = "ns8-centos-stream-9-{{isotime \"2006-01-02 15:04:05 MST\"}}"

}

source "digitalocean" "al" {
  image         = "almalinux-9-x64"
  region        = "ams3"
  size          = "s-1vcpu-1gb"
  ssh_username  = "root"
  snapshot_name = "ns8-almalinux-9-{{isotime \"2006-01-02 15:04:05 MST\"}}"

}
