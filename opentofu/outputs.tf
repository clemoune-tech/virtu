output "vms_deployees" {
  description = "Récapitulatif des VMs déployées"
  value = {
    for name, vm in proxmox_vm_qemu.vms : name => {
      id   = vm.vmid
      nom  = vm.name
      nœud = vm.target_node
      ram  = "${vm.memory} MB"
      ip   = vm.default_ipv4_address   # ← fournie par le qemu-guest-agent
    }
  }
}