# Learning Python the Practical Way: Web Scraping, Automation & APIs

A free, open-source Python fundamentals book. This repository hosts the public build and site content for the free edition.

## Quick links

- Live site: <https://learning-python-the-practical-way.netlify.app/>    # replace with actual URL once domain is bought
- Content source (canonical): content/
- Build config: site-config/mkdocs.yml
- Issues & contributions: see CONTRIBUTING.md

## What this repo contains

- content/            — public copy of the free book content (markdown, assets, examples)
- site-config/        — mkdocs config and Netlify config used to build the site
- examples/           — runnable example projects (public)
- .github/            — workflows and templates (public CI, sync target)
- build/              — (ignored) output used during CI/deploy

## Getting started

- VS Code (recommended): Install Remote - Containers, open repository, then "Reopen in Container".
- Or run locally:
  - Linux/macOS:
    - ./scripts/setup.sh
    - .venv/bin/activate:
  - Windows PowerShell:
    - ./scripts/setup.ps1
    - .venv\Scripts\Activate.ps1
- Dev server default port: 8000
