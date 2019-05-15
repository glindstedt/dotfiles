if status --is-interactive
    # Git
    abbr --add --global gco git checkout
    abbr --add --global gfp git fetch --prune
    abbr --add --global gpl git pull
    abbr --add --global gps git push
    abbr --add --global gbr git branch
    abbr --add --global glg git log --graph --all
    abbr --add --global grb git rebase
    abbr --add --global gdf git diff --ws-error-highlight=all
    abbr --add --global gst git status
    abbr --add --global gsta git stash
    abbr --add --global gcm git commit
    abbr --add --global gam git commit --amend --no-edit
    abbr --add --global gpo 'git push -u origin (git_branch_name)'
end
