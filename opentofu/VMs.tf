# ─────────────────────────────────────────────────────────────
# DÉFINITION DES VMs
#
# Pour ajouter une VM  → copier un bloc dans vm_definitions
# Pour supprimer une VM → supprimer le bloc correspondant
# Pour modifier une VM  → changer les valeurs dans son bloc
#
# Seuls les champs différents des valeurs par défaut sont nécessaires.
# ─────────────────────────────────────────────────────────────

locals {

  # ── Valeurs par défaut communes à toutes les VMs ──────────
  # Surchargeables VM par VM dans vm_definitions ci-dessous
  vm_defaults = {
    node      = var.proxmox_node
    storage   = var.default_storage
    bridge    = var.default_bridge
    memory    = 1024
    cores     = 1
    disk_size = "32G"
    vlan      = 10
    onboot    = true
  }

  # ── Définition des VMs ────────────────────────────────────
  # Ajouter une VM = ajouter un bloc ici
  vm_definitions = {

    bastion = {
      vmid        = 201
      description = "Bastion — point d'administration — VLAN Management"
      memory      = 1024
      cores       = 1
      vlan        = 10
    }

    web = {
      vmid        = 202
      description = "Serveur web — VLAN Services"
      memory      = 2048
      cores       = 2
      vlan        = 100
    }

    db = {
      vmid        = 203
      description = "Base de données — VLAN Services"
      memory      = 2048
      cores       = 2
      vlan        = 100
    }

    # ── Exemple : ajouter une 4e VM ───────────────────────
    # monitoring = {
    #   vmid        = 204
    #   description = "Serveur de supervision — VLAN Management"
    #   memory      = 4096
    #   cores       = 2
    #   vlan        = 10
    # }

  }

  # ── Fusion automatique définitions + valeurs par défaut ──
  # Ne pas modifier cette ligne
  vms = {
    for name, vm in local.vm_definitions : name => merge(local.vm_defaults, vm)
  }
}