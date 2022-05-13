#!/bin/sh

# Git command line goodies.

alias ga="git add"
alias gc="git commit"
alias gg="git pull"
alias gp="git push"
alias gs="git status"

gd() {
    ( test "$#" -eq 0 && git diff ) || git diff "$*"
}

_g_inside_work_tree_p() {
    git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

gl() {
    _g_inside_work_tree_p || (>&2 echo "Not in git repo."; return 1)
    cmd="(progn
           (magit-log-all)
           (delete-other-windows))"
    [ "$#" -eq 1 ] && cmd="(progn
                             (find-file \"$1\")
                             (magit-log-buffer-file)
                             (delete-other-windows))"
    emacs-runner -e "$cmd"
}

gclean() {
    # https://stackoverflow.com/questions/1146973/how-do-i-revert-all-local-changes-in-git-managed-project-to-previous-state#answer-42903805
    #
    # - Deletes local, non-pushed commits
    # + Reverts changes you made to tracked files
    # + Restores tracked files you deleted
    # + Deletes files/dirs listed in .gitignore (like build files)
    # + Deletes files/dirs that are not tracked and not in .gitignore

    git clean --force -d -x
    git reset --hard
}

# Case sensitive search.
alias gs-changes="git log -p --all -S"
_gmessage_search () {
    git log --all --grep="$*"
}
alias gs-message="_gmessage_search"

# Show changes of a commit (last commit if hash is not supply).
alias gshow="git show --color --pretty=format:%b"  # use -R to show in reverse order

# Reset to revision.
# In a normal way, it's need to:
# Usage: grevert 741083d
# Usage: grevert 741083d file1 file2
_grevert() {
    method="$1"
    hash="$2"
    shift
    files=""
    if ! test "$#" -eq 1; then
        shift
        files="$*"
    fi
    bash -c "git apply <(git $method $hash -R $files)"
}

alias grevert-commit="_grevert show"
alias grevert="_grevert diff"
