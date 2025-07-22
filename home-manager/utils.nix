{ config, pkgs, ... }:
{
  # tasty dev shells
  programs.direnv.enable = true;
  # rg
  programs.ripgrep.enable = true;
}