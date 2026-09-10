# Ausgewaehlte NixOS-Migration: `buls`

Alle nicht markierten Apps wurden entfernt. Diese Liste ist jetzt der Umfang der
ersten Konfiguration.

## Plattform

- [x] Host `buls`, Benutzer `nikita`
- [x] Private Flake: `git@github.com:niku2676/nix.git`
- [x] Dual Boot auf eigener NixOS-SSD
- [x] Disko: EFI -> LUKS2 -> ext4
- [x] Secure Boot mit Lanzaboote und Microsoft-Schluesseln
- [x] Windows als Eintrag im NixOS-Bootmenue
- [x] `nixos-unstable`, manuelle Updates und Nix-Generationen fuer Rollbacks
- [x] Home Manager, Hyprland/end-4, deutsche Tastatur, Mac-artige Bindings
- [x] SSH aus, Firewall an
- [x] `sops-nix` + `age`; Recovery-Material in Bitwarden

## Ausgewaehlte Apps

- [x] Bitwarden
- [x] Discord
- [x] Docker
- [x] Ente Auth
- [x] Ghostty (Hauptterminal)
- [x] GIMP
- [x] Nextcloud
- [x] Proton VPN
- [x] Signal
- [x] Spotify
- [x] Steam
- [x] Stremio
- [x] WhatsApp
- [x] Zen Browser
- [x] Android Command Line Tools
- [x] Antigravity
- [x] Codex CLI
- [x] `opencode`, `bat`, `btop`, `fastfetch`, `gh`, `herdr`, `lazygit`,
      `neovim`, `spicetify-cli`, `stow`, `typst`
- [x] SF Mono Nerd Font

## Bereits uebernommene Konfiguration

- [x] Ghostty: Die Mac-Datei war die unveraenderte Ghostty-Standardvorlage. Die
      Linux-Konfiguration verwendet daher bewusst weiterhin die Upstream-Defaults.
- [x] Zen: Die uebertragbaren Privacy-Einstellungen und die Add-on-Inventur
      liegen unter `config/zen/`. Kein Browserprofil, keine Cookies, History,
      Logins oder Erweiterungsdaten werden uebernommen.

## Vor der Installation auf dem PC

- [ ] Die konkrete Linux-SSD anhand Modell, Groesse und Seriennummer bestimmen.
- [ ] In `hosts/buls/disko.nix` den Platzhalter durch den stabilen
      `/dev/disk/by-id/...`-Pfad **dieser** SSD ersetzen.
- [ ] Vom NixOS-Installer `hardware-configuration.nix` erzeugen und den
      Platzhalter in `hosts/buls/` ersetzen.
- [ ] Die unter `README.md` als nicht garantiert markierten Paketnamen auf dem
      aktuellen `nixos-unstable` pruefen und bei Bedarf einen Paketnamen oder
      eine externe Quelle festlegen.
- [ ] Beim Installer einmal via `gh auth login` anmelden, das private Repo
      klonen und erst dann die Flake installieren.
