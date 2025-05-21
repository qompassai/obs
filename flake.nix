# /qompassai/obs/flake.nix
# ---------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved

{
  description = "Qompass AI OBS Studio with PipeWire and Background Removal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];

      extraPackages = with pkgs; [
        pipewire
        libva-full
        v4l-utils
      ];
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = [
        self.packages.${system}.default
        pkgs.pipewire
        pkgs.ffmpeg
      ];
    };

    homeManagerModules.default = { config, pkgs, ... }: {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      };
    };
  };
}

