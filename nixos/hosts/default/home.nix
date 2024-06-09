{ config, pkgs, pkgs-unstable, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "idanko";
  home.homeDirectory = "/home/idanko";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    (pkgs.callPackage ./fdir.nix { })
    pkgs-unstable.bemenu
    pkgs-unstable.neovim
    pkgs-unstable.wezterm
    pkgs.cliphist
    pkgs.clipnotify
    pkgs.devcontainer
    pkgs.emmet-ls
    pkgs.gnome.dconf-editor
    pkgs.gnome.gnome-tweaks
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.unite # merge title with gnome top dock
    pkgs.nixd
    pkgs.nixfmt-classic
    pkgs.obsidian
    pkgs.papirus-icon-theme
    pkgs.texliveFull
    pkgs.xclip
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Numix-Square";
      package = pkgs.numix-icon-theme-square;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  xresources.properties = {
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintslight";
    "Xft.hinting" = true;
    "Xft.antialias" = true;
    "Xft.rgba" = "rgb";
  };

  systemd.user.services.cliphist-store = {
    Unit = {
      Description =
        "X11 service. Listen to clipboard events and pipe them to cliphist.";
    };
    Service = {
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c 'while ${pkgs.clipnotify}/bin/clipnotify; do ${pkgs.xclip}/bin/xclip -o -selection c | ${pkgs.cliphist}/bin/cliphist store; done'
      '';
      Restart = "always";
      TimeoutSec = 3;
      RestartSec = 3;
    };
    Install = { WantedBy = [ "default.target" ]; };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/idanko/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
