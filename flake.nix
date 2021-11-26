{
  description = "the-list developent environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, rust-overlay }:
    (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlay ];
        };

        rust = pkgs.rust-bin.nightly."2021-06-03".default.override {
          extensions = [ "rust-src" ];
        };

      in {

        devShell = pkgs.mkShell {
          name = "the-list-dev-env";
          nativeBuildInputs = [ rust ]
            ++ (with pkgs; [ gnumake nixfmt nodejs-14_x ]);
        };
      }));
}
