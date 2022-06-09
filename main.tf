terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      #version = "2.9.10"
      version = "2.8.0"
    }
  }
}

resource "proxmox_vm_qemu" "clona-vm" {
  count                  = var.vm-config.num-vms
  target_node            = "pve"
  clone                  = var.vm-config.imagem-base
  name                   = "${var.vm-config.imagem-resultante}-${count.index}"
  os_type                = "cloud-init"
  ciuser                 = var.vm-config.user
  cipassword             = var.vm-config.psswd-user
  vmid                   = "${var.vm-config.id-vm}${count.index}"
  agent                  = 1
  boot                   = "c"
  memory                 = var.vm-config.memoria
  cpu                    = "kvm64"
  cores                  = var.vm-config.cpu_core_vm
  sockets                = var.vm-config.socket_cpu_vm
  define_connection_info = true
  # ipconfig0              = "ip=dhcp" # Caso queira deixar o dhcp ativado descomentar essa linha
  ipconfig0 = "ip=192.168.1.4${count.index}/24,gw=192.168.1.1"
  numa      = true

  sshkeys = <<EOF
   ${var.vm-config.key-pub-pub}
EOF

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = var.vm-config.tamanho-disco
    #   backup  = 1
    #   ssd     = 1
    #   discard = "on"
  }

  network {
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
    queues    = 0
    rate      = 0
    tag       = -1
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = "192.168.1.4${count.index}"
  }

  # Executando comandos remotos na VM
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
    ]
  }

  # Copiando um arquivo para a VM
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  # Executando um script na VM
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
    ]
  }
}

output "proxmox-vm-output" {
  value = [proxmox_vm_qemu.clona-vm[*].name, proxmox_vm_qemu.clona-vm[*].default_ipv4_address]
}