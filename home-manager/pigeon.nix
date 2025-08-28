{ config, pkgs, ... }:

{
  imports = [ ./vscode.nix ./git.nix ./terminal.nix ];
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    discord
    spotify
    prismlauncher
    qbittorrent
    gimp
    zotero
    # Package BeautifulDiscord and point it to my home config
    (let recipe = { python3, fetchFromGitHub }:
      with python3.pkgs;
      buildPythonPackage {
        name = "BeautifulDiscord";
        version = "0.2.0";
        src = fetchFromGitHub {
          owner = "leovoel";
          repo = "BeautifulDiscord";
          rev = "9d6a0366990867f1b36c5f17b3fa3fd3430bdc97";
          hash = "sha256-UnJh39fzbPnXZmBHkAB3w+MeYw/Cpb+m9fpAVMVqM+M=";
        };
        propagatedBuildInputs = [ psutil ];
    };
    beautifuldiscord = pkgs.callPackage recipe {};
    env = pkgs.python3.withPackages (ps: [ beautifuldiscord ]);
    in pkgs.writeShellScriptBin "dinject" ''
      ${env}/bin/python3 -m beautifuldiscord --css ${../discord/style.css}
    '')
  ];

  # karabiner-elements should NOT be installed using nix for now. maybe it works in the future.
  # karabiner can't listen for symbolic links so we need to kickstart it
  # https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/#about-symbolic-link
  home.file.".config/karabiner" = {
    source = ../karabiner;
    recursive = false;
    onChange = ''
      /bin/launchctl kickstart -k gui/`id -u`/org.pqrs.karabiner.karabiner_console_user_server
    '';
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      pigeon-switch = ''sudo darwin-rebuild switch --flake ~/.config/nix'';
      pigeon-update = ''nix flake update nixpkgs-darwin --flake ~/.config/nix'';
      pigeon-fetch = ''cd ~/.config/nix && jj git fetch && jj new main && cd -'';
    };
    # Initialize p10k configuration (took a while to find the config line because the wizard doesn't tell you)
    initContent = ''
      [[ ! -f ${../p10k/.p10k.zsh} ]] || source ${../p10k/.p10k.zsh}
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
  # custom fonts and keylayouts need to go through lower level mechanisms provided by macos
  # jank as hell tbh
  home.file."Library/Fonts/Symlinks" = {
    enable = true;
    source = ../fonts;
    recursive = true;
    onChange = ''
      cd ~/Library/Fonts
      rm -rf Custom
      mkdir Custom
      cp -Lr Symlinks/* Custom
    '';
  };
  home.file."Library/Application Support/discord/settings.json" = {
    enable = true;
    text = ''
      {
        "chromiumSwitches": {},
        "IS_MAXIMIZED": true,
        "IS_MINIMIZED": false,
        "DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING": true
      }
    '';
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
