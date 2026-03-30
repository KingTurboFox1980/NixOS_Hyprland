{ config, pkgs, lib, ... }:

{
  # =========================
  # ⚙️ Bash (Fallback shell)
  # =========================
  programs.bash = {
    shellAliases = {
      # Nix Management
      fu  = "(cd /etc/nixos && sudo nixos-rebuild switch --flake .#K10)";
      fub = "(cd /etc/nixos && nix build .#nixosConfigurations.K10.config.system.build.toplevel)";
      up  = "sudo /home/j3ll0/nix_update.sh";
      dot = "cd /etc/nixos/";

      # System & Editor
      ff   = "clear && fastfetch";
      trim = "sudo fstrim -v /";
      ls   = "ls --color=auto";
      grep = "grep --color=auto";
      v    = "sudo -E nvim";
    };

    shellInit = ''
      # ============================================================================
      # SHELL OPTIONS
      # ============================================================================
      stty -ixon
      shopt -s histappend checkwinsize cdspell dirspell autocd
      shopt -s globstar nocaseglob extglob

      # ============================================================================
      # HISTORY
      # ============================================================================
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      export HISTCONTROL=ignoreboth:erasedups
      export HISTIGNORE="ls:ll:cd:pwd:exit:clear:history"
      export HISTTIMEFORMAT="%F %T "
      export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

      # ============================================================================
      # ENVIRONMENT
      # ============================================================================
      export PATH="$HOME/scripts:$HOME/.local/bin:/usr/local/go/bin:$HOME/.cargo/bin:$PATH"
      export EDITOR=$(command -v nvim || command -v vim || command -v micro || echo nano)
      export VISUAL="$EDITOR"
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8

      # ============================================================================
      # WELCOME
      # ============================================================================
      if [ -n "$PS1" ]; then
        echo -e "\033[1;34m=== Welcome back, $USER! ===\033[0m"
        echo "Date: $(date '+%A, %B %d, %Y - %I:%M %p')"
        echo "Uptime: $(uptime -p)"
        echo
      fi

      ${lib.optionalString config.programs.starship.enable "eval \"$(starship init bash)\""}
    '';
  };

  # =========================
  # ⚙️ Zsh (Default shell)
  # =========================
  programs.zsh = {
    enable = true;

    shellAliases = {
      # Nix Management
      fu  = "(cd /etc/nixos && sudo nixos-rebuild switch --flake .#K10)";
      fub = "(cd /etc/nixos && nix build .#nixosConfigurations.K10.config.system.build.toplevel)";
      up  = "sudo /home/j3ll0/nix_update.sh";
      dot = "cd /etc/nixos/";

      # System
      ff   = "clear && fastfetch";
      ll   = "ls -l";
      trim = "sudo fstrim -v /";
      ls   = "ls --color=auto";
      grep = "grep --color=auto";
      v    = "sudo -E nvim";
    };

    shellInit = ''
      # ============================================================================
      # OH-MY-ZSH
      # ============================================================================
      export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
      ZSH_THEME="robbyrussell"
      DISABLE_AUTO_UPDATE="true"
      source $ZSH/oh-my-zsh.sh

      # ============================================================================
      # ZSH PLUGINS
      # ============================================================================
      source ${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-autocomplete}/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

      ${lib.optionalString config.programs.starship.enable "eval \"$(starship init zsh)\""}

      # ============================================================================
      # WELCOME
      # ============================================================================
      if [ -n "$PS1" ]; then
        echo -e "\033[1;34m=== Welcome back, $USER! ===\033[0m"
        echo "Date: $(date '+%A, %B %d, %Y - %I:%M %p')"

        ram_used=$(free -h | awk '/Mem:/ {print $3}')
        ram_total=$(free -h | awk '/Mem:/ {print $2}')
        echo "RAM: $ram_used / $ram_total"

        cpu_temp=$(sensors 2>/dev/null | awk '/Package id 0:/ {print $4}')
        [ -n "$cpu_temp" ] && echo "CPU Temp: $cpu_temp"

        echo "Type 'alias' to list shortcuts"
        echo
      fi
    '';
  };

  # =========================
  # ⭐ Starship
  # =========================
  programs.starship.enable = true;

  # =========================
  # 🐚 System shells
  # =========================
  environment.shells = with pkgs; [
    zsh
    bash
  ];

  # =========================
  # 📦 Shell dependencies
  # =========================
  environment.systemPackages = with pkgs; [
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-autocomplete
    lm_sensors
  ];
}
