# Managing electronic projects

At IRNAS the electronic projects are created and developed in Altium designer. GitHub repositories
are used only provide a copy of the Altium project, to make this work accessible to external clients
and to make possible handover easier.

Although Altium Designer uses Git to version control project files, it doesn't have a direct GitHub
integration. This requires some custom scripts to make syncing changes to GitHub and creating GitHub
release a seamless experience.

## Setup for running scripts

The folder `scripts/electronics` contains all scripts that an electronic engineer would need.

To run them you will need to install Git: <https://git-scm.com/downloads>

After installing Git the scripts can be run by directly clicking on them or by running them in the
`cmd` or Git Bash.

## Creating a new Altium project

TODO: below section needs more steps

1. Create a new Altium project directly in the Altium Designer, from the provided template.
2. Go through the project setup checklist and do it.
3. Commit project changes in the Altium Designer.
4. Run script `scripts/electronics/sync_to_github.sh`.

Script will create a new GitHub repository with the same name as the Altium Project.

## Syncing new Altium changes to the GitHub

Whenever you need to sync recent Altium changes to the GitHub, without necessarily creating a new
release, just run `script/electronics/sync_to_github.sh`

## Creating a new release

TODO:

1. Create release through the Altium Designer.
2. Run the script `scripts/electronics/create_release.sh`.
