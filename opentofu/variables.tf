# ── Infrastructure Proxmox ────────────────────────────────────────────────────

variable "proxmox_api_ip" {
  description = "Adresse IP de l'API Proxmox"
  type        = string
  default     = "192.168.10.3"
}

variable "proxmox_node" {
  description = "Nœud Proxmox par défaut pour le déploiement"
  type        = string
  default     = "COGITUX-SRV-02"
}

variable "template_name" {
  description = "Nom exact du template source dans Proxmox"
  type        = string
  default     = "Template"
}

variable "default_storage" {
  description = "Pool de stockage Proxmox cible"
  type        = string
  default     = "local-lvm"
}

variable "default_bridge" {
  description = "Bridge réseau par défaut"
  type        = string
  default     = "vmbr0"
}

# ── Cloud-init — Réseau ───────────────────────────────────────────────────────

variable "default_nic_name" {
  description = "Nom de l'interface réseau dans les VMs clonées (vérifier avec 'ip link show')"
  type        = string
  default     = "ens18"
}

variable "default_dns1" {
  description = "DNS primaire injecté par cloud-init"
  type        = string
  default     = "8.8.8.8"
}

variable "default_dns2" {
  description = "DNS secondaire injecté par cloud-init"
  type        = string
  default     = "1.1.1.1"
}

# ── Cloud-init — Accès SSH ────────────────────────────────────────────────────

variable "ssh_public_key" {
  description = "Clé SSH publique injectée dans toutes les VMs (contenu de ~/.ssh/id_ed25519.pub)"
  type        = string
  sensitive   = true
}

# ── Accès SSH au nœud Proxmox (pour upload des snippets) ─────────────────────

variable "proxmox_ssh_user" {
  description = "Utilisateur SSH pour accéder au nœud Proxmox"
  type        = string
  default     = "root"
}

variable "proxmox_ssh_private_key_path" {
  description = "Chemin local vers la clé privée SSH pour accès Proxmox"
  type        = string
  default     = "~/.ssh/id_ed25519"
}