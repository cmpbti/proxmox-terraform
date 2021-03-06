# Proxmox com Terraform

## Instalação do Terraform
https://www.terraform.io/downloads

## Realizar esses comandos em uma VM em que não esteja em produção, pois o kernel será alterado. 
## Está VM pode ser posteriormente excluida.
Baixar a imagem do sistema operacional desejado. As imagens podem ser encontradas no site [Cloud Images](https://cloud-images.ubuntu.com/)
```bash
    sudo wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
```

Instalação da feramenta virt-customize
```bash
    sudo apt update -y && sudo apt install libguestfs-tools -y
```

Customização da imagem
```bash
    sudo virt-customize --add jammy-server-cloudimg-amd64.img --run-command 'sed -i "68 s/^ */#/" /etc/cloud/cloud.cfg' --install qemu-guest-agent
```

Enviar a imagem customizada para o servidor proxmox
```bash
    scp jammy-server-cloudimg-amd64.img root@192.168.x.x:/root
```

## Preparando a imagem e criando o template no servidor proxmox
```bash
    qm create 9000 --name ubuntu2204 --memory 2048 --net0 virtio,bridge=vmbr0
    qm importdisk 9000 jammy-server-cloudimg-amd64.img local-lvm
    qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
    qm set 9000 --ide2 local-lvm:cloudinit
    qm set 9000 --boot c --bootdisk scsi0
    qm set 9000 --serial0 socket --vga serial0
    qm set 9000 --agent 1
    qm set 9000 --ipconfig0 ip=dhcp
    qm resize 9000 scsi0 5G
    qm template 9000
```

## Clone o repositório
```bash
    git clone https://github.com/cmpbti/proxmox-terraform.git
```

## Edite os arquivos conforme a necessidade
```bash
    credentials.auto.tfvars - informações de conexão com a api.
    var.tf - Configurções que serão carregada na VM.
    main.tf - Explicações nas linhas comentadas.
```

## Inicializar e executar
```bash
    terraform init - inicializar o terraform.
    terraform fmt - formatar o código.
    terraform plan - cria um plano de execução, que permite visualizar as alterações que o Terraform planeja fazer.
    terraform apply - aplica o plano de execução.
```

