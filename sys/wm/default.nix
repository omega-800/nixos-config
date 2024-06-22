{ usr, ... }: {
  imports =
    [
      ./${usr.wm}
      ./${usr.wmType}
      ./dm
    ];
}
