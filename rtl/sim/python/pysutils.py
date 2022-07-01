# Utilities

import random

# printing

me = ' pys--. '
quiet = False
getSimTime = None

def msg(text='', lvl=0, name=None, init=None):
   global me, quiet, getSimTime

   if init is not None:
      getSimTime = init
      return

   if quiet and lvl != 0:
      return

   if name is None:
      name = me
   if getSimTime is not None:
      t,c = getSimTime()
   else:
      t,c = (0,0)
   s = f'{t:08d}[{c:08d}] {name:>8}: '
   pad = ' ' * len(s)

   text = text + '\n'
   lines = text.splitlines()
   s = s + lines[0] + '\n'
   for i in range(1, len(lines)):
      s = s + pad
      s = s + lines[i] + '\n'
   print(s[0:-1])

# randoms

def intrandom(n):
  return random.randint(0, n-1)

def hexrandom(w=16):
  n = random.getrandbits(w*4)
  return '{0:0{l}X}'.format(n, l=w)

def binrandom(w=32):
  n = random.getrandbits(w)
  return '{0:0>{l}b}'.format(n, l=w)

def randOK(freq):
  v = random.randint(1,100) # 1 <= v <= 100
  if freq == 0:
    return False
  else:
    return v <= freq

# weights is either
#  a simple list: return weighted index
#  a list of tuple(val, weight): return weighted val
def randweighted(weights):

  if len(weights) == 0:
    return 0

  if type(weights[0]) is tuple:
    vals = []
    tWeights = []
    for i in range (0, len(weights)):
      vals.append(weights[i][0])
      tWeights.append(weights[i][1])
    weights = tWeights
  else:
    vals = range(0, len(weights))

  sum = 0
  for i in range(0, len(weights)):
    sum = sum + weights[i]
  v = random.randint(0,sum-1)
  weight = 0
  for i in range(0, len(weights)):
    weight = weight + weights[i]
    if v < weight:
      break

  return vals[i]

# converters

def b2x(b, w=None):
  if w is None:
    rem = len(b) % 4
    w = len(b)/4
    if rem != 0:
      w = w + 1
  return '{0:0{l}X}'.format(int(b,2), l=w)

def x2b(x, w=None):
  i = int(str(x),16)
  if w is None:
    return bin(i)[2:]
  else:
    return '{0:0>{l}s}'.format(bin(i)[2:], l=w)

def d2x(x, w=None):
  #return hex(int(x)).split('x')[-1].upper()
  if w is None:
    return '{0:X}'.format(x)
  else:
    return '{0:0{l}X}'.format(x, l=w)

def x2d(i):
  return int(i, 16)
