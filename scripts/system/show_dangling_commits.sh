#!/bin/bash
# recover_dangling_commits.sh
# Shows all dangling commits and their messages, then gives cherry-pick instructions.

echo "🔍 Searching for dangling commits..."
dangling_commits=$(git fsck --lost-found | grep 'dangling commit' | awk '{print $3}')

if [[ -z "$dangling_commits" ]]; then
    echo "✅ No dangling commits found."
    exit 0
fi

echo
echo "📜 Dangling commits found:"
echo "----------------------------------------"
for commit in $dangling_commits; do
    msg=$(git log -n 1 --pretty=format:"%s" $commit)
    date=$(git log -n 1 --pretty=format:"%ci" $commit)
    echo "$commit  |  $date  |  $msg"
done
echo "----------------------------------------"
echo
echo "💡 To recover these commits:"
echo "1. Create a new branch from your current HEAD:"
echo "   git checkout -b recovery-branch"
echo
echo "2. Cherry-pick the commits in the order you want:"
echo "   git cherry-pick <commit-hash-1> <commit-hash-2> ..."
echo
echo "⚠️ Tip: Cherry-pick them from oldest to newest to preserve history order."
