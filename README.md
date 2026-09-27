# Shared Development

This repository contains shared development environment configuration and tools that should be kept synchronized across projects. For example, style guides, generic AI prompts, etc.

## Setup

The intended usage is as a `git subtree`. First add the remote repositoory to your git config with an alias to save typing the URL out all the time.

```bash
git remote add -f shared-dev https://github.com/Shapedsundew9/shared-dev.git
```

Then pull the repo in as a sub-tree into the `.shared` folder in the root of the repo. Using the `.shared` folder name is a safe convention for rust or python tooling to ignore it. Squashing the repo commits into a single commit saves noise in the current repo's git log.

```bash
git subtree add --prefix=.shared shared-dev main --squash
git subtree pull --prefix=.shared shared-dev main --squash
```

You can then push changes with:

```bash
git subtree push --prefix=.shared shared-dev main
```

## Usage

To make best use of the configuration use symbolic links, e.g. `ln -s .shared/ai/core/prompts/* .github/prompts/`
