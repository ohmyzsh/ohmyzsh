# iwhois

Provides a whois command with a more accurate and up-to-date list of whois servers
using CNAMES, via [whois.geek.nz](https://github.com/iwantmyname/whois.geek.nz).

To use it, add iwhois to the plugins array of your zshrc file:
```
plugins=(... iwhois)
```

### Usage

The plugin defines the function `iwhois` that takes a domain name as an argument:

```
$ iwhois github.com
   Domain Name: GITHUB.COM
   Registry Domain ID: 1264983250_DOMAIN_COM-VRSN
   Registrar WHOIS Server: whois.markmonitor.com
   Registrar URL: http://www.markmonitor.com
   Updated Date: 2017-06-26T16:02:39Z
   Creation Date: 2007-10-09T18:20:50Z
   ...
```
