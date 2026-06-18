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
🧱 Étape 1 : Le Provisionnement avec OpenTofu (et Cloud-Init)
Il faut impérativement commencer par OpenTofu. C'est lui qui va créer l'existence matérielle de tes machines virtuelles (Bastion, Web, DB, Zabbix) sur ton hyperviseur Proxmox.

Pendant qu'OpenTofu crée les VMs, il va automatiquement injecter tes fichiers Cloud-Init (user-data.yml, meta-data.yml, network-config.yml) dans les machines.
C'est donc à ce moment-là, grâce à OpenTofu et Cloud-Init, que tes VMs reçoivent leur premier niveau de configuration :

Leurs adresses IP et configurations réseau.

La création de l'utilisateur initial et de sa clé SSH.

L'installation automatique des tout premiers paquets de base (comme fail2ban, nftables, rsync, vim, curl).

La commande pour lancer OpenTofu :
Place-toi dans ton dossier opentofu et exécute :

Bash
cd opentofu
tofu init
tofu apply -var-file="secret.tfvars"
(Tu devras valider en tapant yes lorsque OpenTofu te le demandera).

🚀 Étape 2 : La Configuration Logicielle et Sécurité avec Ansible
Une fois qu'OpenTofu a terminé son travail et que toutes tes machines virtuelles ont fini de démarrer (compte environ 1 à 2 minutes pour que le Cloud-Init initial soit complètement finalisé à l'intérieur des VMs), tu peux passer à Ansible.

Ansible va se connecter sur les VMs existantes pour installer Zabbix, configurer Nginx, durcir le SSH du bastion, mettre en place tes règles nftables personnalisées et tester tes accès.

La commande pour lancer Ansible :
Place-toi dans ton dossier ansible et exécute le playbook maître site.yml (qui appelle tous les autres dans le bon ordre) :

Bash
cd ../ansible
ansible-playbook -i inventory/hosts.yml playbooks/site.yml

🔒 Focus Sécurité
nftables par défaut : Bloque tout flux entrant injustifié (Default DROP). Seuls le trafic local (lo), le Ping (ICMP), le SSH (22) et les flux de supervision de l'agent Zabbix (10050) restreints à l'IP du serveur Zabbix sont tolérés.

