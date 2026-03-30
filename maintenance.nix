{ config, pkgs, ... }:

{
  # --- 1. Disk Space Management ---

  # Enable automatic garbage collection.
  nix.gc = {
    automatic = true;
    dates = "weekly"; # Runs once a week
    options = "--delete-older-than 7d"; # Deletes generations older than 7 days
  };

  # Automatically run `nix-store --optimise` to deduplicate files, saving disk space.
  nix.settings.auto-optimise-store = true;

  # --- 2. Modern Features ---

  # Enable key experimental features for modern Nix operation (e.g., Flakes).
  # This is essential for using the new `nix` commands (`nix build`, `nix shell`, etc.).
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
