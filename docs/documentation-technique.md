# Documentation technique

## 1. Contexte

Ce projet s’inscrit dans un workshop de virtualisation et d’automatisation sur Proxmox.  
L’objectif est de reconstruire une VM source, de la préparer pour un usage reproductible, puis de la convertir en base pour des VMs finales spécialisées.

Le workflow retenu est :
- OpenTofu pour le provisioning ;
- cloud-init pour l’initialisation de la VM ;
- Ansible pour le socle commun et la configuration durable.

## 2. Objectif du socle

La VM source doit servir de base propre pour générer un template Proxmox réutilisable.  
Le socle commun doit rester générique afin de convenir ensuite aux VMs finales du workshop, notamment les rôles bastion, web et db.

Le socle couvre :
- les paquets de base ;
- l’accès SSH ;
- les outils d’administration ;
- la journalisation ;
- la synchronisation de temps ;
- les premiers réglages de sécurité.

## 3. Répartition des responsabilités

### OpenTofu
OpenTofu crée la VM dans Proxmox à partir du template de base.  
Il gère les paramètres d’infrastructure déclaratifs : nom de la VM, CPU, RAM, stockage, réseau et rattachement du disque cloud-init.

### cloud-init
cloud-init applique l’identité initiale au premier démarrage.  
Il configure le hostname, l’utilisateur principal, la clé SSH publique, et le réseau initial.

### Ansible
Ansible applique le socle commun sur la VM démarrée et joignable en SSH.  
Il complète l’installation des paquets nécessaires et durcit la configuration système.

## 4. Arborescence du dépôt

```text
infra-workshop/
├── README.md
├── docs/
├── opentofu/
├── cloud-init/
└── ansible/
```

### 4.1 `opentofu/`
Contient les fichiers de provisionnement déclaratif de la VM.

### 4.2 `cloud-init/`
Contient les données d’initialisation de la VM source.

### 4.3 `ansible/`
Contient l’inventaire, les playbooks et les rôles pour le socle commun.

### 4.4 `docs/`
Contient la documentation technique du projet et les notes de mise en œuvre.

## 5. Choix techniques

### 5.1 Système
La VM source doit être stable, administrable et compatible avec cloud-init et Ansible.  
Les paquets déjà présents sur la VM source sont :
- `python`
- `qemu-guest-agent`
- `cloud-init`
- `openssh-server`

### 5.2 Réseau
Le réseau du lab est basé sur le sous-réseau `192.168.10.0/24`.  
L’adresse IP de la VM source, la passerelle et les DNS doivent être adaptés à l’environnement réel du cluster.

### 5.3 SSH
L’accès initial se fait avec un utilisateur principal créé par cloud-init.  
L’authentification par clé SSH est privilégiée pour la suite de l’administration.

## 6. Fichiers cloud-init

### `user-data.yml`
Contient :
- le hostname ;
- l’utilisateur principal ;
- la clé SSH publique ;
- les paquets ou commandes de premier démarrage si nécessaire.

### `meta-data.yml`
Contient :
- `instance-id` ;
- `local-hostname`.

L’`instance-id` doit être unique par VM et stable dans le temps afin que cloud-init identifie correctement l’instance.

### `network-config.yml`
Contient la configuration réseau de la VM.  
Dans ce projet, la configuration doit être cohérente avec `192.168.10.0/24`.

## 7. Fichiers Ansible

### `ansible.cfg`
Définit les options de base d’Ansible :
- inventaire par défaut ;
- désactivation du contrôle strict des clés SSH si nécessaire dans le lab ;
- paramètres d’exécution.

### `inventory/hosts.yml`
Décrit la VM source, son IP, l’utilisateur de connexion et les paramètres de privilèges.

### `playbooks/socle.yml`
Orchestre l’application du rôle de socle commun.

### `roles/socle_commun/`
Contient les tâches réutilisables pour toutes les futures VMs.

## 8. Socle attendu

Le socle commun doit couvrir au minimum :
- installation des paquets de base ;
- configuration du fuseau horaire ;
- activation de `qemu-guest-agent` ;
- activation de la synchronisation de temps ;
- activation de `fail2ban` ;
- activation de `nftables` ;
- durcissement SSH ;
- redémarrage des services concernés après modification.

## 9. Ordre d’exécution

L’ordre de déploiement doit être respecté :

1. Préparer les fichiers OpenTofu.
2. Lancer `tofu init`.
3. Lancer `tofu plan`.
4. Lancer `tofu apply`.
5. Démarrer la VM.
6. Laisser cloud-init appliquer l’identité initiale.
7. Vérifier la connectivité SSH.
8. Lancer le playbook Ansible.
9. Valider l’état final de la VM source.

## 10. Validation

La VM source est considérée comme valide si :
- elle démarre correctement ;
- elle reçoit la bonne configuration réseau ;
- l’utilisateur principal est créé ;
- la clé SSH fonctionne ;
- les paquets de base sont présents ;
- les services attendus sont actifs ;
- la configuration est compatible avec une conversion en template Proxmox.

## 11. Étape suivante

Une fois la VM validée, elle peut être nettoyée puis convertie en template.  
Ce template servira ensuite à déployer les VMs finales du workshop avec la même chaîne d’automatisation.
