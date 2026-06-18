# Virtu — Infrastructure-as-Code & Automatisation Multi-VMs

Ce dépôt regroupe l'ensemble des configurations nécessaires au provisionnement automatique, à la sécurisation réseau et à la gestion de configuration d'une infrastructure virtuelle (Proxmox / KVM). 

Le projet combine **OpenTofu** pour l'orchestration des machines virtuelles, **Cloud-Init** pour le pré-provisionnement, et **Ansible** pour le durcissement système, la sécurité pare-feu et la supervision.

---

## 🛠️ Stack Technique & Architecture

* **Orchestration (IaC) :** `OpenTofu` (provider Proxmox Telmate)
* **Initialisation OS :** `Cloud-Init` (Socle minimal de paquets : vim, curl, sudo, nftables, fail2ban, rsync)
* **Gestion de Configuration :** `Ansible` (Playbooks modulaires orchestrés par un fichier maître)

---

## 📁 Structure du Dépôt

```text
virtu/
├── ansibles/
│   ├── inventory/
│   │   └── hosts.yml          # Inventaire des cibles (Bastion, Web, DB...)
│   ├── playbooks/
│   │   ├── site.yml           # Playbook MAÎTRE ordonnançant le déploiement
│   │   ├── socle.yml          # Configuration de base pour toutes les VMs
│   │   ├── bastion.yml        # Configuration et outils d'administration du Bastion
│   │   ├── web.yml            # Rôle et configuration du serveur Web
│   │   └── bastion_access.yml # Isolation réseau SSH (Web & DB uniquement via Bastion)
│   ├── roles/
│   │   └── socle_commun/      # Tâches communes (Zabbix 7.0, Timezone, Services)
│   └── ansible.cfg            # Paramètres globaux d'Ansible
├── cloud-init/
│   ├── meta-data.yml          # Métadonnées d'instance (Hostname, IDs)
│   ├── network-config.yml     # Configuration réseau des interfaces
│   └── user-data.yml          # Paquets de base, clés SSH et utilisateurs initiaux
└── opentofu/
    ├── main.tf & VMs.tf       # Définition des ressources et clones Proxmox
    ├── providers.tf           # Configuration du provider Telmate Proxmox
    └── secret.tfvars          # Variables d'authentification chiffrées/privées
