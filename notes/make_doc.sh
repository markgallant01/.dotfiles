#!/bin/bash

# ensure proper args
if [[ "$#" != 1 ]]; then
    echo "Incorrect number of args."
    echo "Usage: make_doc [arch/fedora/gentoo]"
else
    pandoc -s ./"$1"/"$1"_install_notes.md -o ./"$1"/"$"_install_notes.html
fi

