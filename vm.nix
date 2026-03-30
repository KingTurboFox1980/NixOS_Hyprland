{ config, pkgs, ... }:

{
  # 🔧 Required for GTK / virt-manager settings
  programs.dconf.enable = true;

  # 🧠 Virtualization services
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "start";
    onShutdown = "shutdown";
  };

  # 📦 Virtualization tools & helpers
  environment.systemPackages = with pkgs; [
    # Core VM tools
    virt-manager
    virt-viewer
    qemu

    # SPICE (display, clipboard, USB)
    spice-gtk
    spice-protocol
    usbredir

    # Networking
    dnsmasq
    bridge-utils
    iptables

    # File manager integration
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman

    # GTK / Theming
    adwaita-icon-theme

    # 🔑 REQUIRED for Wayland (polkit dialogs)
    polkit_gnome
  ];

  # 👤 Allow user to manage VMs without sudo
  users.users.j3ll0.extraGroups = [ "libvirtd" "kvm" ];
}
