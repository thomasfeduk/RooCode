cd ~/Desktop/staging
# Output pytest color
export PYTEST_ADDOPTS="--color=yes"

# Tool shortcuts
alias gr='grep -rli'
alias e='explorer'
alias gits='git status'
alias gitd='git diff'
alias gfa='git fetch --all --prune'
alias gfapm='git fetch --all --prune ; git checkout master && git pull ; git checkout main && git pull'
alias gitlol='git log --oneline --graph --all'
alias gitlolc='git log --oneline --graph'
alias gitlold='git log --graph --all --pretty=format:"%h%x09%an%x09%ad%x09%s"'
alias gitp='git push --set-upstream origin'
alias gitf2='git commit -a -m sadsadsadsad && git rebase -i HEAD~2'
alias gitr2='git rebase -i HEAD~2'
alias grh='git reset --hard'
alias gcm='git checkout master && git checkout main'
alias cls='clear'
alias p='python'
alias r='ruby'
alias uvi='uvicorn main:app --reload'
function ptest() {
  if [ -n "$1" ]; then
    python -m unittest discover -k "$1"
  else
    python -m unittest
  fi
}
function gitig() {
    local gitignore_file=".gitignore"

    if [[ -f "$gitignore_file" ]]; then
        echo "$gitignore_file already exists."
    else
        echo "Creating $gitignore_file with default entries."
        cat <<EOL > "$gitignore_file"
*.env
__pycache__
.idea
EOL
        echo "$gitignore_file has been created."
    fi
}
function gitb() {
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	declare -A local_branches_commit_hashes

	# First, gather commit hashes of all local branches
	while IFS= read -r line; do
	  IFS=' ' read -r hash branch <<< "$line"
	  local_branches_commit_hashes["$hash"]=1
	done < <(git for-each-ref --format='%(objectname) %(refname:short)' refs/heads/)

	# Process each ref (local and remote)
	git for-each-ref --sort=-committerdate refs/heads/ refs/remotes/ --format='%(objectname) %(refname)' | while IFS= read -r line; do
	  IFS=' ' read -r hash refname <<< "$line"
	  branch=${refname#refs/heads/}
	  branch=${branch#refs/remotes/}
	  is_remote=$(echo "$refname" | grep -c 'refs/remotes/')
	  star_prefix=""

	  if [ "$branch" = "$current_branch" ]; then
	    star_prefix="* "
	  fi

	  # If it's a remote branch, check if its commit hash matches any local branch hash
	  if [ "$is_remote" -eq 1 ] && [ -z "${local_branches_commit_hashes["$hash"]}" ]; then
	    # Remote branches in red
	    line=$(git for-each-ref --format="%(committerdate:short) %(objectname:short) \033[31m%(refname:short)\033[0m %(contents:subject)" "$refname")
	    echo -e "$line"
	  elif [ "$is_remote" -eq 0 ]; then
	    if [ "$branch" = "$current_branch" ]; then
	      # Current branch in green with "*"
	      line=$(git for-each-ref --format="%(committerdate:short) %(objectname:short) ${star_prefix}\033[32m%(refname:short)\033[0m %(contents:subject)" refs/heads/"$branch")
	    else
	      # Other local branches in yellow
	      line=$(git for-each-ref --format="%(committerdate:short) %(objectname:short) ${star_prefix}\033[33m%(refname:short)\033[0m %(contents:subject)" refs/heads/"$branch")
	    fi
	    echo -e "$line"
	  fi
	done

}

alias pcov='pytest --cov=. --cov-report=html && rm htmlcov/.gitignore'
alias phpcov='phpunit --coverage-html coverage_report-html'
alias puf='phpunit --filter '
alias piplam='pip install -r requirements.txt -t . --upgrade'
alias uvi='uvicorn main:app --reload'


# Find the common branch between $1 to $2 (ie HEAD to master, or feature-1 to master)
function gcb {
	diff -u <(git rev-list --first-parent ${1-HEAD}) <(git rev-list --first-parent ${2-master}) | sed -ne 's/^ //p' | head -1
}

# "Git delete merged"  branches. Deletes local and remote (origin) branches that have been merged into the current/specified branch
function gitdelmerged() {
    # get the current branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  # get the base branch from the first argument
  base_branch=$1

  # check that the current branch is the same as the base branch
  if [[ $current_branch != $base_branch ]]; then
    echo "Error: Current branch ($current_branch) is not the same as the base branch ($base_branch). Aborting."
    return 1
  fi

  # get a list of all branches that have been merged into the base branch
  merged_branches=$(git branch --merged | grep -v "\*" | xargs)

  # loop through the merged branches and delete them
  for branch in $merged_branches
  do
    # skip the base branch and the current branch
    if [[ $branch != $base_branch && $branch != $current_branch ]]
    then
      # delete the local branch
      echo "Deleting local branch: $branch"
      git branch -d $branch

      # check if the branch was successfully deleted
      if [[ $? -eq 0 ]]
      then
        # delete the remote branch
        echo "Deleting remote branch: $branch"
        git push origin --delete $branch
      else
        echo "Failed to delete local branch $branch"
      fi
    fi
  done

  # get a list of all remote branches that have been merged into the base branch
  echo "Scanning for merged remote branches"
  remote_merged_branches=$(git branch -r --merged | grep -v "\*" | xargs)

  # loop through the remote merged branches and delete them
  for remote_branch in $remote_merged_branches
  do
    # extract the branch name from the remote branch reference
    branch=$(echo $remote_branch | sed 's/.*\///')

    # skip the base branch and the current branch
    if [[ $branch != $base_branch && $branch != $current_branch ]]
    then
      # delete the remote branch
      echo "Deleting remote branch: $branch"
      git push origin --delete $branch
    fi
  done
}

f() {
  find . -iname "*$1*"
}

# Grap docx/xlsx word excel file searcher
grepx() {
  python - "$@" <<'EOF'
import os
import sys
import zipfile
import re

def search_docx(file_path, pattern, flags=re.IGNORECASE):
    matches = []
    with zipfile.ZipFile(file_path, 'r') as z:
        for name in z.namelist():
            if name.endswith('.xml'):
                try:
                    content = z.read(name).decode('utf-8', errors='ignore')
                    for line in content.splitlines():
                        if re.search(pattern, line, flags):
                            matches.append((f"{file_path}/{name}", line.strip()))
                except:
                    continue
    return matches

def search_text_file(file_path, pattern, flags=re.IGNORECASE):
    matches = []
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            for i, line in enumerate(f, 1):
                if re.search(pattern, line, flags):
                    matches.append((f"{file_path}:{i}", line.strip()))
    except:
        pass
    return matches

def main():
    if len(sys.argv) < 2:
        print("Usage: grepx PATTERN [DIRECTORY] [--show-matches]")
        sys.exit(1)

    pattern = sys.argv[1]
    base_dir = "."
    show_matches = False

    for arg in sys.argv[2:]:
        if arg == "--show-matches":
            show_matches = True
        elif not arg.startswith("-"):
            base_dir = arg

    seen_files = set()

    for root, _, files in os.walk(base_dir):
        for fname in files:
            fpath = os.path.join(root, fname)
            try:
                matches = []
                if fname.lower().endswith(('.docx', '.xlsx')):
                    matches = search_docx(fpath, pattern)
                elif fname.lower().endswith(('.txt', '.log', '.md')):
                    matches = search_text_file(fpath, pattern)
                else:
                    continue

                if matches:
                    if show_matches:
                        for path, line in matches:
                            print(f"{path}:{line}")
                    else:
                        if fpath not in seen_files:
                            print(fpath)
                            seen_files.add(fpath)

            except zipfile.BadZipFile:
                continue
            except Exception as e:
                print(f"[ERROR] {fpath}: {e}", file=sys.stderr)

if __name__ == '__main__':
    main()
EOF
}

