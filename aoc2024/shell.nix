{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    nativeBuildInputs = with pkgs; [
        # day 1
        nasm
        # day 2
        cbqn
        # day 3
        clojure
        clojure-lsp
        # day 4
        # broken installation on nix
        # dmd
        # day 5
        erlang
        # day 6
        # day 7
        gleam
        # day 8
        ghc
        # day 9
        go
    ];
}
