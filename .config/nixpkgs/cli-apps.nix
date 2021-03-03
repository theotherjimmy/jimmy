{ config, lib, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "exa";
      pd = "prevd";
      nd = "nextd";
      j = "just";
    };
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      prompt_order = [
        "directory"
        "nix_shell"
        "git_branch"
        "git_state"
        "cmd_duration"
        "line_break"
        "character"
      ];
      scan_timeout = 6;
      cmd_duration.min_time = 10;
      cmd_duration.show_milliseconds = true;
      character.symbol = "➜";
      directory.truncation_length = 1;
      directory.fish_style_pwd_dir_length = 1;
    };
  };
  programs.git = {
    enable = true;
    aliases = {
      ds = "diff --staged";
      ap = "add -p";
    };
    extraConfig = {
      core.editor = "edit";
      pull.rebase = true;
    };
    ignores = [ ".direnv.d" ".envrc" "shell.nix" ];
    userEmail = "theotherjimmy@gmail.com";
    userName = "Jimmy Brisson";
  };
  programs.jq.enable = true;
  programs.man.enable = true;
  programs.skim.enable = true;
  services.lorri.enable = true;
  home.packages = with pkgs // rec {
    edit = pkgs.writers.writeBashBin "edit" ''
      if [[ -v INSIDE_EMACS ]] ; then
        exec emacsclient $@
      else
        exec emacsclient -c $@
      fi
    '';
    git-ip-review = pkgs.writeShellScriptBin "git-ip-review" ''
      rev=$(git rev-parse --abbrev-ref HEAD)
      if [ "HEAD" == $rev ] ; then
        echo "Error: detached HEAD; Refusing to push an ip review"
        exit 1
      else
        git push arm $rev:refs/for/master/$rev
      fi
    '';
  }; [
    aspell
    aspellDicts.en
    acpilight
    apitrace
    atop
    linuxPackages.bpftrace
    cargo-flamegraph
    direnv
    edit
    exa
    fd
    file
    firefox
    fractal
    git
    gnumake
    git-hub
    git-ip-review
    git-review
    git-series
    just
    keepass
    libnotify
    mupdf
    networkmanagerapplet
    niv
    nixpkgs-fmt
    nix-top
    nix-index
    nix-prefetch-scripts
    neovim
    neovim-remote
    hack-font
    openconnect
    patchelf
    procs
    pv
    usbutils
    ripgrep
    screen
    tmux
    watchexec
    wl-clipboard
    xclip
    xe
    xmlstarlet
    xwayland
    xorg.xdpyinfo
  ];
}
