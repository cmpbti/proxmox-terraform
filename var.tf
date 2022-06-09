variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = true
}

variable "vm-config" {
  type        = map(any)
  description = "Configurções que serão carregada na VM"

  default = {
    "user"              = "ubuntu"
    "psswd-user"        = "SenhaDoServidor"
    "key-pub-pub"       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDF3MqCfdELF9VQVdsTear//kbTBoOpTl1uIUURRp0fxc/Cjj3oKDejT81FPZwANc8KocdYMCaOWiH89L2kkxM+yheWcNBMeRsEv3R7XgFlnxkxMD9udlB9i56oPjNhpwXhmQNB06nvekVY9OW4ODARIvHWgpo/EqBAbc1GdhHeHptPCy9ebXwDNBjo62bSZYBnu2iv2bYRyqpRqP69jmR4/Bw6nl5M28ycd5dgIdC8KCh5k7Y3kRRXeDQQBIwjSn6lEocXI3TyJW75nfrSkYL/9SBgnVCk5GP5GS/y/f+5Tfb4ZVUjL3alWl1wfMg7M1eDidefKyZc2ZTpk9qP07lXIf7Am9hEOqEgkmU2RJoHe7HjGhcmekB+fq4MSsCpgm8xJ7l4HRGpf6aXeXR2a7B7lPnN5lHL3uIEFZS7fTgxINrnjQGgvVBbZMm3XBFxt8XECDLQOlM7MHF9ymzsUeS9JrC/zQlUnfpkdm6VNj61GOv4noFE3LvRNsF31jzIwbE= giovani"
    "imagem-base"       = "ubuntu2204"
    "imagem-resultante" = "teste-prod" # Nome da VM
    "num-vms"           = 2 # Número de VMs que deseja criar
    "id-vm"             = 20
    "cpu_core_vm"       = 2
    "socket_cpu_vm"     = 1
    "memoria"           = 2048
    "tamanho-disco"     = "5G"
  }
  sensitive = false
}