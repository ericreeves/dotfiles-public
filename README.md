# Eric's dotfiles!

This repository contains Eric's pile of dotfiles configuration managed with Chezmoi (https://www.chezmoi.io/).

It deploys Eric's very opinionated configuration for the following items:

- ZSH using zcomet as a plugin manager
- P10K as the fancy ZSH prompt that includes Kubernetes context, aws-vault context, Git repo status, and lots of other fun stuff
- VIM and a large set of plugins using vundle as the plugin manager
- Tmux configuration
- Random scripts used for Linux/X

The following scripts are also contained within the repository for installing HomeBrew on various Linux distributions and a common set of packages that I use.  (These scripts are not automatically run by Chezmoi).
- install-base.sh - Installs HomeBrew and Core Packages
- install-packagse.sh - Installs various packages via HomeBrew
- setup-aws-vault.sh - Signs into 1Password and Adds cd15-master to the aws-vault configuration

To utilize this repository:

- Fork it!
- Open it up and review it!  Strip out the stuff that is not relevant to your use case, and make sure you replace instances of my name/email address with your own.
- It's likely not going to just cleanly run on the first try without doing a bit of cleanup first.  I didn't spend time ensuring it was fully parameterized.  Sorry.  :)
- Install Chezmoi (https://www.chezmoi.io/)
- ``` chezmoi init https://github.com/username/dotfiles.git ```

Chezmoi is awesome.  I have tried a number of dotfile managers, and Chezmoi is the most flexible and robust for my purposes.  It even has the ability to encrypt files using GPG or AGE, so that you can safely store things like SSH keys in Github.  (I stripped mine out of this repository for the purposes of sharing with others).

Read the Chezmoi docs.  It does lots of stuff and is awesome.

Good luck!

# Author

Author:: Eric Reeves (<eric@alluvium.com>)
