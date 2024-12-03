{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    nativeBuildInputs = with pkgs; [
        nasm
        cbqn
        clojure
    ];
}
