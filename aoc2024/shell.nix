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
        # day 10
        jq
        # day 11
        kotlin
        # day 12
        luajit
        # day 13
        jdk
        # day 14
        nim
        # day 15
        ocaml
        ocamlPackages.utop
        # day 16
        python39
        # day 17
        rustc
    ];
}
