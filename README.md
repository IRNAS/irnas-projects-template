# Irnas's Projects template

IRNAS template for a GitHub repository. It comes with a
[basic group](https://github.com/IRNAS/irnas-workflows-software/tree/main/workflow-templates/basic)
of CI workflows for release automation.

## Checklist

### General GitHub setup

- [ ] Provide a concise and accurate description of your project in the GitHub "description" field.
- [ ] Provide a concise and accurate description of your project in this `README.md` file, replace
      the default title.
- [ ] Ensure that your project follows [repository naming scheme].
- [ ] Add a project logo to the `README.md` file. The logo should be placed in the `doc/images`
      folder. Use the following syntax to include it:

  ```markdown
  ![Project Logo](doc/images/logo.svg)
  ```

[repository naming scheme]:
  https://github.com/IRNAS/irnas-guidelines-docs/blob/main/docs/github_projects_guidelines.md#repository-naming-scheme-

### Tooling

- [ ] Turn on `pre-commit` tool by running `pre-commit install`. If you do not have it yet, follow
      instructions
      [here](https://github.com/IRNAS/irnas-guidelines-docs/tree/main/tools/pre-commit). **Note**:
      This tool is optional for mechanical and electronic projects.

### Non-software projects

- [ ] If needed re-read [GitHub for non-software projects] section. It describes what files should
      be committed to the repository and what files should be added to the release assets.
- [ ] Create `assets` folder with files that will be part of the next release. The files in this
      folder will be automatically compressed into a zip file and attached to the release assets
      during the release process. The files should be added to the `assets` folder before creating
      the first release. This step is **optional**, it depends on the type of your project.

[GitHub for non-software projects]:
  https://github.com/IRNAS/irnas-guidelines-docs/blob/main/docs/github_projects_guidelines.md#github-for-non-software-projects-

### Cleanup

- [ ] If you don't want to use `pre-commit` tool delete the following files:
  - `.markdownlint.yaml`
  - `.pre-commit-config.yaml`
  - `.prettierrc.yaml`
  - `committed.toml`
  - `ruff.toml`
  - `typos.toml`
  - `.github/workflows/pre-commit.yaml`
- [ ] As a final step delete this checklist and commit changes.

## Repository folder structure

- `doc/` - Project and development documentation.
- `doc/images/` - Images used in the documentation, such as diagrams, screenshots, or logos.
- `assets/` - Files that will be part of the next release. process.
- `CHANGELOG.md` - Document used for tracking changes in the project. It follows the
  [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format.
- `.github` - GitHub Actions workflows and other GitHub related files.
