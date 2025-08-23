{ config, pkgs, ... }:
{
  # tasty dev shells
  programs.direnv.enable = true;
  # rg
  programs.ripgrep.enable = true;
  # youtube stuff
  programs.yt-dlp.enable = true;
  # media
  home.packages = with pkgs; [ ffmpeg ];

  xdg.configFile."ghostty/config" = {
    enable = true;
    text = ''
      theme = Tomorrow Night Bright
      background-opacity = 0.5
      background-blur = true
      window-width = 100
      window-height = 30
      macos-icon = microchip
      keybind = global:cmd+grave_accent=toggle_quick_terminal
    '';
  };
}