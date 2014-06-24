c() { cd /var/www/$1;  }

_c() { _files -W /var/www -/; }
compdef _c c

creport() { cd /var/www/yoolk_report;  }
cportal() { cd /var/www/yoolk_portal;  }
ccore() { cd /var/www/yoolk_report/yoolk_core;  }
sql() { mysql -uroot -p; }