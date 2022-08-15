{config, lib, pkgs, ... }: {

  networking.nat.internalInterfaces = [ "ve-sonarr" ];
  networking.firewall.allowedTCPPorts = [ 8989 ];

  containers.sonarr = {
    autoStart = true;
      # starts fresh every time it is updated or reloaded
#    ephemeral = true;

      # networking & port forwarding
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";

      # mounts
    bindMounts = {
      "/var/lib/sonarr" = {
        hostPath = "/nix/persist/var/lib/sonarr";
        isReadOnly = false;
      };        
    };

    forwardPorts = [
			{
				containerPort = 8989;
				hostPort = 8989;
				protocol = "tcp";
			}
		];

    config = { config, pkgs, ... }: {

      system.stateVersion = "22.05";
      networking.hostName = "sonarr";

      services.sonarr = {
        enable = true;
        openFirewall = true;
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/sonarr/.config/NzbDrone 700 sonarr sonarr -"
      ];
    };
  };

}
