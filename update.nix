{ config, pkgs, ... }:

let
  flakePath = "/etc/nixos";
  flakeOutput = "K10";

  upgradeScript = pkgs.writeShellScript "nixos-smart-upgrade" ''
    set -euo pipefail

    LOG="/var/log/nixos-auto-upgrade.log"
    echo "--- Upgrade started at $(date) ---" >> $LOG

    # 1. Identify the active user for notifications
    USER_NAME=$(who | awk '{print $1}' | head -n1)
    USER_ID=$(id -u "$USER_NAME")
    
    notify() {
      ${pkgs.sudo}/bin/sudo -u "$USER_NAME" \
      DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$USER_ID"/bus \
      ${pkgs.libnotify}/bin/notify-send "$1" "$2" -u "$3" -t "$4" \
      --icon=system-software-update
    }

    # 2. Update flake inputs
    echo "Updating flake..." >> $LOG
    ${pkgs.nix}/bin/nix flake update "${flakePath}" >> $LOG 2>&1

    # 3. Build and Compare
    CURRENT_SYSTEM=$(readlink /run/current-system)
    NEW_SYSTEM=$(${pkgs.nix}/bin/nix build "${flakePath}#nixosConfigurations.${flakeOutput}.config.system.build.toplevel" --no-link --print-out-paths)

    if [ "$CURRENT_SYSTEM" = "$NEW_SYSTEM" ]; then
      echo "No changes. Exiting." >> $LOG
      notify "NixOS Update" "System is already up to date." low 5000
      exit 0
    fi

    # 4. Generate Diff
    DIFF=$(${pkgs.nvd}/bin/nvd diff "$CURRENT_SYSTEM" "$NEW_SYSTEM" | tail -n +3)

    # 5. Apply
    echo "Applying updates..." >> $LOG
    nixos-rebuild switch --flake "${flakePath}#${flakeOutput}" >> $LOG 2>&1

    # 6. Notify
    SUMMARY=$(echo "$DIFF" | head -n 15)
    notify "🛠 System Upgraded" "Updates applied (1st/15th Monthly):\n\n$SUMMARY" normal 15000

    echo "Upgrade complete." >> $LOG
  '';
in
{
  environment.systemPackages = [ pkgs.nvd pkgs.libnotify ];

  systemd.services.nixos-smart-upgrade = {
    description = "Bi-Monthly Smart NixOS Auto Upgrade";
    path = with pkgs; [ 
      nix 
      nixos-rebuild 
      git 
      gnugrep 
      coreutils 
      nvd 
      sudo 
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = upgradeScript;
      User = "root"; 
    };
  };

  systemd.timers.nixos-smart-upgrade = {
    description = "Run NixOS Upgrade on the 1st and 15th of each month";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Syntax: Year-Month-Day Hour:Minute:Second
      OnCalendar = "*-*-01,15 05:00:00";
      Persistent = true;
      RandomizedDelaySec = "30min";
    };
  };
}