terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
    # Nécessaire pour null_resource (upload SSH des snippets)
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://${var.proxmox_api_ip}:8006/api2/json"
  pm_tls_insecure = true
  # Credentials lus depuis les variables d'environnement :
  #   export PM_API_TOKEN_ID="tofu-user@pve!tofu-token"
  #   export PM_API_TOKEN_SECRET="..."
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
}