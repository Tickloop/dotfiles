---
name: manage-dotfiles
description: Manage, compare, sync, commit, and push this user's bare dotfiles repository. Use when work concerns the dotfiles alias, ~/.dotfiles, its main or config/linux branch, or cross-platform Neovim configuration in that repository.
---

# Manage Dotfiles

Use the repository conventions below. Keep unrelated home-directory changes out of commits.

## Repository layout

- The shell alias is:

  ```sh
  alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  ```

- `~/.dotfiles` is a bare Git repository. `$HOME` is its work tree.
- A normal `git` command inside `~/.config/nvim` will report that it is not a repository.
- In a non-interactive shell, the alias might not be loaded. Use this equivalent form:

  ```sh
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" <command>
  ```

- The remote is `git@github.com:Tickloop/dotfiles.git`.
- Use `--untracked-files=no` for routine status checks so Git does not scan or list the whole home directory:

  ```sh
  dotfiles status --short --branch --untracked-files=no
  ```

## Branches

- `main` is the macOS configuration.
- `config/linux` is the Linux configuration. The branch name is lowercase; do not use `config/Linux`.
- Shared Neovim behavior should stay aligned across both branches.
- Preserve intentional platform differences. In particular, macOS uses the Karabiner `F13` key layer, while Linux uses Control-based mappings.
- Do not merge or copy the complete Neovim tree blindly. Compare the branches, carry shared changes to both, and retain platform-specific key mappings and settings.

## Commit identity

Every new commit for this repository must use this identity for both author and committer:

```text
Tickloop <pulkit.arya.tech@gmail.com>
```

Set it in every temporary repository before committing:

```sh
git config user.name Tickloop
git config user.email pulkit.arya.tech@gmail.com
```

Verify each new commit before pushing:

```sh
git show -s --format='author %an <%ae>%ncommitter %cn <%ce>%nsubject %s' HEAD
```

If an unpushed commit has the wrong identity, set the local identity and amend it with:

```sh
git commit --amend --no-edit --reset-author
```

Do not rewrite an already-pushed commit only to change its identity unless the user explicitly asks.

## macOS GitHub authentication

Use this private key when pushing from macOS:

```text
/Users/arya/.ssh/github-tickloop
```

Force Git to use only that key:

```sh
git -c core.sshCommand='ssh -i /Users/arya/.ssh/github-tickloop -o IdentitiesOnly=yes' push ...
```

The default SSH identity can authenticate as `pulkit-pointer`, which does not have write access to `Tickloop/dotfiles`. Do not change the repository remote to work around this. Use the Tickloop key for the push.

## Safe sync workflow

1. Inspect the live bare repo first. Note modified and staged files. Do not include unrelated edits such as `.zshrc` unless the user places them in scope.
2. Fetch the latest `main` and `config/linux` tips into a new temporary repository under `/tmp`. Use that checkout to compare and reconcile branches without switching the live home-directory work tree.
3. Review the commit history and file diffs under `.config/nvim`. Identify shared behavior and platform-specific mappings before editing.
4. Apply shared changes to both branches. Keep macOS and Linux mappings separate where their input layers differ.
5. Validate changed Lua with Neovim's parser, validate JSON lock files with `jq empty`, and run `git diff --check`.
6. Stage only the intended files. Check `git status --short --branch` and the cached diff before committing.
7. Confirm each new branch tip is a fast-forward of its remote tip with `git merge-base --is-ancestor`.
8. Push both prepared branches atomically when the user has asked for both pushes:

   ```sh
   git -c core.sshCommand='ssh -i /Users/arya/.ssh/github-tickloop -o IdentitiesOnly=yes' push --atomic origin main:main config/linux:config/linux
   ```

   Adjust the local source ref when a temporary checkout uses a name such as `local/main`.
9. After a successful push, fetch the new remote-tracking refs into `~/.dotfiles` and fast-forward the local `config/linux` ref. Verify that local and remote tips match. Leave the live work tree on `main` unless the user asks to switch it.

Ask for approval immediately before operations that need access outside the current workspace or that push to GitHub. A request to inspect or compare branches does not authorize a push.
