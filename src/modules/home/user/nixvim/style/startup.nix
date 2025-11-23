{
  programs.nixvim = {
    plugins.startup = {
      enable = true;
      options = {
        paddings = [
          1
          3
        ];
      };
      colors = {
        background = "#ffffff";
        foldedSection = "#ffffff";
      };

      sections = {
        header = {
          type = "text";
          oldfilesDirectory = false;
          align = "center";
          foldSection = false;
          title = "Header";
          margin = 5;
          content = [
            " ██████╗ ███╗   ███╗███████╗ ██████╗  █████╗       ██╗   ██╗██╗███╗   ███╗"
            "██╔═══██╗████╗ ████║██╔════╝██╔════╝ ██╔══██╗      ██║   ██║██║████╗ ████║"
            "██║   ██║██╔████╔██║█████╗  ██║  ███╗███████║█████╗██║   ██║██║██╔████╔██║"
            "██║   ██║██║╚██╔╝██║██╔══╝  ██║   ██║██╔══██║╚════╝╚██╗ ██╔╝██║██║╚██╔╝██║"
            "╚██████╔╝██║ ╚═╝ ██║███████╗╚██████╔╝██║  ██║       ╚████╔╝ ██║██║ ╚═╝ ██║"
            " ╚═════╝ ╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝        ╚═══╝  ╚═╝╚═╝     ╚═╝"
          ];

          highlight = "Statement";
          defaultColor = "";
          oldfilesAmount = 0;
        };
        body = {
          type = "mapping";
          oldfilesDirectory = false;
          align = "center";
          foldSection = false;
          title = "Menu";
          margin = 5;
          content = [
            [
              " Find File"
              "Telescope find_files"
              "<leader>ff"
            ]
            [
              "󰍉 Find Word"
              "Telescope live_grep"
              "<leader>fr"
            ]
            [
              " Find TODO's"
              "Telescope todo"
              "<leader>ft"
            ]
            [
              " Git Files"
              "Telescope git_files"
              "<leader>fg"
            ]
          ];
          highlight = "string";
          defaultColor = "";
          oldfilesAmount = 0;
        };
      };

      parts = [
        "header"
        "body"
      ];
    };
  };
}
