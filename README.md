git-rails-database-branch-hook
==============================

Save and restore the state of your Rails development and test databases as you work on different branches.

This allows you to make some changes to the structure of your database on a feature branch, then be able to quickly switch back to your master branch to make a hotfix or start a new feature branch with your original database structure and content.

# Installation

Download the `post-checkout` file into the `.git/hooks` directory of your project. Be sure to keep the `post-checkout` name to match Git's expectations.

Alternatively, you can clone this repository to your computer then symlink the `post-checkout` file into the `.git/hooks` directory of each of your projects. This allows you to manage the file in one place and be able to easily pull down updates.

# Support

Only PostgreSQL databases are currently supported.
