e = require 'expect.js'
bc = require('bindings')('addon.node')

hex = [
  '8000000000000000',
  '7FFFFFFFFFFFFFFF',
  '1234567890ABCDEF',
  'FEDCBA9876543210',
  'FFFFFFFF',
  '7FFFFFFF',
  '0',
]

dec = [

 '-9223372036854775808',
 '9223372036854775807',
 '1311768467294899695',
 '-81985529216486896',
 '4294967295',
 '2147483647',
 '0',

]

describe 'hex2dec', ->
  it 'should return all currect dec results', (done) ->
    for v,i in hex
      e(bc.hex2dec(v)).to.be dec[i]
    done()

describe 'dec2hex', ->
  it 'should return all currect hex results', (done) ->
    for v,i in dec
      e(bc.dec2hex(v)).to.be hex[i]
    done()
