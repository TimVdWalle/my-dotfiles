#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

PROJECTS=~/Projects

mkd "$PROJECTS"

clone_repo() {
    local url="$1"
    local dest="$2"
    local msg="$3"
    if [ ! -d "$dest" ]; then
        execute "git clone $url $dest" "$msg"
    else
        print_success "$msg (already cloned)"
    fi
}

if [ "$IS_TESTING" = "true" ]; then
    :
else
    clone_repo "git@github.com:TimVdWalle/dart-score.git" "$PROJECTS/dart-score" "Cloning dart-score"
    clone_repo "git@github.com:TimVdWalle/commit-verbs.git" "$PROJECTS/commit-verbs" "Cloning commit-verbs"
    clone_repo "git@github.com:TimVdWalle/phpstan-watcher.git" "$PROJECTS/phpstan-watcher" "Cloning phpstan-watcher"
    clone_repo "git@github.com:TimVdWalle/request_viewer.git" "$PROJECTS/request-viewer" "Cloning request-viewer"
fi

# setup git hook script(s)
if [ -f "$PROJECTS/commit-verbs/git-templates/hooks/prepare-commit-msg" ]; then
  chmod +x "$PROJECTS/commit-verbs/git-templates/hooks/prepare-commit-msg"
  # Only set if it's not already set
  current_template=$(git config --global init.templateDir)
  if [ "$current_template" != "$PROJECTS/commit-verbs/git-templates" ]; then
    git config --global init.templateDir "$PROJECTS/commit-verbs/git-templates"
  fi
fi

# Check if we should log overall success
if [ "$IS_TESTING" != "true" ]; then
    print_success "GitHub repositories check complete."
fi
