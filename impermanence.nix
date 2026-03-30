{ config, lib, ... }:

{
  environment.persistence."/persist" = {
    hideMounts = true;

    # -------------------------
    # System state
    # -------------------------
    directories = [
      "/var/lib/nixos"          # ⭐ REQUIRED for stable UID/GID
      "/etc/NetworkManager"
      "/var/lib/bluetooth"
      "/var/lib/flatpak"
      "/var/lib/gnome-keyring"
      "/var/lib/libvirt"
      "/var/lib/cups"
      "/var/log"
    ];

    files = [
      "/etc/machine-id"
    ];

    # -------------------------
    # User state
    # -------------------------
    users.j3ll0 = {
      directories = [
        ".ssh"
        ".gnupg"
        ".local/share/keyrings"
        ".local/share/direnv"
        ".local/share/flatpak"
        ".cache/nix"
      ];
    };
  };
}
