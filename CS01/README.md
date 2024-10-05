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


