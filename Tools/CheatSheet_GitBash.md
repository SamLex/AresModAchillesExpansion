# Git Bash Cheat Sheet

## Get all commits that affected the file

```bash
git log --follow <file>
```

## Compare file between different branches

```bash
git diff <previous branch> <current branch> -- <file>
```

## Show all changes that have been staged for the next commit

```bash
git diff --cached
```

## Track a file change

```bash
git add <files> 
```

## Untrack a file change

```bash
git reset <files>
```

## Commit tracked file changes

```bash
git commit -m "<message>"
git push
```

## Discard all untracked changes

```bash
git checkout -- .
```

## Fork a new branch B from branch A

```bash
git checkout -b <branch B> <branch A>
git push --set-upstream origin <branch B>`
```

## Switch branch

```bash
git checkout <branch>
git pull`
```

## Delete branch A

```bash
git push -d origin <branch A>
git branch -d <branch A>
```

## Deletes all stale remote-tracking branches


```bash
git remote prune origin
```

## Apply commit x on branch A

```bash
git checkout <branch A>
git cherry-pick <id of commit x>
```
