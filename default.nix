{ pkgs ? import <nixpkgs> {} }:

with pkgs;

bundlerEnv rec {
  name = "smart-village-converter_maz-${version}";
  version = "0";
  gemdir = ./.;
  ruby = ruby_2_6;
}
