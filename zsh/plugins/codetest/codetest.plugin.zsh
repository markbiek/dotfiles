#! /bin/zsh
setopt BASH_REMATCH
function codetest () {
	function info() {
		echo -e "\033[1;34m$1\033[0m"
	}

	function error() {
		echo -e "\033[41m\033[1;37m$1\033[0m"
	}

	read "name?Enter GitHub username (or repo slug without the automattic-hiring org part): "
	info "Username: $name"

	read "branch?Enter GitHub branch to test sync names command: "
	info "Branch: $branch"

	repo="git@github.com:automattic-hiring/backend-v2-code-test-$name.git"
	if test -z "$name" || test -z "$repo" || test -z "$branch"
	then
		error "You should add the username and branch name before proceeding. Try again."
		return
	fi

	if [ ! -d ".git" ]; then
		git init
	fi

	info "Adding remote $name for repo $repo"
	git remote add $name $repo 

	info "Fetching $name at $repo"
	git fetch $name 

	info "Creating branch $branch from $name/$branch"
	git checkout -b $branch $name/$branch

	info "Resetting db"
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
	info "Ready to go. Run lando wp rusty sync-names to start testing"
	info "Scorecard template is here https://github.com/automattic-hiring/code-test-web-v2/blob/trunk/internal/SCORECARD.md#scorecard-to-use"
}
