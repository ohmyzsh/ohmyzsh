alias pypi-check='python3 -m pip install twine setuptools'
alias pypi-ltest='python3 setup.py sdist && python3 -m pip install dist/*'
alias pypi-tupload='python3 setup.py sdist && twine upload --repository testpypi dist/*'
alias pypi-upload='python3 setup.py sdist && twine upload dist/*'


