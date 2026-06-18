# Virtu — Infrastructure-as-Code & Automatisation Multi-VMs

Ce dépôt regroupe l'ensemble des configurations nécessaires au provisionnement automatique, à la sécurisation réseau et à la gestion de configuration d'une infrastructure virtuelle (Proxmox / KVM). 

Le projet combine **OpenTofu** pour l'orchestration des machines virtuelles, **Cloud-Init** pour le pré-provisionnement, et **Ansible** pour le déploiement applicatif, la sécurité pare-feu et la supervision.

---

## 🛠️ Stack Technique & Architecture

* **Orchestration (IaC) :** `OpenTofu` (provider Proxmox Telmate)
* **Initialisation OS :** `Cloud-Init` (Socle minimal de paquets : vim, curl, sudo, nftables, fail2ban, rsync)
* **Gestion de Configuration :** `Ansible` (Playbooks modulaires orchestrés par un fichier maître)

---

## 📁 Structure Réelle du Dépôt

```text
virtu/
├── ansible/
│   ├── inventory/
│   │   └── hosts.yml          # Inventaire des cibles (Bastion, Web, DB, Zabbix...)
│   ├── playbooks/
│   │   ├── site.yml           # Playbook MAÎTRE ordonnançant tout le déploiement
│   │   ├── socle.yml          # Applique le socle commun à toutes les machines
│   │   ├── bastion.yml        # Déploiement spécifique du bastion d'administration
│   │   ├── web.yml            # Déploiement de la stack Web
│   │   └── bastion_access.yml # Isolation et restriction des accès SSH
│   ├── roles/
│   │   ├── bastion/           # Outils d'administration & configuration SSH du bastion
│   │   ├── bastion_access/    # Verrouillage des accès SSH sur l'infra cible
│   │   ├── nginx/             # Installation de Nginx et gestion des templates web
│   │   ├── socle_commun/      # Configuration globale (Zabbix Agent 7.0, nftables, etc.)
│   │   └── zabbix_server/     # Configuration dédiée au serveur de supervision
│   └── ansible.cfg            # Paramètres globaux d'Ansible
└── cloud-init/
    ├── meta-data.yml          # Métadonnées d'instance (Hostname, Instance ID)
    ├── network-config.yml     # Configuration réseau des interfaces
    └── user-data.yml          # Clés SSH, utilisateurs et paquets de base initiaux
