#!/usr/bin/python

import sys
import os
import getopt

DEFAULT_REMOTE = "upstream"

def shell_exec(cmd):
    return os.popen(cmd).read()

def getCurrentBranch():
    cmd = 'git status | grep "On branch"'
    ret = shell_exec(cmd)

    if len(ret) <= 0:
        return None
    else:
        return ret.split(' ')[-1].rstrip()

class AppConfig:
    remote_branch = None
    remote = DEFAULT_REMOTE
    dest_branch = getCurrentBranch()
    show_help = False

    def __init__(self, options=None):
        self.__load_options(options)

    def __load_options(self, options):
        if not options is None:
            for opt,arg in options:
                if opt in ('-h', '--help'):
                    self.show_help = True
                elif opt in ('-s', '--remote-branch'):
                    self.remote_branch = arg
                elif opt in ('-r', '--remote'):
                    self.remote = arg
                elif opt in ('-d', '--dest-branch'):
                    self.dest_branch = arg

    def __str__(self):
        return """
Show Help       =\t%(h)s
Remote Branch   =\t%(rb)s
Remote          =\t%(r)s
Dest Branch     =\t%(db)s
""" % {"h": self.show_help, "rb": self.remote_branch, "r": self.remote, "db": self.dest_branch}

def help_message():
    print("""pullbase.py
    --remote-branch The branch to pull from
    --remote        The remote to use (upstream by default)
    --dest-branch   The branch to rebase onto (current by default)
    """)
    sys.exit(0)

if __name__ == "__main__":
    options, remainder = getopt.getopt(sys.argv[1:], 'h:s:r:d', [
                            'help',
                            'remote-branch=',
                            'remote=',
                            'dest-branch=',
                        ])
    
    config = AppConfig(options)

    if config.show_help or config.remote_branch is None:
        help_message()

    if config.remote is None:
        config.remote = DEFAULT_REMOTE

    if config.dest_branch is None:
        config.dest_branch = getCurrentBranch()

    if config.dest_branch is None:
        print("Could not find a valid destination branch.")

    #1. Checkout remote_branch
    ret = shell_exec("git checkout " + config.remote_branch)
    if getCurrentBranch() != config.remote_branch:
        print("ERROR: Something went wrong checking out " + config.remote_branch)
        print("current branch=", getCurrentBranch())
        print("remote_branch=", config.remote_branch)
        print("ret=", ret)
        sys.exit(1)

    #2. Pull from remote remote_branch
    ret = shell_exec("git pull %(r)s %(rb)s" % {"r": config.remote, "rb": config.remote_branch})

    #3. Checkout dest_branch
    ret = shell_exec("git checkout " + config.dest_branch)

    #4. Rebase remote_branch
    ret = shell_exec("git rebase " + config.remote_branch)
