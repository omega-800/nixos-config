{ pkgs, sys, lib, ... }: {
  config = lib.mkIf sys.hardened {
    services.fail2ban = {
      enable = true;
      bantime = "1h";
      bantime-increment = {
        enable = true;
        factor = "4";
        formula =
          "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        maxtime = "48h";
        multipliers = "1 2 4 8 16 32 64";
        rndtime = "8m";
      };
      #TODO: put all ip's of local hosts in here
      ignoreIP = [
        "172.16.16.0/24"
        "10.2.2.0/24"
        "10.100.0.0/24"
        "10.1.1.0/24"
        "10.0.0.0/24"
      ];
      maxretry = 5;
      jails = {
        sshd.settings = {
          filter = "sshd";
          action = "iptables[name=ssh, port=ssh, protocol=tcp]";
          maxretry = 4;
          enabled = true;
        };
        sshd-ddos.settings = {
          filter = "sshd-ddos";
          action = "iptables[name=ssh, port=ssh, protocol=tcp]";
          maxretry = 2;
          enabled = true;
        };
        port-scan.settings = {
          filter = "port-scan";
          action = "iptables-allports[name=port-scan]";
          maxretry = 2;
          bantime = 7200;
          enabled = true;
        };
        apache-nohome-iptables.settings = {
          # Block an IP address if it accesses a non-existent
          # home directory more than 5 times in 10 minutes,
          # since that indicates that it's scanning.
          filter = "apache-nohome";
          action = ''iptables-multiport[name=HTTP, port="http,https"]'';
          logpath = "/var/log/httpd/error_log*";
          backend = "auto";
          findtime = 600;
          bantime = 600;
          maxretry = 5;
        };
        ngnix-url-probe.settings = {
          enabled = true;
          filter = "nginx-url-probe";
          logpath = "/var/log/nginx/access.log";
          action = ''
            %(action_)s[blocktype=DROP]
                             ntfy'';
          backend =
            "auto"; # Do not forget to specify this if your jail uses a log file
          maxretry = 5;
          findtime = 600;
        };
      };
    };
    environment.etc = {
      # Define an action that will trigger a Ntfy push notification upon the issue of every new ban
      "fail2ban/action.d/ntfy.local".text = pkgs.lib.mkDefault
        (pkgs.lib.mkAfter ''
          [Definition]
          norestored = true # Needed to avoid receiving a new notification after every restart
          actionban = curl -H "Title: <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(hostname) after <failures> attempts of hacking the system." https://ntfy.sh/Fail2banNotifications
        '');
      # Defines a filter that detects URL probing by reading the Nginx access log
      "fail2ban/filter.d/nginx-url-probe.local".text = pkgs.lib.mkDefault
        (pkgs.lib.mkAfter ''
          [Definition]
          failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
        '');
      "fail2ban/filter.d/port-scan.conf".text = ''
        [Definition]
        failregex = rejected connection: .* SRC=<HOST>
      '';
    };

    # Limit stack size to reduce memory usage
    systemd.services.fail2ban.serviceConfig.LimitSTACK = 256 * 1024;
  };
}
