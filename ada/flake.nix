{
  description = "A Nix-flake-based Ada development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    ada_nix.url = "github:andrewathalye/nix-ada";
  };

  outputs = {
    self,
    nixpkgs,
    ada_nix,
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin"];
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
          gnat15
          alire
          just-lsp
          ada_nix.packages.x86_64-linux.ada-language-server
          ada_nix.packages.x86_64-linux.gnatformat
          gnat15Packages.gprbuild
        ];
      };
    });
  };
}
