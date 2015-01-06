base-convert
============

 * convert between hex and dec(signed).


## Installation
```bash
$ npm install base-convert
```

## Features
 * dec2hex
 * hex2dec

## Useage

```bash
> var bc = require('base-convert');
> bc.hex2dec('ff');
'255'
> bc.dec2hex(65535);
'FFFF'
```
