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

  boot.initrd.luks.devices."luks-ebace00d-e6ea-4760-b474-492cdd6d0226".device = "/dev/disk/by-uuid/ebace00d-e6ea-4760-b474-492cdd6d0226";
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-82952fc0-3def-479e-9475-56fc34ac0635".keyFile = "/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-ebace00d-e6ea-4760-b474-492cdd6d0226".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "st321"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

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

  # Do not turn on sleep mode when laptop is plugged in.
  services.logind.extraConfig = ''
    HandleLidSwitchExternalPower=ignore
    '';

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11.
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

  # Postgresql.
  services.postgresql = {
    enable = true;
    # Fix elixir language mix psql integration issue. We need set `trust` to avoid auth problem for
    # local development.
    authentication = pkgs.lib.mkOverride 10 ''
        # default value of services.postgresql.authentication
        local all all              trust
        host  all all 127.0.0.1/32 trust
        host  all all ::1/128      trust
    '';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.idanko = {
      isNormalUser = true;
      description = "Illia Danko";
      extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "power" "postgres" ];
      packages = with pkgs; [ ];
    };
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
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
    fontconfig = {
      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
        <fontconfig>
            <match target="font">
                <edit name="antialias" mode="assign">
                    <!-- false,true -->
                    <bool>true</bool>
                </edit>
                <edit name="hinting" mode="assign">
                    <!-- false,true -->
                    <bool>true</bool>
                </edit>
                <edit name="autohint" mode="assign">
                    <!-- false,true -->
                    <bool>true</bool>
                </edit>
                <edit mode="assign" name="hintstyle">
                    <!-- hintnone,hintslight,hintmedium,hintfull -->
                    <const>hintslight</const>
                </edit>
                <edit name="rgba" mode="assign">
                    <!-- rgb,bgr,v-rgb,v-bgr -->
                    <const>rgb</const>
                </edit>
                <edit mode="assign" name="lcdfilter">
                    <!-- lcddefault,lcdlight,lcdlegacy,lcdnone -->
                    <const>lcddefault</const>
                </edit>
                <!-- https://wiki.archlinux.org/title/Microsoft_fonts !-->
                <edit name="embeddedbitmap" mode="assign">
                    <bool>false</bool>
                </edit>
            </match>
            <!-- Fallback fonts preference order -->
            <alias>
                <family>sans-serif</family>
                <prefer>
                    <family>Ubuntu</family>
                    <family>Noto Color Emoji</family>
                </prefer>
            </alias>
            <alias>
                <family>serif</family>
                <prefer>
                    <family>Ubuntu</family>
                    <family>Noto Color Emoji</family>
                </prefer>
            </alias>
            <alias>
                <family>monospace</family>
                <prefer>
                    <family>Ubuntu Mono</family>
                    <family>Noto Color Emoji</family>
                </prefer>
            </alias>
            <!-- https://wiki.archlinux.org/title/Microsoft_fonts !-->
            <alias binding="same">
                <family>Helvetica</family>
                <accept>
                    <family>Arial</family>
                </accept>
            </alias>
            <alias binding="same">
                <family>Times</family>
                <accept>
                    <family>Times New Roman</family>
                </accept>
            </alias>
            <alias binding="same">
                <family>Courier</family>
                <accept>
                    <family>Courier New</family>
                </accept>
            </alias>
        </fontconfig>
      '';
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Enable docker.
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	  gnomeExtensions.unite # merge title with gnome top dock
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    (pkgs.callPackage ./devcontainers-cli.nix {})
    alacritty # terminal of choice
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
    gdb
    gettext
    gimp
    git
    gnat # core development tools: compilers, linkers, etc.
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnumake
    go
    golangci-lint # golang linter package
    golines # split long code lines in golang
    google-chrome
    gopls # golang language server protocol
    gotools # set of go language code tools
    graphviz
    hdparm
    htop
    iconpack-obsidian # icon theme
    inkscape
    inotify-tools # required by elixir mix
    iperf
    ispell
    jq  # json parser
    kubectl
    lazygit
    lf
    libreoffice
    libtool # required by emacs vterm plugin
    libvterm # required by emacs vterm plugin
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
    pciutils
    pixz pigz pbzip2 # parallel (de-)compression
    pkg-config
    psmisc  # provides: fuser, killall, pstree, peekfd
    python3
    ripgrep
    rsync
    shellcheck
    signal-desktop
    slack
    strace
    stylua
    tailwindcss-language-server
    teams-for-linux
    thunderbird
    tmux
    tree
    typescript
    unzip
    usbutils
    vagrant
    wget
    whatsapp-for-linux
    whois
    wireshark
    xclip
    xorg.xhost # exec `xhost +` to share clipboard state between docker instance and the host
    yarn
    yq  # jq but for yaml
    zip
    zk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
