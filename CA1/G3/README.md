CA1 focus on Version Control tools. This document resumes the tasks performed by the team.

# Overview

- Objective: Perform version control operations on the application.
- Tech Stack: Git (Main tool), Mercurial (Alternative Tool)

# Main Tool - Week 1

#### 1. **Setting Up the Project**

- Use the project that is in the 'CA0' folder
- Create a folder named 'CA1' and inside create another folder named 'git'
- Copy the project to the last created folder
- Commit the changes to the repository

```bash
git add .
git commit -m 'feat: add project to CA1'
```

- Push the changes to the repository

```bash
git push
```

#### 2. **Creating Tags**

- Let's use a 'major.minor.revision' pattern to mark the versions of the application

```bash
git tag 1.1.0
```

- After creating the tag, push it to the server

```bash
git push origin 1.1.0
```

#### 3. **Developing a new Feature**

- Add a new field to record the years of the employee in the company (e.g., jobYears)
- Add support for the new field
- Add unit tests for testing the creation of employees and the validation of their attributes (for instance, no null/empty values)
- After the development and testing all the changes, commit and push with a new tag (that must be created - 1.2.0). Here we decided to make multiple commits to separate what were new features and tests.

```bash
# Code Development
git add .
git commit -m 'feat: add jobYears field to Employee'

# Added tests
git add .
git commit -m 'test: add jobYears test validations'

git push

git tag 1.2.0
git push origin 1.2.0
```

#### 4. **Reviewing the commit history**

- To review all commits

```bash
git log
```

- There are another options to improve the logs format and even choose what you might want to see

```bash
git log --pretty=oneline
git log --pretty=short
git log --graph
```

