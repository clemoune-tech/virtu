# ─────────────────────────────────────────────────────────────────────────────
# DÉFINITION DES VMs
#
# Pour ajouter une VM  → copier un bloc dans vm_definitions
# Pour modifier une VM → changer les valeurs dans son bloc
# Pour supprimer une VM → supprimer son bloc
#
# Champs cloud-init obligatoires par VM :
#   ci_hostname  → nom d'hôte de la VM
#   ci_ip_cidr   → adresse IP avec masque (ex: 192.168.10.201/24)
#   ci_gateway   → passerelle du VLAN de la VM
# ─────────────────────────────────────────────────────────────────────────────

locals {

  # ── Valeurs par défaut communes ──────────────────────────
  vm_defaults = {
    node      = var.proxmox_node
    storage   = var.default_storage
    bridge    = var.default_bridge
    memory    = 1024
    cores     = 1
    disk_size = "32G"
    onboot    = true
    # Cloud-init — réseau
    nic_name = var.default_nic_name
    ci_dns1  = var.default_dns1
    ci_dns2  = var.default_dns2
  }

  # ── Définition des VMs ────────────────────────────────────
  vm_definitions = {

    bastion = {
      vmid        = 501
      description = "Bastion — point d'administration — VLAN Management"
      memory      = 1024
      cores       = 1
      vlan        = 10
      # Cloud-init
      ci_hostname = "bastion"
      ci_ip_cidr  = "192.168.10.50/24"
      ci_gateway  = "192.168.10.1"
    }

    web = {
      vmid        = 502
      description = "Serveur web — VLAN Services"
      memory      = 2048
      cores       = 1
      vlan        = 10
      # Cloud-init — adapter à ton adressage VLAN 10
      ci_hostname = "web"
      ci_ip_cidr  = "192.168.10.51/24"
      ci_gateway  = "192.168.10.1"
    }

    db = {
      vmid        = 503
      description = "Base de données — VLAN Services"
      memory      = 2048
      cores       = 1
      vlan        = 10
      # Cloud-init — adapter à ton adressage VLAN 10
      ci_hostname = "db"
      ci_ip_cidr  = "192.168.10.52/24"
      ci_gateway  = "192.168.10.1"
    }

  }

  # ── Fusion automatique définitions + valeurs par défaut ──
  # Ne pas modifier cette ligne
  vms = {
    for name, vm in local.vm_definitions : name => merge(local.vm_defaults, vm)
  }
}