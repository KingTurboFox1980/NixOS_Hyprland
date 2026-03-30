{ config, pkgs, lib, ... }:

{
  # ===============================
  # 🧱 HYPRLAND CORE
  # ===============================
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ===============================
  # 🔐 POLKIT (REQUIRED)
  # ===============================
  security.polkit.enable = true;

  # ===============================
  # 🌐 XDG PORTALS (WAYLAND FIXES)
  # ===============================
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];

    config = {
      common = {
        default = [ "hyprland" "gtk" ];
      };
    };
  };

  # ===============================
  # ⚙️ ENVIRONMENT (WAYLAND + APPS)
  # ===============================
  environment.sessionVariables = {
    # General Wayland
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";

    # Electron / Chromium
    NIXOS_OZONE_WL = "1";

    # Firefox
    MOZ_ENABLE_WAYLAND = "1";

    # Qt
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # Java (fixes some UI bugs)
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # ===============================
  # 🔊 AUDIO (JUST IN CASE)
  # ===============================
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # ===============================
  # 🧠 DBUS (CRITICAL FOR AGENTS)
  # ===============================
  services.dbus.enable = true;

  # ===============================
  # 🚀 HYPRLAND SESSION AUTOSTART
  # ===============================
  # This is the MOST IMPORTANT part you were missing
  environment.etc."hypr/hyprland.conf".text = ''
    # =========================
    # 🚀 AUTOSTART (exec-once)
    # =========================

    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

    # 🔐 Polkit agent (FIXES YOUR ISSUE)
    exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1

    # 🔔 Notifications
    exec-once = ${pkgs.dunst}/bin/dunst

    # 📋 Clipboard history
    exec-once = ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store
    exec-once = ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store

    # 🌐 Network tray
    exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet

    # 🔵 Bluetooth tray
    exec-once = ${pkgs.blueman}/bin/blueman-applet

    # 🔋 Power profiles daemon tray (optional but useful)
    exec-once = ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced

    # 🧱 Bar
    exec-once = ${pkgs.waybar}/bin/waybar

    # 🌄 Wallpaper daemon
    exec-once = ${pkgs.swww}/bin/swww init

    # =========================
    # 🖱 BASIC INPUT
    # =========================
    input {
        kb_layout = us
        follow_mouse = 1
        touchpad {
            natural_scroll = true
        }
    }

    # =========================
    # 🪟 BASIC LOOK
    # =========================
    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        layout = dwindle
    }

    decoration {
        rounding = 8
        blur = yes
        blur_size = 6
        blur_passes = 2
    }

    animations {
        enabled = yes
    }

    # =========================
    # 🧭 KEYBINDS (ESSENTIALS)
    # =========================
    $mod = SUPER

    bind = $mod, RETURN, exec, ${pkgs.kitty}/bin/kitty
    bind = $mod, Q, killactive,
    bind = $mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar
    bind = $mod, R, exec, ${pkgs.wofi}/bin/wofi --show drun

    bind = $mod, F, fullscreen,
    bind = $mod SHIFT, Q, exit,
  '';
}
