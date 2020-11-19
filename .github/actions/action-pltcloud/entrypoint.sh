#!/bin/bash -l

pltcloud -t "$API_TOKEN" -f "dist/*demo*" -v "${GITHUB_REF:10}" -p "$PROJECT_UUID"
