{
  globals,
  usr,
  lib,
  net,
  config,
  ...
}:
with builtins;
with lib;
with globals.envVars;
let
  cdAliases = listToAttrs (
    map (v: {
      name = "${concatStrings (replicate (v + 2) ".")}";
      value = "cd ${concatStrings (replicate (v + 1) "../")}";
    }) (genList (x: x) 20)
  );
in
{

  home.shellAliases = (
    mkMerge [
      {
        noptions = "nix eval ${NIXOS_CONFIG}#nixosConfigurations.${net.hostname}.options.m --apply 'm: let lib = (import <nixpkgs> {}).lib; in builtins.toJSON m' | sed 's/\\\\\\\\//g' | sed 's/^\"//' | sed 's/\"$//' | jq 'paths(scalars) as $p | getpath($p)' | sort";
        ndx = ''nix-shell -p nodejs_22 --run " npx create-directus-extension@latest"'';
        hms = "home-manager switch --flake ${NIXOS_CONFIG}#${net.hostname} --show-trace";
        nrs = "nixos-rebuild switch --flake ${NIXOS_CONFIG}#${net.hostname} --show-trace --use-remote-sudo";
        nps = "nix repl --expr 'import <nixpkgs>{}'";
        ssh = "TERM=xterm-256color ssh";
        rg = "rg --hidden";
        vf = "vim $(fzf)";
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
        drma = ''docker stop $(docker ps -a --format "{{.ID}}") && docker rm $(docker ps -a --format "{{.ID}}")'';
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
        # goodbye debian
        # get = "sudo apt-get install";
        # remove = "sudo apt-get --purge remove";
        # update = "sudo apt-get update && sudo apt-get upgrade";
        # hello nix
        get = "nix-shell -p";
        update = "nix flake update ${NIXOS_CONFIG}";
        src = "source ~/.bashrc && source ~/.bash_aliases";
        x = "exit";
        cpr = "tar -czvf";
        fdel = "find . -size 0 -print -delete";
        loc = "locate -A";
        entry = "vim $(date +%y%m%d).txt";
        qmk_left = "qmk flash -kb handwired/dactyl_manuform/4x6_omega -km custom -bl avrdude-split-left";
        qmk_right = "qmk flash -kb handwired/dactyl_manuform/4x6_omega -km custom -bl avrdude-split-right";
        qmk_cmp = "qmk compile -kb handwired/dactyl_manuform/4x6_omega -km custom";
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
        svn = "svn --username gs2 --password $(pass work/svn)";
        vimtmp = "vim $(mktemp)";
        # nyehhehheh
        nano = "vim";

        dcs = "${./scripts/docker_disk_usage.sh}";
        flog = "${./scripts/filter_log.sh}";
        ctf = "${./scripts/check_tmp_files.sh}";
        csw = "${./scripts/check_swap.sh}";
        sst = "${./scripts/show_stats.sh}";
      }
      (mkIf (!usr.minimal) { rm = "trash"; })
      (mkIf config.u.user.nixvim.enable {
        vim = "nvim";
        vi = "nvim";
      })
      (mkIf config.u.user.vim.enable { vi = "vim"; })
      cdAliases
    ]
  );
}
