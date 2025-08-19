{ config, pkgs, ... }:
{
  # trying out ghostty
  programs.ghostty.enable = true;
  # tasty dev shells
  programs.direnv.enable = true;
  # rg
  programs.ripgrep.enable = true;
  # youtube stuff
  programs.yt-dlp.enable = true;
  # media
  home.packages = with pkgs; [ ffmpeg ];
}