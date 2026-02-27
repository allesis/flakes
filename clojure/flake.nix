{
  description = "A Nix-flake-based Clojure development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
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
        buildInputs = with pkgs; [
        ];

        packages = with pkgs; [
          clojure
          clojure-lsp
          clj-kondo
          cljfmt
          # quality of life stuff for non-clojure things
          just
          just-lsp
          nil
          alejandra
        ];
      };
    });
  };
}
