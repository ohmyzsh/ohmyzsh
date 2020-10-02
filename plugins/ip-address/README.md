# IP Address Plugin

## Requirements
- macos (10.14)+ (works on 11.0)
- curl 7.64.1 (tested)
- jq 1.6 (tested)

## use case.

grab all relevant IP information on your machine.

## Gotcha's

private ip stuff using ifconfig, works on mac, need create `ip a ` stuff for `*nix` systems

## aliases (exmaples)

`ipa`     - Displays all ip address information (public en interfaces and public ip)

```sh
$ ipa
Public IP: 
 → 123.123.123.123 (Dildo, Newfoundland, CA)
Private IP(s): 
 → en0: 10.0.0.121
```

`ippub`   - returns only public ip

```sh
$ ippub
123.123.123.123
```

`allpub`  - returns all public ip address metadata (pair with jq for pretty)

```json
$ allpub
{
  "ip": "123.123.123.123",
  "hostname": "dildo.isp.dingles.net",
  "city": "Dildo",
  "region": "Newfoundland",
  "country": "CA",
  "loc": "47.5706° N, 53.5556° W",
  "org": "Dildo Communications Inc.",
  "postal": "GH2",
  "timezone": "America/Winnipeg"
}
```