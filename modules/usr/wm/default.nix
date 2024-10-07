{ usr, ... }: {
  imports = [
    ./${usr.wm}
    ./${usr.wmType}
    ./input
  ];
}
