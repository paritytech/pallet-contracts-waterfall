#!/bin/bash

# Update ink
git submodule update --remote --merge

# Update yarn deps
yarn upgrade
