# ─────────────────────────────────────────────────────────────
# Déploiement des VMs — NE PAS MODIFIER CE FICHIER
# Les VMs sont définies dans vms.tf
# ─────────────────────────────────────────────────────────────

resource "proxmox_vm_qemu" "vms" {
  for_each = local.vms

  # ── Identité ─────────────────────────────────────────────
  name        = each.key
  desc        = each.value.description
  target_node = each.value.node
  vmid        = each.value.vmid

  # ── Source ───────────────────────────────────────────────
  clone      = var.template_name
  full_clone = true

  # ── Comportement ─────────────────────────────────────────
  agent  = 1
  onboot = each.value.onboot

  # ── Ressources ───────────────────────────────────────────
  memory = each.value.memory

  cpu {
    cores   = each.value.cores
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  # ── Stockage ─────────────────────────────────────────────
  scsihw = "virtio-scsi-single"
  boot   = "order=scsi0"

  disk {
    slot     = "scsi0"
    type     = "disk"
    size     = each.value.disk_size
    storage  = each.value.storage
    iothread = true
  }

  # ── Réseau ───────────────────────────────────────────────
  network {
    id     = 0
    model  = "virtio"
    bridge = each.value.bridge
    tag    = each.value.vlan
  }

  # ── Protection contre les faux positifs ──────────────────
  # Empêche OpenTofu de vouloir recréer une VM si Proxmox
  # ou cloud-init modifie légèrement la config après création
  lifecycle {
    ignore_changes = [
      disk,
      network,
      desc,
    ]
  }
}