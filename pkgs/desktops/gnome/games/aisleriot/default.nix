{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, pkg-config
, itstool
, gtk3
, wrapGAppsHook3
, meson
, librsvg
, libxml2
, desktop-file-utils
, guile
, libcanberra-gtk3
, ninja
, appstream-glib
, yelp-tools
}:

stdenv.mkDerivation rec {
  pname = "aisleriot";
  version = "3.22.30";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "aisleriot";
    rev = version;
    sha256 = "sha256-Fj5v2h6xDqf+PPxduxGr3vTy+eZ3aIv0u/ThrheYLGQ=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    meson
    ninja
    appstream-glib
    pkg-config
    itstool
    libxml2
    desktop-file-utils
    yelp-tools
  ];

  buildInputs = [
    gtk3
    librsvg
    guile
    libcanberra-gtk3
  ];

  prePatch = ''
    patchShebangs cards/meson_svgz.sh
    patchShebangs data/meson_desktopfile.py
    patchShebangs data/icons/meson_updateiconcache.py
    patchShebangs src/lib/meson_compileschemas.py
  '';

  mesonFlags = [
    "-Dtheme_kde=false"
  ];

  passthru = {
    updateScript = gitUpdater {
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/aisleriot";
    description = "A collection of patience games written in guile scheme";
    mainProgram = "sol";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
