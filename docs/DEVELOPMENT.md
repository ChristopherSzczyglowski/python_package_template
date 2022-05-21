# Development Guidance
Before starting your development you should configure your local git settings.

## Configuring Git
Following the example in [Rob Allen's blog post](https://akrabat.com/ignoring-revisions-with-git-blame/) provide the `.git-blame-ignore-revs` file to prevent formatting commits from cluttering the file blame history.

Before starting your development you should configure your local git settings to tell git to use this file

```bash
git config blame.ignoreRevsFile .git-blame-ignore-revs
```

## Using the Development Container

To set up your local Docker environment you must first [install Docker](https://docs.docker.com/get-docker/).

Verify that Docker is installed and the Docker Daemon is working

```bash
docker run hello-world
```

Running VS Code inside a container is part of the Remote Development suite in VS Code. It is a powerful and feature-rich capability that enables tools such as SSH, containers and integration with Windows Subsystem for Linux.

Setting up the containerised development environment is a 2 step process:

1. Install the [Remote Development Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
2. Open the command palette using `Cmd+Shift+P` and run the command `Remote-Containers: Reopen in Container`

You are now inside the container described by the `.devcontainer.json` configuration file.

This environment (container) provides all extensions, environment variables and dependencies required to develop this code - no need for `conda`, `poetry` or `venv`!

You can perform `git` commands using the terminal window in VS Code or in a terminal in the original, non-containerised directory.

Further details can be found in these resources:

-   [Developing inside a container - Installation](https://code.visualstudio.com/docs/remote/containers#_installation)
-   [Remote development in containers - Tutorial](https://code.visualstudio.com/docs/remote/containers-tutorial)
-   [Creating a development container](https://code.visualstudio.com/docs/remote/create-dev-container)
