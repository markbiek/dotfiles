#! /bin/zsh
setopt BASH_REMATCH

function codetest_clean() {
    local confirm
    read "confirm?Are you sure you want to delete everything in ~/dev/a8c/hiring/code-tests (including hidden files)? [y/N]: "
    if [[ $confirm =~ ^[Yy]$ ]]; then
        rm -rf ~/dev/a8c/hiring/code-tests/*(D)
        echo "All contents of ~/dev/a8c/hiring/code-tests have been deleted."
    fi

	read "confirm?Would you like to remove all git remotes except example-v3, source, and origin? [y/N]: "
	if [[ $confirm =~ ^[Yy]$ ]]; then
		cd ~/dev/a8c/hiring/code-tests
		for remote in $(git remote); do
			if [[ $remote != "example-v3" && $remote != "source" && $remote != "origin" ]]; then
				git remote remove $remote
				echo "Removed remote: $remote"
			fi
		done
		echo "Finished cleaning git remotes."
	fi
}

function codetest () {
	function info() {
		echo -e "\033[1;34m$1\033[0m"
	}

	function error() {
		echo -e "\033[41m\033[1;37m$1\033[0m"
	}

	# Default version to v3
	local version="v3"

	if [[ -n "$1" && -n "$2" ]]; then
        name="$1"
        branch="$2"
        # If third argument is provided, use it as version
        [[ -n "$3" ]] && version="$3"
    else
        # If not both arguments provided, prompt for input
        read "name?Enter GitHub username (or repo slug without the automattic-hiring org part): "
        read "branch?Enter GitHub branch to test sync names command: "
    fi

	info "Username: $name"
	info "Branch: $branch"
	info "Version: $version"

	repo="git@github.com:automattic-hiring/backend-${version}-code-test-$name.git"
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
