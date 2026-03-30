{ pkgs, ... }:

{
  programs = {
    starship = {
      enable = true;
      settings = {
        # General Settings
        add_newline = false; # Keep the prompt compact on a single line
        # Define the order and look of the prompt modules
        format = ''
          [](color_3)
          $username
          [](color_3)
          $directory
          $git_branch
          $git_state
          $git_status
          $memory_usage
          $shlvl
          $nix_shell
          $time
          [](color_bg)
          \n$character
        '';

        # Custom Prompt Character
        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[x](bold red)";
          # The prompt will show ">" in green on success and "x" in red on error
        };

        # Custom Symbols (Your excellent list)
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
          # Use different color to visually separate current path
          style = "bold white";
        };
        docker_context = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
          style = "bold purple";
        };
        golang = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
    };
  };
}
