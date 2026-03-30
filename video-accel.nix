{ config, pkgs, ... }:

{
  # 🎮 Graphics acceleration (Wayland / Hyprland)
  hardware.graphics = {
    enable = true;

    # 🚀 Media & GPU drivers
    extraPackages = with pkgs; [
      intel-media-driver        # VAAPI (Gen9+ Intel)
      libvdpau-va-gl            # VDPAU → VAAPI bridge
    ];
  };

  # 🧩 32-bit GPU support (Steam / Wine)
  environment.systemPackages = with pkgs; [
    # 32-bit OpenGL / Vulkan
    pkgsi686Linux.mesa
    pkgsi686Linux.vulkan-loader

    # OPTIONAL: only keep if you really need 32-bit VAAPI
    # pkgsi686Linux.intel-media-driver

    # 🛠 Debug / info tools (strongly recommended)
    vulkan-tools
    mesa-demos
  ];

  # 🌐 Media acceleration environment
  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";  # Intel media driver
    VDPAU_DRIVER = "va_gl";     # VDPAU via VAAPI
  };
}
