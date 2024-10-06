### CS 01

#### Part1
To create the repository, first cloned the remote repository with **git clone**.
Then, removed the .git folder and added to the repository.
To finalize, made **git commit -a -m"#1 Set repository and add gitignore"** and then **git push**.

To add the feature, I've made the code and then **git commit -a -m"#2 Add employee JobYears"** and **git push**.

Created a commit, pushed it and then to revert to another commit, made git log, picked the hash of the commit I wanted and git reset --hard COMMIT_HASH. Then, **git push -f**.

Finally created a tag and added it to the last commit by checking the SHA value using **git log --oneline**

**git tag -a ca1-part1 SHA_value -m "CA1 part1 end"**

#### Part2
For starter for the email-field feature branch creation the follwing command was used:

**git checkout -b feature/email-field**

This creates and checks out the new branch. Then code for this feature was developed, commited and pushed using

**git commit -a -m "#6 Email field added"**

**git push origin feature/email-field**

Then checked out main and merged the new feature, and then tagged the commit with v1.3.0 (mistake was made and the tagged was the merge commit)

**git checkout main**

**git merge feature/email-field**

**git tag v1.3.0 SHA_value**

After this for the email-field verification a new branch was created with the command(an error was made in the naming of the branch):

**git checkout -b feature/email-field-verification**

This creates and checks out the new branch. Then code for this feature was developed, commited and pushed using

**git commit -a -m "#7 Email field verificationunit test"**

**git push origin feature/email-field-verification**

Then checked out main and merged the new feature, and then tagged the commit with v1.3.1

**git checkout main**

**git merge feature/email-field-verification**

**git tag v1.3.1 SHA_value**

**git push --tags**

#### Alternative Solution

**Mercurial**

Just like Git, Mercurial is a distributed system, wich means each developer has a full copy of the project’s history. You can work offline, make commits, and view the entire version history without needing to connect to a central server. Changes are later synchronized (pushed/pulled) between repositories.
To simualte the work the was previously done in git, for Mercurial we would need this commands:

hg branch - wich is used to create a branch (unlike Git's git checkout -b).
hg update - wich is used to switch between branches and commits (similar to git checkout).
hg commit - wicht does not require the -a flag to commit all changes.
hg push - wich is the equivalent of git push, and --new-branch is used to push a new branch to the remote.
hg tag - wich works similarly to Git tags.
