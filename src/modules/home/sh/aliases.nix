{
  globals,
  pkgs,
  usr,
  lib,
  net,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    genList
    replicate
    listToAttrs
    concatStrings
    ;
  # inherit (builtins) toJSON unsafeDiscardStringContext;
  inherit (globals.envVars) NIXOS_CONFIG;
  cdAliases = listToAttrs (
    map (v: {
      name = "${concatStrings (replicate (v + 2) ".")}";
      value = "cd ${concatStrings (replicate (v + 1) "../")}";
    }) (genList (x: x) 20)
  );
  # nixosConfigurations.rednip._module.specialArgs.lib.omega.attrs.filterLeaves ( k: v: (v == true && k == "enable") || (v == false && k == "disable"))
  opts =
    t:
    "nix eval ${NIXOS_CONFIG}#${t}Configurations.${net.hostname}.options.m --apply 'm: let lib = (import <nixpkgs> {}).lib; in builtins.toJSON m' | sed 's/\\\\\\\\//g' | sed 's/^\"//' | sed 's/\"$//' | jq 'paths(scalars) as $p | getpath($p)' -r | sort";
in
# filterEnabled = lib.omega.attrs.filterLeaves (
#   k: v: (v == true && k == "enable") || (v == false && k == "disable")
# );
{

  # home.file = {
  #   ".config/currentcfg/nixos_enabled.json".text = toJSON (
  #     filterEnabled inputs.self.nixosConfigurations.${unsafeDiscardStringContext net.hostname}.config
  #   );
  #   ".config/currentcfg/home_enabled.json".text = toJSON (
  #     filterEnabled inputs.self.homeConfigurations.${unsafeDiscardStringContext net.hostname}.config
  #   );
  # };

  home.shellAliases = mkMerge [
    (
      if config.u.file.enable then
        let
          tree = "exa --tree --icons -a -I '.git|.svn|node_modules'";
        in
        {
          # ll = ''ls -alF'';
          inherit tree;
          ll = "exa --icons -a -l -F -h -g -s size --git";
          treed = "${tree} -D";
          treea = "exa --tree --icons -a -l -F -h -g -s size --git";
        }
      else
        {
          ll = "ls -alF";
        }
    )
    {
      klt = "khal list today";
      kltm = "khal list tomorrow";
      nopts = opts "nixos";
      hopts = opts "home";
      ndx = ''nix-shell -p nodejs_22 --run "npx create-directus-extension@latest"'';
      hms = "home-manager switch --flake ${NIXOS_CONFIG}#${net.hostname} --show-trace -b backup";
      nrs = "nixos-rebuild switch --flake ${NIXOS_CONFIG}#${net.hostname} --show-trace --sudo";
      nps = "nix repl --expr 'import <nixpkgs>{}'";
      ssh = "TERM=xterm-256color ssh";
      rg = "rg --hidden";
      vf = "vim $(fzf)";
      gst = "git status";
      gp = "git fetch && git pull";
      cal = "cal -m";
      please = "sudo";
      c = "clear";
      # f = "fuck";
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
      la = "ls -A";
      l = "ls -CF";
      lt = "ls --human-readable --size -1 -S --classify";
      # ld = "ls -ld */";
      lg = "ll | grep";
      hg = "history | grep";
      ag = "alias | grep";
      cpv = "rsync -ah --info=progress2";
      ipinfo = "curl ifconfig.me && curl ifconfig.me/host";
      clip = "xclip -sel c <";
      fg = "find . -print | grep ";
      dfr = "diff -ZBbwdryEN --color --suppress-common-lines --no-dereference --speed-large-files";
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
      ntyp = ''echo "= $(date +%d.%m.%y)" >> "$(date +%y.%m.%d).typ" && vim "$(date +%y.%m.%d).typ"'';
      qmk_left = "qmk flash -kb handwired/dactyl_manuform/4x6_omega -km custom -bl avrdude-split-left";
      qmk_right = "qmk flash -kb handwired/dactyl_manuform/4x6_omega -km custom -bl avrdude-split-right";
      qmk_cmp = "qmk compile -kb handwired/dactyl_manuform/4x6_omega -km custom";
      k_ch = "setxkbmap -layout ch -variant de";
      k_en = "setxkbmap -layout us";
      tarbak = "tar -czvf $(date +%F)-backup.tgz backup/";
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

      dcs = "${pkgs.docker_disk_usage}";
      flog = "${pkgs.filter_log}";
      ctf = "${pkgs.check_tmp_files}";
      csw = "${pkgs.check_swap}";
      sst = "${pkgs.show_stats}";

      vpn-school = ''sudo openconnect --useragent AnyConnect --protocol anyconnect -C "$(sudo cat /run/secrets/vpn/school/cookie)" -u georgiy.shevoroshkin@ost.ch --servercert "$(sudo cat /run/secrets/vpn/school/fingerprint)" vpn2.ost.ch'';
      vpn-school-cookie = "openconnect-sso -s vpn2.ost.ch --authenticate json";
      vpn-school-start = "sudo systemctl start openconnect-school";
      vpn-school-stop = "sudo systemctl stop openconnect-school";
      switch-git-to-ssh = ''new_origin="$(git config --get remote.origin.url | sed -E "s/https:\/\/([^\/]*)\/(.*)$/git@\1:\2/")"; git remote rm origin && git remote add origin "$new_origin"'';
    }
    (mkIf (!usr.minimal) { rm = "trash"; })
    (mkIf config.u.user.nixvim.enable {
      vim = "nvim";
      vi = "nvim";
    })
    (mkIf config.u.user.vim.enable { vi = "vim"; })
    cdAliases
  ];
}
