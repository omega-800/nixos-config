{ globals, ... }: {
  # i just fucked up real bad
  home.sessionVariables = globals.envVars;
  gtk.gtk2.configLocation = globals.envVars.GTK2_RC_FILES;
}
