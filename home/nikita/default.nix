{ lib, pkgs, inputs, ... }:

let
  # Each selected application stays visible here. Names not present in the
  # pinned nixpkgs revision are written to a review file instead of breaking
  # the first Home Manager activation.
  selectedPackageNames = [
    "antigravity"
    "android-tools"
    "bat"
    "bitwarden-desktop"
    "btop"
    "codex"
    "discord"
    "ente-auth"
    "fastfetch"
    "gh"
    "ghostty"
    "gimp"
    "herdr"
    "lazygit"
    "nextcloud-client"
    "neovim"
    "opencode"
    "protonvpn-gui"
    "signal-desktop"
    "spicetify-cli"
    "spotify"
    "stow"
    "stremio-linux-shell"
    "typst"
    "karere"
    "zen-browser"
  ];

  packageFor = name: lib.attrByPath [ name ] null pkgs;
  missingPackageNames = builtins.filter (name: packageFor name == null) selectedPackageNames;
in
{
  imports = [ inputs.illogical-impulse.homeManagerModules.default ];

  home.username = "nikita";
  home.homeDirectory = "/home/nikita";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.fastfetch.enable = true;
  programs.gh.enable = true;
  programs.lazygit.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # The end-4 module provides the QuickShell-based desktop and Hyprland
  # defaults. Kitty stays disabled: Ghostty is this setup's terminal.
  illogical-impulse = {
    enable = true;
    hyprland.ozoneWayland.enable = true;
    dotfiles = {
      fish.enable = true;
      kitty.enable = false;
      starship.enable = true;
    };
  };

  home.packages = builtins.filter (pkg: pkg != null) (map packageFor selectedPackageNames);

  xdg.enable = true;
  xdg.configFile."ghostty/config".source = ../../config/ghostty/config;

  home.file.".local/share/nix-config/unresolved-package-names.txt".text = ''
    The following selected names were not attributes of the pinned nixpkgs
    revision during the last Home Manager evaluation:

    ${lib.concatStringsSep "\n" missingPackageNames}

    Resolve them explicitly in README.md; do not add arbitrary curl installers.
  '';
}
