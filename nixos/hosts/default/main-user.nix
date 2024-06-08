{ lib, config, pkgs, ... }:

let cfg = config.main-user;
in {
  options.main-user = {
    enable = lib.mkEnableOption "enable user module";

    userName = lib.mkOption {
      default = "MainUser";
      description = ''
        UserName
      '';
    };

    userFullName = lib.mkOption {
      default = "UserFullName";
      description = ''
        UserFullName
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = "${cfg.userFullName}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "wireshark"
        "power"
        "postgres"
        "audio"
        "video"
        "input"
      ];
    };
  };
}
