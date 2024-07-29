{ usr, lib, sys, config, ... }:
with builtins;
with lib;
let
  cdAliases = listToAttrs (map
    (v: {
      name = "${concatStrings (replicate (v + 2) ".")}";
      value = "cd ${concatStrings (replicate (v + 1) "../")}";
    })
    (genList (x: x) 20));
in
{

  home.shellAliases = (mkMerge [
    {
      ndx = ''
        nix-shell -p nodejs_22 --run " npx create-directus-extension@latest"'';
      hms =
        "home-manager switch --flake ${config.home.homeDirectory # toString ./.
        }/workspace/nixos-config#${sys.hostname} --show-trace";
      nrs =
        "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/workspace/nixos-config#${sys.hostname} --show-trace";
      ssh = "TERM=xterm-256color ssh";
      rg = "rg --hidden";
      vf = "vim $(__fzf_select__)";
      gst = "git status";
      gp = "git fetch && git pull";
      please = "sudo";
      c = "clear";
      f = "fuck";
      cz = "fasd_cd -d";
      greprf = "grep -Rl";
      grepr = "grep -nRHIi";
      aliases = "vim ~/.bash_aliases";
      functions = "vim ~/.config/oh-my-bash/functions";
      cocker = "docker compose";
      coolr = "colorscript -r";
      dsa = ''docker stop $(docker ps -a --format "{{.ID}}")'';
      drma = ''
        docker stop $(docker ps -a --format "{{.ID}}") && docker rm $(docker ps -a --format "{{.ID}}")'';
      # vim = ''nvim'';
      # mv = ''mv -iv'';
      mv = "mv -i";
      # cp = ''cp -iv'';
      cp = "cp -i";
      # rm = ''rm -Iv'';
      # ll = ''ls -alF'';
      ll = "exa --icons -a -l -F -h -g -s size --git";
      treea = "exa --tree --icons -a -l -F -h -g -s size --git";
      treed = "exa --tree --icons -a -D";
      tree = "exa --tree --icons -a";
      la = "ls -A";
      l = "ls -CF";
      lt = "ls --human-readable --size -1 -S --classify";
      ld = "ls -ld */";
      lg = "ll | grep";
      hg = "history | grep";
      cpv = "rsync -ah --info=progress2";
      ipinfo = "curl ifconfig.me && curl ifconfig.me/host";
      clip = "xclip -sel c <";
      fg = "find . -print | grep ";
      get = "sudo apt-get install";
      remove = "sudo apt-get --purge remove";
      update = "sudo apt-get update && sudo apt-get upgrade";
      src = "source ~/.bashrc && source ~/.bash_aliases";
      x = "exit";
      cpr = "tar -czvf";
      fdel = "find . -size 0 -print -delete";
      loc = "locate -A";
      entry = "vim $(date +%y%m%d).txt";
      qmk_left =
        "qmk flash -kb handwired/dactyl_manuform/4x6_omega -km custom -bl avrdude-split-left";
      qmk_right =
        "qmk flash -kb handwired/dactyl_manuform/4x6_omega -km custom -bl avrdude-split-right";
      qmk_cmp =
        "qmk compile -kb handwired/dactyl_manuform/4x6_omega -km custom";
      k_ch = "setxkbmap -layout ch -variant de";
      k_en = "setxkbmap -layout us";
      tarbak = "tar -czvf $(date +%F)-backup.tgz backup/";
      genpass = ''
        strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '
        '; echo'';
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      ls = "ls --color=auto";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";
      dbr = "docker run --rm -it $(docker build -q .)";
    }
    (mkIf (!usr.minimal) { rm = "trash"; })
    (mkIf (config.u.user.nixvim.enable) { 
      vim = "nvim";
})
    cdAliases
  ]);
}
