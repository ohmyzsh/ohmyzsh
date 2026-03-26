# pypi plugin

A plugin which contains quick memorable aliases for the commands available while uploading own packages in [pypi](https://pypi.org/)

To access this plugin, add the parameter `pypi` to the plugins array of your zshrc file:
```
plugins=(... pypi)
```

## Aliases

| Alias Command          | Original Command                                                      | Description                                                                            |
|------------------------|-----------------------------------------------------------------------|----------------------------------------------------------------------------------------|
| `pypi-check`           | `pip3 install twine setuptools`                                       | Used to check the required libraries to upload a package in pypi                       |
| `pypi-ltest`           | `python3 setup.py sdist && python3 -m pip install dist/*`             | Used to install setup.py file to local machine for testing before uploading into pypi. |
| `pypi-tupload`         | `python3 setup.py sdist && twine upload --repository testpypi dist/*` | Used to upload a python package to testpypi for testing                                |
| `pypi-upload`          | `python3 setup.py sdist && twine upload dist/*`                       | Used to upload a python package to pypi.                                               |
