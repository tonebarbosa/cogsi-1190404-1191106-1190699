### CS 01 

To create the repository, first cloned the remote repository with **git clone**. 
Then, removed the .git folder and added to the repository. 
To finalize, made **git commit -a -m"#1 Set repository and add gitignore"** and then **git push**.

To add the feature, I've made the code and then **git commit -a -m"#2 Add employee JobYears"** and **git push**.

Created a commit, pushed it and then to revert to another commit, made git log, picked the hash of the commit I wanted and git reset --hard COMMIT_HASH. Then, **git push -f**.

Finally created a tag and added it to the last commit by checking the SHA value using **git log --oneline** 

**git tag -a ca1-part1 e68b818 -m "CA1 part1 end"**

