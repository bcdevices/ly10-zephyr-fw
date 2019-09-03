#!/bin/sh -l

pltcloud -t "$API_TOKEN" -f "dist/*" -v "$GITHUB_REF" -p "$PROJECT_UUID"
