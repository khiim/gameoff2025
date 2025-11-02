# Game Off 2025

This is the source code for our game for the [Game Off 2025](https://itch.io/jam/game-off-2025) game jam.

# Getting started

## Tools

### [Godot](https://godotengine.org/)

Download the [Godot 4.5.1](https://godotengine.org/) game engine for your system, and hack away.

### [GDScript Toolkit](https://github.com/Scony/godot-gdscript-toolkit)

We use [GDScript Toolkit](https://github.com/Scony/godot-gdscript-toolkit) to help with consistent code style, and increase the quality.

### [Pre-commit](https://pre-commit.com/)

The pre-commit hook runs the GDSCript Toolkit, and ensures a clean git history.

## Local development

How to install:

1. Make sure you have python and pip installed.
2. run `pip install -r requirements.txt`
    - If you for some reason have issues running this command a solution could be to run `python3 -m pip install -r requirements.txt`
    - This installs pre-commit and gdscript toolkit
3. Run `pre-commit install` in the root of the project.

Now every time you run git commit the GdScript Toolkit linter is executed, and you must resolve any linting issues before a commit is accepted.

You can also run `gdlint .` and `gdformat .` from the command line if you want to run the tools before committing.

### For the more terminal savvy devs

If you primarily use git through the terminal you should set up a venv for the python environment.

```bash
py -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Or on Windows command line:

```cmd
py -m venv .venv
.venv\Scripts\activate.bat
pip install -r requirements.txt
```
