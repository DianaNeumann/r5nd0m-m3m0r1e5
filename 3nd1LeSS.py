def convert(string):
  t = bytearray.fromhex(string)
  t.reverse()
  print(''.join(format(x,'02x') for x in t).upper())

convert(str(sys.argv[1]))

