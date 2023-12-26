# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-1ba08d9b-2686-4b6d-a887-627b15f69134".device = "/dev/disk/by-uuid/1ba08d9b-2686-4b6d-a887-627b15f69134";
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-d9cd1947-b35e-4a5a-a62b-d6f6c566c4a8".keyFile = "/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-1ba08d9b-2686-4b6d-a887-627b15f69134".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver = {
    layout = "us,ua";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

# Postgresql.
  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.idanko = {
      isNormalUser = true;
      description = "Illia Danko";
      extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "power" ];
      packages = with pkgs; [ ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Enable docker.
  virtualisation.docker.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    anki
    ansible
    automake
    clang-tools
    cmake
    delve # golang debugger
    dmidecode
    dnsutils
    docker-compose
    dos2unix  # Convert between DOS and Unix line endings
    elixir
    elixir-ls
    ethtool
    fd
    file
    filezilla
    firefox
    fzf
    gcc gdb
    gettext
    gimp
    git
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnumake
    go
    golangci-lint # golang linter package
    golines # split long code lines in golang
    google-chrome
    google-cloud-sdk
    gopls # golang language server protocol
    gotools # set of go language code tools
    graphviz
    hdparm
    htop
    iperf
    jq  # json parser
    kubectl
    lazygit
    lf
    libreoffice
    libxml2  # xmllint
    lshw
    lsof
    lua-language-server
    neofetch
    neovim # the text editor of my choice
    netcat
    nmap
    nodePackages.eslint # javascript linter
    nodePackages.prettier # javascript formatter
    nodePackages.pyright # python code formatter
    nodePackages.typescript-language-server # typescript language server protocol
    nodePackages.vscode-css-languageserver-bin # css language server protocol
    nodejs
    obs-studio # record camera and desktop
    openssl
    pandoc # convert/generate documents in different formats
    parcellite # gtk clipboard manager
    pciutils
    pixz pigz pbzip2 # parallel (de-)compression
    pkg-config
    psmisc  # provides: fuser, killall, pstree, peekfd
    ripgrep
    rsync
    shellcheck
    slack
    strace
    stylua
    tdesktop
    teams-for-linux
    thunderbird
    tree
    typescript
    unzip
    usbutils
    vagrant
    wezterm
    wget
    whois
    wireshark
    xclip
    yarn
    yq  # same for yaml
    zip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "kubectl" "history" "gcloud" "mix" "npm" "yarn" "rust" "rsync" "postgres" "fzf" "docker-compose" ];
        theme = "intheloop";
      };
    };
  };

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  fonts = {
    enableDefaultPackages  = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fontconfig = {
        defaultFonts = {
          serif = [ "Ubuntu" ];
          sansSerif = [ "Ubuntu" ];
          monospace = [ "Ubuntu" ];
        };
    };
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk # Chinese, Japanese, Korean
      noto-fonts-emoji
      noto-fonts-extra
      fira-code # Monospace font with programming ligatures
      fira-mono # Mozilla's typeface for Firefox OS
      corefonts  # Microsoft free fonts
      ubuntu_font_family
      liberation_ttf
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      roboto # Android
    ];
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
