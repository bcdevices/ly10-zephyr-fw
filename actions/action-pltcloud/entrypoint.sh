#!/bin/sh -l

sh -c "/usr/local/bin/pltcloud -t $API_TOKEN -f \"dist/*\" -v $GITHUB_REF -p $PROJECT_UUID"
