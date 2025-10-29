#!/bin/zsh

# Function to show usage
show_usage() {
  echo "Usage: $0 [source_branch] [--to target_branch]"
  echo "  source_branch: Source branch to merge from (default: develop)"
  echo "  target_branch: Target branch to merge into (default: main)"
  echo ""
  echo "Examples:"
  echo "  $0                    # merge develop into main"
  echo "  $0 next               # merge next into main"
  echo "  $0 next --to staging  # merge next into staging"
  echo "  $0 --to staging       # merge develop into staging"
}

# Parse command line arguments
SOURCE_BRANCH="develop"
TARGET_BRANCH="main"

while [[ $# -gt 0 ]]; do
  case $1 in
    --to)
      TARGET_BRANCH="$2"
      shift 2
      ;;
    --help|-h)
      show_usage
      exit 0
      ;;
    *)
      if [[ "$1" != --* ]]; then
        SOURCE_BRANCH="$1"
      else
        echo "Unknown option: $1"
        show_usage
        exit 1
      fi
      shift
      ;;
  esac
done

echo -e "\033[36mDeploy '$SOURCE_BRANCH' to '$TARGET_BRANCH'\033[0m"

# Function to check if there are uncommitted changes
check_uncommitted_changes() {
  if ! git diff-index --quiet HEAD --; then
    return 0 # There are uncommitted changes
  else
    return 1 # No uncommitted changes
  fi
}

# Function to cleanup and return to original state
cleanup_and_exit() {
  local exit_code=${1:-0}
  local message=${2:-"===== DEPLOY COMPLETE ====="}
  
  # Switch back to the original branch
  if [ "$CURRENT_BRANCH" != "$TARGET_BRANCH" ]; then
    echo -e "\033[36mSwitching back to original '$CURRENT_BRANCH' branch...\033[0m"
    git switch "$CURRENT_BRANCH"
  fi

  # Apply stashed changes if any
  if [ "$STASHED_CHANGES" = true ]; then
    echo -e "\033[36mApplying stashed changes back to '$CURRENT_BRANCH' branch...\033[0m"
    git stash pop
  fi
  
  echo -e "\033[32m$message\033[0m"
  exit $exit_code
}

# Get the current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
STASHED_CHANGES=false

# Check for uncommitted changes before switching
if check_uncommitted_changes; then
  echo -e "\033[36mYou have uncommitted changes in '$CURRENT_BRANCH' branch.\033[0m"
  echo -ne "Do you want to stash them and continue? (y/N): "
  read -r STASH_CONFIRM
  if [[ ! "$STASH_CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "\033[31mDeploy cancelled. Please commit or stash your changes manually.\033[0m"
    exit 1
  fi
  echo -e "\033[36mStashing changes from '$CURRENT_BRANCH' branch...\033[0m"
  git stash push -m "Auto-stashed by deploy script (from $CURRENT_BRANCH)"
  STASHED_CHANGES=true
fi

if [ "$CURRENT_BRANCH" != "$SOURCE_BRANCH" ]; then
  # Switch to the source branch
  echo -e "\033[36mSwitching to '$SOURCE_BRANCH' branch...\033[0m"
  git switch "$SOURCE_BRANCH"
fi

# Pull the latest changes from the remote source repository
echo -e "\033[36mPulling the latest changes from remote '$SOURCE_BRANCH' branch...\033[0m"
git pull --ff-only

# Switch to the target branch
if [ "$CURRENT_BRANCH" != "$TARGET_BRANCH" ]; then
  echo -e "\033[36mSwitching to '$TARGET_BRANCH' branch...\033[0m"
  git switch "$TARGET_BRANCH"
fi

# Pull the latest changes from the target branch
echo -e "\033[36mPulling the latest changes from remote '$TARGET_BRANCH' branch...\033[0m"
git pull --ff-only

# Merge the changes from source into the target branch using fast-forward only
echo -e "\033[36mMerging changes from '$SOURCE_BRANCH' into the '$TARGET_BRANCH' branch...\033[0m"
git merge --ff-only "origin/$SOURCE_BRANCH"

# Show the commits that will be pushed
echo -e "\033[36m===== COMMITS TO BE PUSHED TO $TARGET_BRANCH =====\033[0m"
COMMITS_TO_PUSH=$(git log --oneline --graph --color=always --format="%C(auto)%h%Creset - %s %Cgreen(%cr)%Creset %C(blue)<%an>%Creset" "origin/$TARGET_BRANCH..HEAD")

if [ -z "$COMMITS_TO_PUSH" ]; then
  echo -e "\033[33mNo new commits to push. Everything is up to date.\033[0m"
  cleanup_and_exit 0 "===== DEPLOY COMPLETE (NO CHANGES) ====="
fi

echo "$COMMITS_TO_PUSH"

# Ask for confirmation before pushing
echo -ne "Do you want to push these changes to the remote $TARGET_BRANCH branch? (y/N): "
read -r CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo -e "\033[31mPush cancelled. Exiting...\033[0m"
  cleanup_and_exit 1
fi

# Push the merged changes to the remote repository
echo -e "\033[36mPushing the changes to the remote repository...\033[0m"
git push

cleanup_and_exit 0
