#!/bin/bash -l
# SPDX-License-Identifier: Apache-2.0

pltcloud -t "$API_TOKEN" -f "dist/*demo*" -v "${GITHUB_REF:10}" \
	-p "$PROJECT_UUID"
