#!/bin/sh -l

pltcloud -t "$API_TOKEN" -f "dist/*" -v "$VERSION_TAG" -p "$PROJECT_UUID"
