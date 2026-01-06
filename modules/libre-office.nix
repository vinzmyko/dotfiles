{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libreoffice-fresh
  ];

  # Set default
  xdg.mimeApps.defaultApplications = {
    "application/vnd.oasis.opendocument.spreadsheet" = "calc.desktop";
    "application/vnd.ms-excel" = "calc.desktop";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "calc.desktop";
  };
}
