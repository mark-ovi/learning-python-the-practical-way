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

- **VS Code (recommended):** Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers), open the repository, then select **Reopen in Container**.

- **Or set up locally** from the repository root:

  - Linux/macOS:
    ```bash
    ./scripts/setup.sh
    source .venv/bin/activate
    ```

  - Windows PowerShell:
    ```powershell
    .\scripts\setup.ps1
    .venv\Scripts\Activate.ps1
    ```

The setup scripts require Python 3.14 and install the repository dependencies into `.venv`. For a manual setup, follow the Python installation and virtual-environment instructions in the book's Introduction & Setup chapter.

- Dev server default port: 8000
## Licensing

- **Book text and instructional prose:** [CC BY-NC-SA 4.0](LICENSE.md).
- **Code samples and project code:** MIT (see [LICENSE-CODE.md](LICENSE-CODE.md) and [CODE-LICENSE-POLICY.md](CODE-LICENSE-POLICY.md)).
