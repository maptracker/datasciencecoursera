# Git Top-Level Organization #

1. Workspace = Your local filesystem, "live" files
2. Index = Transient bookmarks in your local edit chain?
3. Local Repository = locally-held version control system that tracks history of your edits
4. Remote Repository = authoritative VCS tracking edits from all users

# Basic git Commands #
* ``git add .`` = add all new files
* ``git add -u`` = update looking for renames or deletions
* ``git add -A`` = combination of two above commands
* ``git config --list`` = show all configuration values

## git Configuration ##
* ``remote.origin.url`` = URI to remote repository
  * ``git@github.com:<USER_NAME_HERE>/<REPO_NAME_HERE>.git``
    *I believe this syntax is specific for SSH authentication*

## Branches ##
* Useful for working on a collaborative project without risking your edits conflicting with those of your colleagues. The branch is an isolated copy of the repo that can be merged back into the main repository later.
* ``git checkout -b <BRANCH_NAME_HERE>``
* ``git branch`` = tells you the current branch you're working on
* ``git checkout master`` = return to the 'main' branch
* On GitHub (not generic git) you can use pull to merge your branch back into a repository. This is done by "Compare & Pull Request" button, and sends a message to the main repo, requesting that your edits get merged in.

# Overall git (on GitHub) process #

1. Set up [SSH keys at GitHub][githubssh] to avoid constant re-entry of password
  * Don't forget to fire up ssh-agent! eval is *required* : ``eval "$(ssh-agent -s)"``
1. Create a GitHub repository
  * Button on website. Not sure how to do this from the command line *in the context of GitHub*.
2. Appropriately set ``remote.origin.url``
2. To copy in bulk the repository, use
   ``git clone git@github.com:<USER_NAME_HERE>/<REPO_NAME_HERE>.git``
   *I believe this syntax is specific for SSH authentication*
3. Pick or create a local directory to work in, cd to it
4. ``git pull`` (If you need to bring edits from repository locally)
4. *Optional*: Create a [.gitignore][gitignore] file
5. Create / edit files
6. ``git add .`` (to add all) or ``git add <FILE_NAME_HERE>``
  * Will need to be called at some point to recognize any new files or edits.
7. More creation and editting
8. ``git commit -m '<MESSAGE_HERE>'`` (for files already added)
  * If you have not specified a commit message then an editor will pop up requesting a message. There's probably a setting you can change to allow message-less commits.
9. ``git push`` when you are ready to send changes to remote repository
  * Our corporate network is ... suboptimal. Use ``-v`` flag for more feedback on what is happening (or not happening).
10. ``git status`` call at any time to see what edits are pending in the system, and what files or edits you may have overlooked.

## Outstanding questions ##
* AFAICT all ``push``es to the remote repository will be versioned with full history. But:
  * If I ``add`` three times, what level of history is preserved?
     * Does a ``commit -a`` bypass any version tracking that may occur at the index level?
  * If I ``commit`` three times, what level of history is preserved?
     * When I ``commit``, does it clear any history that had been set by ``add``?
     
[githubssh]: https://help.github.com/articles/generating-ssh-keys/
[gitignore]: https://git-scm.com/docs/gitignore
