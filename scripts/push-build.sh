#!/bin/sh

# Push compiled *.pdf to the build branch
############################################################

USERNAME="$GIT_NAME"
REPO=introduzione-teoria-misura
DESTINATION=build
SOURCE_BRANCH=master
DESTINATION_BRANCH=build

if [[ $TRAVIS_PULL_REQUEST -gt 0 ]]; then
    echo 'Pull request detected. Not proceeding with deploy.'
    exit
fi

# Make sure destination folder exists as git repo
cd $DESTINATION
git init
git remote add upstream "https://$GIT_NAME:$GH_TOKEN@github.com/$USERNAME/$REPO.git"
git fetch upstream
git reset "upstream/$DESTINATION_BRANCH"
cd ..

# Configure git if this is run in Travis CI
if [[ -n $TRAVIS ]]; then
    cd $DESTINATION
    git config user.name "$GIT_NAME"
    git config user.email $GIT_EMAIL
    git config push.default simple
    cd ..
fi

git checkout $SOURCE_BRANCH

# Commit and push to github
sha=$(git log | sed -n 's/.*\([a-z0-9]\{40\}\).*/\1/p' | head -1)
cd $DESTINATION
git add README.md *.pdf
git commit -m "Updating to $USERNAME/$REPO@$sha."
git push --quiet upstream HEAD:$DESTINATION_BRANCH
echo "Pushed updated branch $DESTINATION_BRANCH to GitHub."
cd ..

cd $DESTINATION
git remote remove upstream
cd ..
