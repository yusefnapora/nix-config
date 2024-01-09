{ pkgs, config, ... }:
let
  external-interface = "enp0s6";
  listenPort = 51820;

  peers = [
    {
      name = "pixel-5";
      publicKey = "V/0d3OUX3/XPjFQE72mMat2dmLOIK58I7Zo8tzh/7SQ=";
      allowedIPs = [ "10.100.0.2/32" ];
    }
  ];
in {

  age.secrets.wireguard-privkey-colon = {
    file = ../../secrets/wireguard-privkey-colon.age;
    mode = "600";
    owner = "root";
    group = "root";
  };

  networking = {
    nat = {
      enable = true;
      externalInterfaces = [ external-interface ];
      internalInterfaces = [ "wg0" ];
    };

    firewall.allowedUDPPorts = [ listenPort ];

    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.1/24" ];

      inherit listenPort peers;      
    };

    # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
    # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
    postSetup = ''
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${external-interface} -j MASQUERADE
    '';

    # This undoes the above command
    postShutdown = ''
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${external-interface} -j MASQUERADE
    '';

  };
}
