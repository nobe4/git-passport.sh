#!/bin/sh

# Variables
# Required paths
# Global
#  ~
#  |-.gitconfig
#  |-.git
# Project <- place of execution
# |-.git
#   |-hooks
#   | |-hook.sh
#   |-config

# custom home used for development
# HOME="home"
globalGitDir="$HOME/.git"
globalGitConfig="$HOME/.gitconfig"
globalTemplateDir="$globalGitDir/templates"
localDir="$(pwd)"
localGitConfig=".git/config"

# if the template folder doesn't exist, create it

# Variable that contains the found template
selectedTemplate=""

# Prepare the usage message
read -d '' usageMessage << EOF
Git Passport, bash-only version
  Usage :
    ./git-passport [-hlr] [FILE]

  Help :
    ./git-passport -h
EOF

# Prepare the help message
read -d '' helpMessage << EOF
$usageMessage

  Examples :
    ./git-passport a
      => Use a.template as new configuration

    ./git-passport -l
      => a.template
      => b.template

    ./git-passport -r
      => Restore default configuration

  Flags :
    -h Print this help message
    -l List available templates configuration
    -r Reset configuration to default
EOF

# Functions
# Get the user informations for display
function GetConfigUser {
fieldRegex="(.*) = (.*)"

# parse the template
while read -r line
do
  if [[ $line =~ $fieldRegex ]]; then
    case ${BASH_REMATCH[1]} in
      "name") name="${BASH_REMATCH[2]}"
        ;;
      "email") email="${BASH_REMATCH[2]}"
        ;;
      *) echo "$line"
    esac
  fi
done < "$1"

# check for errors
if [ -z "$name" ]; then
  echo "Bad configuration file, did not found the name for file $1, abort... "
  exit 1
elif [ -z "$email" ]; then
  echo "Bad configuration file, did not found the email for file $1, abort..."
  exit 1
else
  # display the informations
  echo "$name : $email"
fi
}

# List existing templates in the global git directory
function ListExistingTemplate {
for file in "$globalTemplateDir"/*
do
  # echo "$file"
  echo "$(GetConfigUser $file) in file $file"
done
}

# Select the template to be used
function SearchTemplate {
found=0
cd "$globalTemplateDir"
for file in *
do
  if [[ "$file" =~ ^$1 ]]; then
    echo "Found file $file"
    selectedTemplate="$globalTemplateDir/$file"
  fi
done
cd "$localDir"
if [ "$selectedTemplate" == "" ]; then
  echo "No file found matching '$1' in $globalGitDir"
fi
}

# Apply the selected configuration
# simply copy the template at the end of the config file
function ApplyConfiguration {
cat "$1" >> "$localGitConfig"
}

# Entry Point
# Parse the standart input
# http://stackoverflow.com/a/14203146/2558252
# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.

if [ $# == 0 ]; then
  echo "$usageMessage"
  exit 0
fi

while getopts "hlr" opt; do
 case "$opt" in
    h) echo "$helpMessage"
      ;;
    l) ListExistingTemplate
      ;;
    r) echo "TODO : should reset the configuration"
      ;;
  esac
done


shift $((OPTIND-1))
[ "$1" = "--" ] && shift

# get trailing parameters as the possible filename
if [[ "$@" ]]; then
  templateFile=$@
fi

if [[ "$templateFile" ]]; then
  SearchTemplate "$templateFile"
  if [ "$selectedTemplate" != "" ]; then
    ApplyConfiguration "$selectedTemplate"
  fi
fi
