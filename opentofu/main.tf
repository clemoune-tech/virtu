# ─────────────────────────────────────────────────────────────────────────────
# DÉPLOIEMENT — NE PAS MODIFIER CE FICHIER
# Toutes les valeurs sont dans vms.tf
# ─────────────────────────────────────────────────────────────────────────────

resource "proxmox_vm_qemu" "vms" {
  for_each = local.vms

  # ── Identité ─────────────────────────────────────────────
  name        = each.key
  description = each.value.description
  target_node = each.value.node
  vmid        = each.value.vmid

  # ── Source ───────────────────────────────────────────────
  clone      = var.template_name
  full_clone = true

  # ── Comportement ─────────────────────────────────────────
  agent              = 1
  start_at_node_boot = each.value.onboot

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
 disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = each.value.storage
  }
  # ── Cloud-init natif ─────────────────────────────────────
  # Pas de snippets, pas de dépendance au nœud local
  ipconfig0  = "ip=${each.value.ci_ip_cidr},gw=${each.value.ci_gateway}"
  nameserver = "${each.value.ci_dns1} ${each.value.ci_dns2}"
  ciuser     = "ladmin"
  sshkeys    = var.ssh_public_key

  # ── Réseau ───────────────────────────────────────────────
  network {
    id     = 0
    model  = "virtio"
    bridge = each.value.bridge
    tag    = each.value.vlan
  }

  lifecycle {
    ignore_changes = [
      network,
      description,disk,
    ]
  }
}