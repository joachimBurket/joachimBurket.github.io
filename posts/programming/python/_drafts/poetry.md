---
title: Managing dependencies with Poetry
tags: programming python
---

[Poetry](https://python-poetry.org/docs/) is a tool for dependency management and packaging in Python.

<!--more-->

Packaging and dependencies management is not always fun in Python. I am normally using [pip](https://pypi.org/project/pip/) to install package, and its `requirements.txt` to manage my projects dependencies.
Combined with virtualenv, this is working pretty well, even if it's not perfect. For instance, the fact that the `requirements.txt` lists all installed packages (packages needed by the project and their dependencies) can quickly become hard to maintain. That coupled to the fact that `pip uninstall <package>` doesn't checks for dangling dependencies, you could end up with unused packages without knowing.

But now I need to publish a package to a pypi repository, and I don't really like how it seems to be done.


Some Poetry useful commmands: 

* Init `pyproject.toml` file:
    ```bash
    $ poetry init
    ```
* Manage project dependencies:
    ```bash
    # install project dependencies (from pyproject.toml) in its venv
    $ poetry install

    # update all project dependencies. When specifying dependency like `requests = "^2.25.1"`,
    #  the package installed will be ">=2.25.1,<3.0.0"
    $ poetry update

    # add a package to pyproject.toml and install it
    $ poetry add requests@^2.25.1

    # remove a package
    $ poetry remove requests

    # show the list of installed packages
    $ poetry show
    ```

* Publish a package to a local repository:
    ```bash
    # configure local repository to publish to artifactory.
    $ poetry config repositories.artifactory https://artifactory-url.com/api/pypi/pypi-local

    # save credentials for the "artifactory" repository (artifactory)
    $ poetry config http-basic.artifactory <username> <password>

    # build and publish the package to a repository (the on configured in ~/.config/pypoetry/config.toml)
    $ poetry publish -r <repository> --build
    ```
    
