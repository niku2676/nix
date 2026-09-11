{ lib, pkgs, inputs, bootstrap ? false, ... }:

let
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "buls";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";
  services.xserver.xkb.layout = "de";

  users.users.nikita = {
    isNormalUser = true;
    description = "nikita";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ];
  };

  security.polkit.enable = true;
  services.openssh.enable = false;

  programs.hyprland = {
    enable = true;
    package = hyprland.hyprland;
    portalPackage = hyprland.xdg-desktop-portal-hyprland;
  };
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      user = "greeter";
    };
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  virtualisation.docker.enable = true;
  # Steam's closure is deliberately deferred until the first rebuild on the
  # installed SSD; the minimal ISO has too little writable Nix store space.
  programs.steam.enable = !bootstrap;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      includeMicrosoftKeys = true;
    };
  };

  environment.systemPackages = [ pkgs.sbctl ];

  system.stateVersion = "26.05";
}
