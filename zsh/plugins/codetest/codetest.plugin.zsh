#! /bin/zsh
setopt BASH_REMATCH
function codetest () {
	read "name?Enter GitHub username (or repo slug without the automattic-hiring org part)"
	echo "Username: $name"
	read "branch?Enter GitHub branch to test sync names command"
	echo "Branch: $branch"
	repo="git@github.com:automattic-hiring/backend-v2-code-test-$name.git"
	if test -z "$name" || test -z "$repo" || test -z "$branch"
	then
		echo "You should add the username and branch name before proceeding. Try again."
		return
	fi
	
	echo "Adding remote $name for repo $repo"
	git remote add $name $repo 
	echo "Fetching $name at $repo"
	git fetch $name 
	echo "Checking out $name/$branch"
	git checkout $name/$branch
	echo "Starting lando and resetting db"
	git checkout trunk .lando.yml
	git checkout trunk bin/setup.sh
	git checkout trunk .env
	git checkout trunk php.ini
	git checkout trunk bin/install-wp-tests.sh
	git checkout trunk .wp-tests-config.php
	git checkout trunk .nginx-wordpress.conf
	git checkout trunk .wp-cli.yml
	lando start
	lando wp rusty reset-data
	echo "Ready to go. Run lando wp rusty sync-names to start testing"
	echo "Scorecard template is here https://github.com/automattic-hiring/code-test-web-v2/blob/trunk/internal/SCORECARD.md#scorecard-to-use"
}
