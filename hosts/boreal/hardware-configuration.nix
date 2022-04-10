# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1a942915-c1ae-4058-b99d-09d12d40dbd3";
    fsType = "btrfs";
    options = ["subvol=nixos" "compress=zstd:1" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/17C7-368D";
    fsType = "vfat";
  };

  swapDevices = [];

  hardware.cpu.amd.updateMicrocode = true;
}
