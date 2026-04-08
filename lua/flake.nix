{
  description = "A Nix-flake-based Lua development environment using Lux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          lux-cli
          lua51Packages.lux-lua
          stylua
          lua-language-server
          just
          just-lsp
          nil
          alejandra
          pkg-config
        ];
      };
    });
  };
}
