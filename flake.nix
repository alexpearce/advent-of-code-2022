{
  description = "Elixir environment.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          beam.packages.erlangR25.erlang-ls
          beam.packages.erlangR25.elixir_1_14
          beam.packages.erlangR25.elixir_ls
        ];
      };
    });
}
