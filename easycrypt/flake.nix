{
  description = "A Nix-flake-based Easycrypt development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-darwin,
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin"];

    pkgsFor = system:
    import
    (if system == "x86_64-darwin" then nixpkgs-darwin else nixpkgs)
    {inherit system;};
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = pkgsFor system;
          });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          easycrypt
          easycrypt-runtest
          z3
          alt-ergo-free
        ];
      };
    });
  };
}
