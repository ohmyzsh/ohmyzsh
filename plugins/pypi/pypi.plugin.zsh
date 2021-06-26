alias pypi-check='pip3 install twine setuptools'
alias pypi-tupload='python3 setup.py sdist && twine upload --repository testpypi dist/*'
alias pypi-upload='python3 setup.py sdist && twine upload dist/*'


