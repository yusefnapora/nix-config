{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";    
    };

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    nix-colors.url = "github:misterio77/nix-colors";
    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nur.url = "github:nix-community/nur";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      mkNixos = modules: nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = { inherit inputs outputs; };
      };

      mkDarwin = system: modules: inputs.darwin.lib.darwinSystem {
        inherit modules system inputs;
        specialArgs = { inherit inputs outputs; };
      };

      mkHome = modules: pkgs: home-manager.lib.homeManagerConfiguration {
        inherit modules pkgs;
        extraSpecialArgs = { inherit inputs outputs; };
      };
    in
    rec {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # 14" M1 Pro macbook
        asahi = mkNixos [ ./nixos/hosts/asahi ];

        # Home NAS box
        nasty = mkNixos [ ./nixos/hosts/nasty ];

        # Music production box
        buddy = mkNixos [ ./nixos/hosts/buddy ];

        # Home router
        clacks = mkNixos [ ./nixos/hosts/clacks ];

        # WSL2 on Windows 11
        Hex = mkNixos [ ./nixos/hosts/hex-wsl ];

        # Oracle cloud aarch64 VM
        colon = mkNixos [ ./nixos/hosts/colon ];

	# VMWare on 16" intel MBP
	detritus = mkNixos [ ./nixos/hosts/detritus ];
      };

      darwinConfigurations = {
        # 14" M1-Pro macbook
        sef-macbook = mkDarwin "aarch64-darwin" [ ./darwin/hosts/macbook.nix ];

        # 16" intel MBP (ShareFile dev)
        AMERMACC02FC2U2MD6R = mkDarwin "x86_64-darwin" [ ./darwin/hosts/work-macbook.nix ];
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # TODO: add generic standalone home-manager config
      };
    };
}
