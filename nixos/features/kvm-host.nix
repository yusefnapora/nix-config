# enable VM hosting using kvm/qemu via libvirt.
# Installs virt-manager, so more suited to workstation than headless vm host.
{ pkgs, lib, config, ...}:
{
  environment.systemPackages = [ pkgs.virt-manager pkgs.spice-gtk ];
  
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd.enable = true;
    libvirtd.qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;

      # enable TPM support (for win11)
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMFFull.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };
}
