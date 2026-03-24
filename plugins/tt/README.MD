# TT 

This plugin provides mutual conversion of timestamp and date. 

To use it add tt to the plugins array in your zshrc file.

```bash
plugins=(... tt)
```
# Example

print timestamp for "2019-10-16"
```bash
tt 2019-10-16
```

print timestamp for "2019-10-16 18:41:00"
```bash
tt "2019-10-16 18:41:00"
```

print date for "1571222561"
```bash
tt 1571222561
```
echo 2019-10-16 18:42:41
