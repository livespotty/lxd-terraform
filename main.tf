terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
    }
  }
}

resource "lxd_storage_pool" "storagepool" {
  name = "storagepool"
  driver = "dir"
}

resource "lxd_volume" "lxdvolume" {
  name = "lxdvolume"
  pool = "${lxd_storage_pool.storagepool.name}"
}

resource "lxd_network" "lxd_network_nat" {
  name = "lxd_network_nat"

  config = {
    "ipv4.address" = "10.0.0.1/24"
    "ipv4.nat"     = "true"
  }
}

resource "lxd_profile" "profile1" {
  name = "profile1"
  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = "${lxd_network.lxd_network_nat.name}"
    }
  }
device {
    type = "disk"
    name = "root"

    properties = {
      pool = "default"
      path = "/"
    }
  }
}

resource "lxd_container" "server1" {
  name      = "server1"
  image     = "ubuntu:20.04"
  ephemeral = false
  profiles = ["profile1"]
  config = {
    "boot.autostart" = true
  }
 
  limits = {
    cpu = 2
  }
device {
    name = "volume1"
    type = "disk"
    properties = {
      path = "/opt/"
      source = "${lxd_volume.lxdvolume.name}"
      pool = "${lxd_storage_pool.storagepool.name}"
    }
  }
}