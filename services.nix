{ config, pkgs, ... }:

{
  # =====================================================
  # 🔧 CORE SERVICES
  # =====================================================
  services = {
    # 📦 App support
    flatpak.enable = true;

    # 💾 Storage / file systems
    udisks2.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    fstrim.enable = true;

    # 🔋 Power
    power-profiles-daemon.enable = true;
    upower.enable = true;

    # 🎧 Audio (Wayland native)
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    # 🔑 Secrets (Necessary for Vivaldi password storage)
    gnome.gnome-keyring.enable = true;

    # 🖨️ Printing
    printing.enable = true;

    # ⏱️ Time
    timesyncd.enable = true;

    # 🟦 Bluetooth userspace
    blueman.enable = true;
  };

  # =====================================================
  # 🌐 NETWORK
  # =====================================================
  networking = {
    networkmanager.enable = true;
    wireless.enable = false; # Using NM instead
    firewall.enable = true;
  };

  # =====================================================
  # 🟦 BLUETOOTH (LOW LEVEL)
  # =====================================================
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # =====================================================
  # 🖥️ XDG PORTALS (WAYLAND CRITICAL)
  # =====================================================
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = [ "hyprland" "gtk" ];
  };

  # =====================================================
  # 👮 POLKIT & AUTHENTICATION
  # =====================================================
  security.polkit.enable = true;

  # This creates the background agent that Vivaldi is looking for
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # =====================================================
  # 🖥️ VIRTUALIZATION
  # =====================================================
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  # Ensure the polkit-gnome package is available for the service above
  environment.systemPackages = with pkgs; [
    polkit_gnome
  ];
}
