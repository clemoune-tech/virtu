# ─────────────────────────────────────────────────────────────────────────────
# FICHIER DE VARIABLES SENSIBLES — À COMPLÉTER PAR CHAQUE COLLÈGUE
#
# INSTRUCTIONS D'UTILISATION :
#   1. Copier ce fichier : cp secret.tfvars.example secret.tfvars
#   2. Compléter les 3 valeurs ci-dessous avec tes informations personnelles
#   3. Ne JAMAIS committer secret.tfvars dans Git (déjà dans .gitignore)
#   4. Chaque collègue a son propre secret.tfvars sur son laptop
# ─────────────────────────────────────────────────────────────────────────────


# ── ÉTAPE PRÉALABLE — À faire UNE SEULE FOIS sur ton laptop ─────────────────
#
# Si tu n'as pas encore de clé SSH, génères-en une :
#   ssh-keygen -t ed25519 -C "tonprenom@infra-workshop"
#   (appuyer sur Entrée à chaque question, ne pas mettre de passphrase)
#
# Puis autoriser ta clé sur le nœud Proxmox :
#   ssh-copy-id root@192.168.10.3
#   (entre le mot de passe root Proxmox une dernière fois)
#
# Tester que la connexion sans mot de passe fonctionne :
#   ssh root@192.168.10.3
# ─────────────────────────────────────────────────────────────────────────────


# ── Variable 1 : ta clé SSH publique ─────────────────────────────────────────
#
# Cette clé sera injectée dans toutes les VMs par cloud-init.
# Elle te permettra de te connecter aux VMs avec : ssh ladmin@<ip_vm>
#
# Pour obtenir sa valeur, exécute dans ton terminal :
#   cat ~/.ssh/id_ed25519.pub
#
# Copie la ligne complète (commence par "ssh-ed25519 AAAA...")
#
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDaiBR8pgK9Dv7bGMCOIzdr6BiRc3I2SkGYjqg6sXGxq firas@infra-workshop"


# ── Variable 2 : utilisateur SSH pour accéder au nœud Proxmox ────────────────
#
# Utilisateur avec lequel OpenTofu se connecte à Proxmox
# pour uploader les fichiers cloud-init dans /var/lib/vz/snippets/
#
# En atelier : root
# En production : tofu-deploy (utilisateur dédié créé par l'admin)
#
proxmox_ssh_user = "root"


# ── Variable 3 : chemin vers ta clé SSH privée ───────────────────────────────
#
# Chemin local sur TON laptop vers ta clé privée.
# Si tu as utilisé ssh-keygen sans changer le chemin, c'est la valeur par défaut.
#
# Pour vérifier que le fichier existe :
#   ls ~/.ssh/id_ed25519
#
proxmox_ssh_private_key_path = "~/.ssh/id_ed25519"


# ─────────────────────────────────────────────────────────────────────────────
# UTILISATION — Commandes à lancer depuis le dossier opentofu/
#
#   tofu init                          → initialiser (une seule fois)
#   tofu plan    -var-file=secret.tfvars  → prévisualiser les changements
#   tofu apply   -var-file=secret.tfvars  → déployer
#   tofu destroy -var-file=secret.tfvars  → tout supprimer
# ─────────────────────────────────────────────────────────────────────────────

vm_password    = "ladmin"