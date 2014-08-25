#!/bin/bash
# print changelog line for the current date and git user

listfiles(){
    # list staged files
    git diff --name-only --cached
    # list changed files
    git diff --name-only
}

listfiles | sort -u | sed -e 's/^/\t* /' -e 's/$/: \n/'

