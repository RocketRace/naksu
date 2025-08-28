{ config, pkgs, ... }:
{
  # tasty dev shells
  programs.direnv.enable = true;
  # Ghostty config (mac and nixos)
  xdg.configFile."ghostty/config" = {
    enable = true;
    text = ''
      theme = ayu
      window-width = 100
      window-height = 30
      macos-icon = microchip
    '';
  };
  # rg
  programs.ripgrep.enable = true;
  # youtube stuff
  programs.yt-dlp.enable = true;
  # media
  home.packages = with pkgs; [ ffmpeg ];
}