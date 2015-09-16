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

# Overall git (on GitHub) process #

1. Set up [SSH keys at GitHub][githubssh] to avoid constant re-entry of password
  * Don't forget to fire up ssh-agent! eval is *required* : ``eval "$(ssh-agent -s)"``
1. Create a GitHub repository
  * Button on website. Not sure how to do this from the command line *in the context of GitHub*.
2. Appropriately set ``remote.origin.url``
3. Pick or create a local directory to work in, cd to it
4. ``git pull``
4. *Optional*: Create a [.gitignore][gitignore] file
5. Create / edit files
6. ``git add .`` (to add all) or ``git add <FILE_NAME_HERE>``
  * Will need to be called at some point to recognize any new files or edits.
7. More creation and editting
8. ``git commit`` (for files already added)
9. ``git push`` when you are ready to send changes to remote repository
10. ``git status`` call at any time to see what edits are pending in the system, and what files or edits you may have overlooked.

## Outstanding questions ##
* AFAICT all ``push``es to the remote repository will be versioned with full history. But:
  * If I ``add`` three times, what level of history is preserved?
     * Does a ``commit -a`` bypass any version tracking that may occur at the index level?
  * If I ``commit`` three times, what level of history is preserved?
     * When I ``commit``, does it clear any history that had been set by ``add``?
     
[githubssh]: https://help.github.com/articles/generating-ssh-keys/
[gitignore]: https://git-scm.com/docs/gitignore