- Feel free to explore another options on [Git Documentation - Pretty Formats](https://git-scm.com/docs/pretty-formats)

#### 5. **Reverting changes**

- To revert the changes of a specific commit (e.g. the commit that is tagged with '1.2.0').

```bash
git revert 1.2.0
```

- This will create a commit reverting the changes. The default editor will open to input the commit message.
- To revert without editing the commit message, you can use the `--no-edit` flag

```bash
# HEAD always references the latest commit
git revert --no-edit HEAD
```

- To revert the changes without commiting the changes, which might be helpful to decide what you want to revert, you can use the `--no-commit` flag

```bash
git revert --no-commit HEAD
```

- The reverted files will be staged. You may now commit manually whenever you want to complete the revert operation.
- While in this state, to abort your revert, you can use the `--abort` flag

```bash
git revert --abort
```

#### 6. **Finishing the Tasks of Week 1**

- To end the first week tasks, mark your commit with the tag named 'ca1-part1'

```bash
git tag ca1-part1
git push origin ca1-part1
```

# Main Tool - Week 2

#### 1. **Creating a branch**

- Create a branch
  
```bash
git branch email-field
```

- Switch to the newly created branch

```bash
git checkout email-field
```

- In order to create a branch and switch to it at the same time

```bash
git checkout -b my-branch
```

#### 2. **Developing a new Feature**

- Add support for an email field for an employee
- When the new feature is completed the code should be committed

```bash
git commit -am "feat: add email field to Employee"
```

- To push the changes on a branch that is not available remotely
  
```bash
git push --set-upstream origin email-field
```

- Afterwards, the feature branch should be merged into the main branch
- In order to safely merge into the main branch we need to make sure that our local main branch is up to date

```bash
# Switch to main branch
git checkout main

# Synchronize with the remote branch
git pull origin main

# Merge the feature branch
git merge email-field
```

- Additionally it is a good practice to test if everything is working as it should before pushing the merge

```bash
git push origin main
```

- After the merge, a new tag (1.3.0) should be created

```bash
git tag 1.3.0
git push origin 1.3.0
```

#### 3. **Fixing a bug**

- The workflow to create a fix is the same as for the creation of a feature

```bash
# Create branch and switch to it
git branch fixing-invalid-email
git checkout fixing-invalid-email

# Commit changes applied
git commit -am "fix: add validation for email field of Employee"

# Switch to main branch and synchronyze with remote one
git checkout main
git pull origin main

# Merge the fix branch
git merge fixing-invalid-email

# Test everything and push the merge
git push origin main

# Create new tag
git tag 1.3.1
git push origin 1.3.1
```

- Additionally it is a good practice to delete the feature or fix branch after the merge

```bash
git branch -d fixing-invalid-email
```

-d deletes the branch only if it has been fully merged into the current branch or any other branch. Git will refuse to delete the branch if it contains unmerged work to avoid data loss.

#### 4. **Finishing the Tasks of Week 2**

- To end the second week tasks, mark your commit with the tag named 'ca1-part2'

```bash
git tag ca1-part2
git push origin ca1-part2
```


# Alternative tool - Analysis and Comparison

Mercurial is a distributed version control system (DVCS) designed to efficiently handle projects of any size. Like other version control systems, it helps manage changes to a codebase, allowing multiple developers to collaborate and maintain a historical record of changes. It was initially developed in 2005 by Matt Mackall as a response to the complexities of centralized version control systems. 

While Git has become the dominant player in the DVCS landscape, Mercurial is still widely used in specific contexts. Some companies and open-source projects, like Mozilla (Firefox development), have historically preferred Mercurial due to its simpler user interface and efficiency with large codebases.

Git's popularity is largely due to its association with GitHub, a major platform for hosting open-source projects. Git has become the default in many tools, DevOps workflows, and cloud services, leading to a vast ecosystem of support, integrations, and customization options. Mercurial, while still in use for some legacy projects and simpler workflows, has seen diminishing adoption. Some platforms that initially supported Mercurial, like Bitbucket, have since dropped support in favor of Git.

Ultimately, Git is ideal for teams needing flexibility and scalability, while Mercurial offers a simpler, more accessible option for smaller teams or legacy environments. However, Git's extensive tooling, performance, and community support make it the more widely adopted choice today.

The commands are also very similar. In most of the cases, Git always starts with `git ...` and Mercurial starts with `hg ...` (e.g. `git commit` translates to `hg commit` ).

## Some Differences

Git is generally more complex, and requires more knowledge to be used safelly and correctly. It's very common to choose a GUI for Git operations, as to avoid unexpected behaviour from command-line inputs. Mercurial is considered to be simpler, and it's documentation easier to understand.

The commit history of a repository can be easily altered in Git, while Mercurial only allows the last commit to be ammended. However, that is not to say one is safer than the other, as there are safeguards that prevent users to destroy the work of their teammates (for example, permissions that deny `--force` push). Overall, git requires more responsability, while Mercurial is safer for less experienced developers.

Branches in Git are only references to certain commits, which makes them very lightweight, flexible and powerfull. Mercurial handles branching differently. Each commit embeds it's branch, where they are stored forever, This makes it so that branches cannot be removed, as they would alter the history. Moreover, you may have problems if you commit to the wrong branch.

Git has a staging area, so that users can easily choose which changes to commit at any given time. Mercurial does not support this natively. Plugins such as DirState or Mercurial Queues must be installed to allow it.

|              | Git                                                                              | Mercurial                     |
|--------------|----------------------------------------------------------------------------------|-------------------------------|
| Usability    | Complex                                                                          | Simpler                       |
| Security     | Can rewrite history. Requires responsability and possibly permission management  | Cannot rewrite commit history |
| Branches     | Lightweight, flexible and powerfull                                              | Cumbersome and inflexible     |
| Staging area | Supports natively                                                                | Supported by plugins          |

# Alternative Tool - Week 1

#### 1. **Setting Up the Project**

- Use the project that is in the 'CA0' folder
- Create a folder named 'CA1' and inside create another folder named 'mercurial'
- Copy the project to the last created folder
- Commit the changes to the repository

```bash
hg add
hg commit -m 'feat: add project to CA1'
```

- Push the changes to the repository

```bash
hg push
```

#### 2. **Creating Tags**

- Let's use a 'major.minor.revision' pattern to mark the versions of the application

```bash
hg tag 1.1.0
```

- After creating the tag, push it to the server

```bash
hg push
```

#### 3. **Developing a new Feature**

- Add a new field to record the years of the employee in the company (e.g., jobYears)
- Add support for the new field
- Add unit tests for testing the creation of employees and the validation of their attributes (for instance, no null/empty values)
- After the development and testing all the changes, commit and push with a new tag (that must be created - 1.2.0). Here we decided to make multiple commits to separate what were new features and tests.

```bash
# Code Development
hg add
hg commit -m 'feat: add jobYears field to Employee'

# Added tests
hg add
hg commit -m 'test: add jobYears test validations'

hg push

hg tag 1.2.0
hg push
```

#### 4. **Reviewing the commit history**

- To review all commits

```bash
hg log
```

- There are another options to improve the logs format and even choose what you might want to see

```bash
# Similar to git log --oneline
hg log --template "{rev}: {desc|firstline}\n"

# To limit the number of logs (e.g., last 5 commits)
hg log -l 5

# To filter by a specific user (author)
hg log -u username
```

#### 5. **Reverting changes**

- To revert the changes of a specific commit (e.g. the commit that is tagged with '1.2.0').
- If you want to back out (revert) the changes introduced by the tag `1.2.0` or a specific changeset, you can use the `hg backout` command with the changeset revision ID

```bash
hg backout -r revision-id
```

- If you want to backout the changeset associated with the tag `1.2.0`, you first need to find the changeset associated with the tag using the command below. This will give you the changeset number or revision ID corresponding to the tag.

```bash
hg log -r 1.2.0
```

- To cancel or revert a backout before committing the revert, if you haven't committed the `hg backout` yet, you can simply discard the changes made by the backout.

```bash
# Option 1: Discard all uncommitted changes (`hg revert`)

hg revert --all

# Option 2: Discard local changes and update to the last committed state (hg update)

hg update --clean
```

- If you've already committed the revert (hg backout + hg commit) but want to undo it, you have the following options

```bash
# Option 1: Backout the backout

hg backout -r <revision-id-of-backout>

# Option 2: Strip the commit (permanently remove the commit)

hg strip <revision-id-of-backout>
# Note: This requires the MQ (Mercurial Queues) extension or the hg evolve extension to be enabled. Be cautious as this permanently removes the changeset.
```

- If the hg backout operation created conflicts and you haven't resolved them yet, you can cancel the process

```bash
hg resolve --abort
```

#### 6. **Finishing the Tasks of Week 1**

- To end the first week tasks, mark your commit with the tag named 'ca1-part1'

```bash
hg tag ca1-part1
hg push
```

# Alternative Tool - Week 2

#### 1. **Creating a branch**

- Create a branch
- Mercurial automatically switches to the newly created branch

```bash
hg branch email-field
```

#### 2. **Developing a new Feature**

- Add support for an email field for an employee
- When the new feature is completed the code should be committed

```bash
hg add
hg commit -m 'feat: add email field to Employee'
hg push
```

- Afterwards, the feature branch should be merged into the default branch
- A new commit must be made to confirm the merge

```bash
hg update default
hg merge email-field
hg commit -m "merge: email-field into default"
hg push
```

- After the merge, a new tag (1.3.0) should be created

```bash
hg tag 1.3.0
hg push
```

#### 3. **Fixing a bug**

- The workflow to create a fix is the same as for the creation of a feature

```bash
# Create a branch
hg branch fixing-invalid-email

# Apply the fix
hg add
hg commit -m "fix: fix email validation"
hg push

# Merge with default branch
hg update default
hg merge email-field
hg commit -m "merge: fixing-invalid-email into default"
hg push

# Create a tag
hg tag 1.3.1
hg push
```

- Mercurial branches cannot be deleted (although they may be hidden), so the branch will stay as part of the repository history forever

#### 4. **Finishing the Tasks of Week 2**

- To end the second week tasks, mark your commit with the tag named 'ca1-part2'

```bash
hg tag ca1-part2
hg push
```
