alias pm='python manage.py'
alias pmr='python manage.py runserver'
alias pmrp='python manage.py runserver_plus'
alias pmrpg='pmrp --adminmedia=`pwd`/static/admin'
alias pmsdb='python manage.py syncdb'
alias pms='python manage.py shell'
alias pmsp='python manage.py shell_plus'
alias pmlf='python manage.py loaddata fixtures/*'
alias pmt='python -W ignore::DeprecationWarning manage.py test'

alias pmdm='python manage.py datamigration'
alias pmsm='python manage.py schemamigration --auto'
alias pmsi='python manage.py schemamigration --initial'
alias pmm='python manage.py migrate'
alias pmma='python manage.py migrate --all'
alias pmml='python manage.py migrate --list'
alias pmmf='python manage.py migrate --fake'
alias pmcats='python manage.py convert_to_south'

alias gs='gunicorn_django'
alias gk='kill `cat .gunicorn.pid`'
alias gl='tail -f .gunicorn.log'

function djapp() {
    mkdir -p $1/templates/$1
    touch $1/__init__.py
    echo "from django.db import models\n\n" > $1/models.py
    echo "from django.contrib import admin\nfrom $1.models import *\n\n" > $1/admin.py
    echo "from django.conf.urls.defaults import *\n\n" > $1/urls.py
}
