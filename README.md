# git-passport.sh
Git passport, managin multiple git identities, right from the command line.

# Usage
You can use this script as-is or define an alias in your git configuration to suits your needs.

E.g. 

```
in your ~/.gitconfig

[alias]
  passport = !path/to/the/git-passport.sh

and then

$ git passport
```


# Inspiration
As I have multiple git identities, I wanted a simple way to configure it simply.
This projet has already been done in [frace's repo](https://github.com/frace/git-passport).

I wanted a simpler version and fully in bash, for the exercise mainly.

# Compatibility
For now this has only been tried on a OS X Yosemity, with a zsh shell.
If you had tested it on your machine and it worked you can let me know with an issue/PR.

# Contributing
Issues and PR are welcome !

# License 
MIT, see the [License](https://github.com/nobe4/git-passport.sh/blob/master/LICENSE).
