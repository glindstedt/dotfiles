
function fish_prompt
  if not set -q -g __fish_robbyrussell_functions_defined
    set -g __fish_robbyrussell_functions_defined
    function _git_branch_name
      echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
    end
    function _is_git_dirty
      echo (git status -s --ignore-submodules=dirty ^/dev/null)
    end
    function _git_stash_number
      echo (git stash list ^/dev/null | wc -l | xargs)
    end
  end

  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l white (set_color -o white)
  set -l normal (set_color $fish_color_cwd)
  set -l arrow "$red➜ "
  set -l cwd $normal(basename $PWD)

  # GIT
  if test -z "$git_info_ts"; or [ (math -- "(" (date +%s) "-$git_info_ts)") -gt 2 ]
    if [ (_git_branch_name) ]
        set -l git_branch $white(_git_branch_name)
        set -g git_info "$white ($git_branch$white)"
        if [ (_is_git_dirty) ]
          set -l dirty "$yellow ✗"
          set -g git_info "$git_info$dirty"
        end
        set -l stash_number (_git_stash_number)
        if test "$stash_number" -lt 0 > /dev/null
          set -g git_info "$git_info $cyan$stash_number"
        end
    else
        set -g git_info ""
    end
    set -g git_info_ts (date +%s)
  end

  # K8S
  set -l k8s_context (kubectl config current-context)
  set k8s_info "$white [$red$k8s_context$white]"

  echo -n -s $cwd $k8s_info $git_info $white ' $ '
end
