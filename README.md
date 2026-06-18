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


Durcissement SSH : L'authentification par mot de passe et l'accès SSH en Root sont désactivés au profit d'une politique stricte d'accès par paires de clés asymétriques.
    ├── network-config.yml     # Configuration réseau des interfaces
    └── user-data.yml          # Clés SSH, utilisateurs et paquets de base initiaux
```
---
🚀 Pipeline de Déploiement
Étape 1 : Provisionnement avec OpenTofu
OpenTofu clone les templates de machines virtuelles directement sur Proxmox et leur injecte les configurations réseau et les utilisateurs initiaux définis dans le dossier cloud-init/.

Bash
cd opentofu
tofu init
tofu apply -var-file="secret.tfvars"
Étape 2 : Gestion de configuration avec Ansible (site.yml)
Une fois les machines virtuelles démarrées, le playbook maître site.yml orchestre la configuration complète de l'infrastructure en suivant l'ordre logique suivant :

socle.yml (Toutes les VMs) : Applique le rôle socle_commun. Il met à jour les dépôts, configure la Timezone (Europe/Paris), installe l'agent Zabbix 7.0 relié au serveur central, et applique une politique nftables par défaut ultra-stricte (Default DROP Input).

bastion.yml (Le Bastion) : Applique le rôle bastion. Il sécurise l'accès SSH, crée les comptes utilisateurs pour les administrateurs (groupe sysadmins), déploie leurs clés SSH et installe les outils d'administration et de diagnostic indispensables (tmux, nmap, nc, dig, htop, git). Il valide ensuite la connectivité vers le Web, la DB et le serveur Zabbix.

web.yml (Serveur Web) : Applique le rôle nginx pour installer, configurer et déployer les templates du site ou de l'application Web (index.html.j2).

bastion_access.yml (Isolation réseau) : Applique le rôle bastion_access. Il modifie la configuration SSH de l'infrastructure (web, db) pour s'assurer que seul le Bastion soit techniquement capable d'ouvrir des sessions d'administration SSH sur ces serveurs.

🔒 Focus Sécurité
nftables par défaut : Bloque tout flux entrant injustifié (Default DROP). Seuls le trafic local (lo), le Ping (ICMP), le SSH (22) et les flux de supervision de l'agent Zabbix (10050) restreints à l'IP du serveur Zabbix sont tolérés.

