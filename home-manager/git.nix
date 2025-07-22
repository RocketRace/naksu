{ config, pkgs, ... }:
{
  # all the various git settings I've picked up along the way, although nowadays I mainly use jujutsu
  programs.git = {
    enable = true;
    userName = "RocketRace";
    userEmail = "git@olivialta.cc";
    ignores = [ ".DS_Store" ];
    aliases = {
      alias = "!f () { if [ \"$#\" = 0 ]; then git config --get-regexp alias; else git config --get \"alias.$1\"; fi }; f";
      s = "status";
      a = "! git add . && git status";
      c = "commit";
      cm = "commit --message";
      cam = "commit --amend --message";
      can = "commit --amend --no-edit";
      acm = "! git add . && git commit --message";
      acan = "!git add . && git commit --amend --no-edit";
      dc = "diff --cached";
      dh = "!f() { git diff \"head~$1\"; }; f";
      cd = "checkout";
      pa = "push --all";
      pf = "pull --ff-only";
      spa = "! git stash pop && git add .";
      lg = "! git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --";
    };
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rerere.enabled = true;
    };
  };
  # gh is sometimes useful, too, though I've mainly used it for cloning
  programs.gh.enable = true;
  # yay yay! jj!
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "RocketRace";
        email = "git@olivialta.cc";
      };
      ui = {
        pager = ":builtin";
        default-command = "log";
      };
      # goated alias
      aliases.tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
    };
  };
}