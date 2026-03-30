{ pkgs, lib, config, ... }:

{
  # 1. Base Zsh Configuration
  # We are keeping this minimal since the older channel doesn't support 'plugins' or 'rcInit'.
  programs.zsh = {
    enable = true;

    # 2. Define Aliases
    shellAliases = {
      # Standard Utilities
      ll = lib.mkForce "ls -lh"; # <-- Using mkForce to override the conflicting definition
      home = "cd ~";

      # Color aliases
      ls = "ls --color=auto";
      grep = "grep --color=auto";

      # Flake and System Management
      update = "sudo nixos-rebuild switch"; # Standard update alias
      fu = "(cd /etc/nixos && sudo nixos-rebuild switch --flake .#K10)";
      fub = "(cd /etc/nixos && nix build .#nixosConfigurations.K10.config.system.build.toplevel)";
      up = "sudo /home/j3ll0/nix_update.sh";

      # Maintenance
      trim = "sudo fstrim -v /";

      # Navigation and Editor
      dot = "cd /etc/nixos/";
      v = "sudo -E nvim";

      # XMonad Script
      keys = ".config/scripts/update_xmonad_keys.sh";
    };
  };

  # 3. Starship configuration
  programs.starship.enable = true;
}
