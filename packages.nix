{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # =========================
    # 🌐 Browsers (Wayland fixed)
    # =========================
    firefox

    (vivaldi.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
      ];
    })

    (microsoft-edge.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    })

    p3x-onenote

    # =========================
    # 🛠 Development
    # =========================
    cachix
    git
    neovim
    vscode
    geany
    (python3.withPackages (ps: [ ps.psutil ]))

    # =========================
    # 📁 File Management
    # =========================
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    nemo
    gvfs
    samba
    cifs-utils
    rclone
    rclone-browser

    # =========================
    # 🧱 Hyprland / Wayland Core
    # =========================
    hyprland
    xdg-utils
    wl-clipboard
    cliphist

    # Bar / Launcher
    waybar
    wofi

    # Wallpaper
    swww
    waypaper

    # Idle / Lock
    hypridle
    hyprlock

    # Screenshot
    grim
    slurp

    # =========================
    # 🎨 Theming / GTK
    # =========================
    nwg-look
    wallust
    adwaita-icon-theme
    gtk3
    gtk4
    glib
    hyprsunset

    # =========================
    # 🔔 Notifications
    # =========================
    dunst
    libnotify

    # =========================
    # 🎧 Audio tools
    # =========================
    pavucontrol
    pamixer
    alsa-utils

    # =========================
    # 🎥 Media
    # =========================
    mpv
    vlc
    nomacs
    brightnessctl

    # =========================
    # 🔐 Auth / Keyring
    # =========================
    polkit_gnome
    libsecret
    gnome-keyring
    seahorse

    # =========================
    # 🔋 System / Hardware
    # =========================
    power-profiles-daemon
    lm_sensors
    cpu-x
    mission-center
    solaar

    # Networking UI
    networkmanagerapplet
    blueman

    # =========================
    # 🧰 Utilities
    # =========================
    bitwarden-desktop
    bleachbit
    localsend
    unzip
    wget
    yt-dlp
    qbittorrent

    # GNOME helpers (no DE)
    gnome-disk-utility
    gnome-calculator

    # =========================
    # 💻 Terminal / CLI
    # =========================
    kitty
    alacritty
    wezterm
    btop
    fastfetch
    fzf
    zsh
    starship
  ];
}
