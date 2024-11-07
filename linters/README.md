# Python Linter and Pre-Commit Hook Setup

This project uses **Flake8** to pre-commit hook to automatically run Flake8 before every commit.

## Setup Instructions

### 1. Open and activate your venv
```
python3 -m venv nameofvenv
source path/to/venv/activator
```
### 2. Install Required Tools
Second, ensure you have `pre-commit` and `flake8` installed in your virtual environment and required hooks:

```bash
pip install pre-commit flake8 commitizen
```
### 3. Install the Pre-Commit Hook

Run the following command in your project directory to activate the hooks specified in the .pre-commit-config.yaml file:

```bash
pre-commit install
```
### 4. Test the Hooks

Now, when you add and commit files, pre-commit will automatically check your code. For example make a python code with errors like unused imports and spaces and try to commit:

![img](screanshots/Screenshot%20from%202024-11-06%2023-41-42.png)
we can see here that hooks are catching this
![img](screanshots/Screenshot%20from%202024-11-06%2023-42-34.png)
delete unused imports and commit but make bad commit message
![img](screanshots/Screenshot%20from%202024-11-06%2023-39-31.png)
![img](screanshots/Screenshot%20from%202024-11-06%2023-39-23.png)
make perfect commit message
![img](screanshots/Screenshot%20from%202024-11-07%2000-22-08.png)
