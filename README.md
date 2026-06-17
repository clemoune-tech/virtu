# Infra Workshop - Proxmox / OpenTofu / Cloud-init / Ansible

Ce dépôt contient la chaîne d’automatisation utilisée pour reconstruire une VM source sur Proxmox, l’initialiser avec cloud-init, puis appliquer un socle commun avec Ansible.

## Objectif

L’objectif du workshop est de :
- préparer une VM source propre sur Proxmox ;
- la rendre reproductible via OpenTofu ;
- appliquer l’identité initiale via cloud-init ;
- compléter la configuration avec Ansible ;
- préparer ensuite la conversion en template et le déploiement de VMs finales.

## Arborescence

- `opentofu/` : provisioning de la VM dans Proxmox.
- `cloud-init/` : identité initiale, utilisateur, SSH, réseau.
- `ansible/` : socle commun, durcissement et configuration système.
- `docs/` : documentation technique du projet.

## Ordre d’exécution

1. Déployer la VM avec OpenTofu.
2. Laisser cloud-init s’exécuter au premier démarrage.
3. Vérifier l’accès SSH.
4. Appliquer le socle avec Ansible.

## Paquets déjà présents sur la VM source

La VM source contient déjà :
- `python`
- `qemu-guest-agent`
- `cloud-init`
- `openssh-server`

## Réseau

Le plan d’adressage utilisé dans le lab est :
- réseau : `192.168.10.0/24`
- passerelle : à adapter selon l’infrastructure
- IP de la VM source : à adapter selon le plan retenu

## Utilisation

### OpenTofu
```bash
cd opentofu
tofu init
tofu plan
tofu apply
```

### Ansible
```bash
cd ../ansible
ansible-playbook -i inventory/hosts.yml playbooks/socle.yml
```

## Documentation

La documentation technique complète se trouve dans `docs/documentation-technique.md`.
