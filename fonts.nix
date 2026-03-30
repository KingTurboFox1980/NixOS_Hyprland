{ pkgs, ... }:

{
  fonts = {
    # System-wide fonts
    packages = with pkgs; [

      # ── Core / UI Fonts ─────────────────────────────
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      ubuntu-classic

      # Adobe Source family
      source-code-pro
      source-sans-pro
      source-serif-pro

      # ── Coding Fonts ────────────────────────────────
      inconsolata
      fira-code
      jetbrains-mono
      victor-mono

      # ── Emoji & Icons (Wayland-friendly) ───────────
      noto-fonts-color-emoji
      openmoji-color
      twemoji-color-font
      font-awesome_6
      material-icons

      # ── Nerd Fonts (individual packages – correct) ─
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      udev-gothic-nf

      # ── Bitmap / Retro Fonts (fixed names) ─────────
      dina-font
      terminus_font     # ✅ correct name (not terminus-font)
      proggyfonts
      orbitron

      # ── Windows compatibility (optional) ───────────
      corefonts
      vista-fonts
    ];

    # ── Fontconfig defaults (important for Wayland) ──
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "FiraCode Nerd Font" ];
        sansSerif = [ "Noto Sans" "DejaVu Sans" ];
        serif = [ "Noto Serif" "DejaVu Serif" ];
        emoji = [ "Noto Color Emoji" "OpenMoji Color" ];
      };
    };
  };
}
