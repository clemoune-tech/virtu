# ─────────────────────────────────────────────────────────────
# Paramètres globaux de l'infrastructure
# Ces valeurs s'appliquent à TOUTES les VMs sauf surcharge dans vms.tf
# ─────────────────────────────────────────────────────────────

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
  description = "Pool de stockage par défaut"
  type        = string
  default     = "local-lvm"
}

variable "default_bridge" {
  description = "Bridge réseau par défaut"
  type        = string
  default     = "vmbr0"
}