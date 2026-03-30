{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./cachix.nix
    ./fonts.nix
    ./impermanence.nix
    ./maintenance.nix
    ./packages.nix   # 🛠️ Browser overrides (Vivaldi/Edge) live here
    ./services.nix
    ./starfish.nix
    ./update.nix
    ./video-accel.nix
    ./vm.nix
    ./hyprland.nix
  ];

  # ================================================================
  # ❄️ NIX & NIXPKGS
  # ================================================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # ================================================================
  # 🆔 SYSTEM IDENTITY & LOCALE
  # ================================================================
  networking.hostName = "K10";
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  # ================================================================
  # 🚀 BOOT & KERNEL
  # ================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Performance & Latency tweaks
  boot.kernelParams = [ "mitigations=off" ];
  boot.kernel.sysctl."vm.dirty_ratio" = 20;
  boot.tmp.useTmpfs = false; 

  # ================================================================
  # 🖥️ HARDWARE & GRAPHICS
  # ================================================================
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.thermald.enable = true;

  # ================================================================
  # 🌐 WAYLAND & ENVIRONMENT
  # ================================================================
  # Global fixes for Vivaldi/Chromium/Electron crashes on Hyprland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; 
    MOZ_ENABLE_WAYLAND = "1";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  # ================================================================
  # 🔐 SECURITY & AUTH
  # ================================================================
  security.rtkit.enable = true;
  security.sudo = {
    enable = true;
    extraConfig = "Defaults env_reset,pwfeedback";
  };
  
  # Required for password prompts (Polkit) and Keychain
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # ================================================================
  # 📂 FILESYSTEMS & MOUNTS
  # ================================================================
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/0618d31f-4e05-4fc0-8db1-9d62bebab4d0";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.automount" ];
  };
  
  zramSwap.enable = true;
  services.gvfs.enable = true; # Mount support for Thunar/Nemo

  # ================================================================
  # 👥 USERS (Impermanence Safe & Validated)
  # ================================================================
  users.mutableUsers = false; 

  # Root must have a password or be locked to pass the build assertion
  users.users.root.hashedPassword = "!";

  users.users.j3ll0 = {
    isNormalUser = true;
    uid = 1000;
    description = "Angelo";
    # Declarative password hash for Impermanence
    hashedPassword = "$6$UrSiPmeE9fuc0KBK$ow2XmJbhxycORPOaBnWwNFPh5MbFYudd0ljNPJO4qxp2tykm12bkcG5VvDwjvYmLEV//dgOaRSPsA2P3HnWK6/"; 
    extraGroups = [ 
      "wheel" 
      "networkmanager" 
      "libvirtd" 
      "audio" 
      "video" 
      "input" 
      "kvm" 
    ];
    shell = pkgs.zsh;
  };

  # Fixed GIDs for system stability
  users.groups = {
    flatpak.gid = 970;
    nscd.gid = 971;
    rtkit.gid = 972;
    systemd-oom.gid = 973;
    polkituser.gid = 974;
    lpadmin.gid = 975;
  };

  # ================================================================
  # 📦 CORE PROGRAMS
  # ================================================================
  programs.zsh.enable = true;
  programs.hyprland.enable = true;
  programs.xfconf.enable = true;
  
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    coreutils
    lm_sensors
    pciutils
    usbutils
    wget
  ];

  system.stateVersion = "25.05";
}
