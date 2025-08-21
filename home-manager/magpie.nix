{ config, pkgs, ... }:

{
  imports = [ ./vscode.nix ./git.nix ./utils.nix ];
  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "olivia";
  home.homeDirectory = "/home/olivia";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = [
    (pkgs.writeShellScriptBin "magpie-update" "nix flake update nixpkgs --flake ~/.config/nix")
    (pkgs.writeShellScriptBin "magpie-switch" "sudo nixos-rebuild switch --flake ~/.config/nix")
  ];
  home.file = { };
  home.sessionVariables = { };

  # trying out ghostty (pigeon uses brew)
  programs.ghostty.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
