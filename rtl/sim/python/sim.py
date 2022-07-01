#!/usr/bin/python3

# pyverilator
# fixed internal sig parsing (cdata/wdata)
# 1. this should be based on init setting AND should be done even w/o trace on!!!
#    in add_to_vcd_trace(self), time is bumped +5
# 2. should count cycs
# 3. add parm so clock can be set but NOT eval (for multiclock, only fastest evals)
# 4. how to access mem[][]??
# 5. not adding vectors to gtk - cuz 0:n?

import os, sys
import datetime
from optparse import OptionParser
from optparse import OptionGroup

import random
from random import randint

from pysutils import *

user = os.environ['USER']
binPath = os.path.dirname(os.path.realpath(__file__))

localPV = True
if localPV:
   import os, sys
   sys.path.append(os.path.join(binPath, 'pyverilator'))
import pyverilator

####################################################################
# Defaults

rtl = ['src']
model = 'sdr'

stopOnFail = True
verbose = False
vcd = False
seed = randint(1, int('8675309', 16))
runCycs = 100

#rangesRd = [(0,63), (0,63), (0,63), (0,63)]
rangesRd = [(0,7), (0,7), (0,7), (0,7)]
#rangesWr = [(0,63), (0,63)]
rangesWr = [(0,7), (0,7)]


####################################################################
# Process command line

usage = "Usage: %prog [options]"
parser = OptionParser(usage)

parser.add_option('-m', '--model', dest='model', help=f'sdr or ddr')
parser.add_option('-s', '--seed', dest='seed', help=f'initialize seed to n')
parser.add_option('-c', '--cycles', dest='runCycs', help=f'cycles to run, default={runCycs}')

parser.add_option('-t', '--trace', dest='trace', action='store_true', help=f'create wave file')
parser.add_option('-f', '--stopfail', dest='stopOnFail', action='store_true', help=f'stop on first fail')

parser.add_option('-v', '--verbose', dest='verbose', action='store_true', help=f'noisy output')

options, args = parser.parse_args()

if options.model is not None:
   model = options.model

if options.seed is not None:
   seed = int(options.seed)

if options.runCycs is not None:
   runCycs = int(options.runCycs)

if options.trace is not None:
   vcd = True

if options.stopOnFail is not None:
   stopOnFail = True

if options.verbose is not None:
   verbose = True

####################################################################
# Init

sdr = False
ddr = False
ddr1x = False

if model == 'sdr':
   top = 'test_ra_sdr.v'
   sdr = True
elif model == 'ddr1x':
   top = 'test_ra_ddr_1x.v'
   ddr = True
   ddr1x = True
else:
   top = 'test_ra_ddr.v'
   ddr = True

errors = 0
cyc = 0
quiesceCyc = 5 # before end

# build model
sim = pyverilator.PyVerilator.build(top, verilog_path=rtl)
print('io')
print(sim.io)
print()

print('internals')
# issue #8 - try local fix
print(sim.internals)
print()

#print('ra')
#print(sim.internals.ra)
# array0,1,2 dont exist as submodules???
#print()
#
#print('ra.add_clk')
#print(sim.internals.ra.add_clk)
#print()

if vcd:
   sim.start_gtkwave(auto_tracing=False)

   #wtf vectors are failing
   #  will make this load a savefile anyway someday
   #  this doesn't actually restrict what's beign recorded anyway; still
   #    can load saved netlist after sim
   #sim.send_to_gtkwave(sim.io)
   #for s in sim.io:
   #   try:
   #        sim.send_to_gtkwave(sim.io[s])
   #   except:
   #        print(f'*** failed {s}')

####################################################################
# Functions, Classes

def getSimTime():
   return (sim.curr_time, cyc)
msg(init=getSimTime)

# sim-driven signals don't look like _q since they are set after the eval(clk=1) tick
# would have to set after eval of rising edge but also not do a simtick
def tick():
   sim.eval()
   if vcd:
      sim.add_to_vcd_trace()

def run(n=1, cb=None):
   global cyc

   if sdr or ddr1x:
      for i in range(n):
         sim.io.clk = 0
         tick()
         sim.io.clk = 1
         tick()
   elif ddr:
      for i in range(n):
         sim.io.clk = 0
         sim.io.clk2x = 1
         tick()
         sim.io.clk2x = 0
         tick()
         sim.io.clk = 1
         sim.io.clk2x = 1
         tick()
         sim.io.clk2x = 0
         tick()

   cyc += 1
   if not vcd: # should be done by pyv!!!!
      sim.curr_time = cyc * 10
   if cb is not None:
      (cb)()

def fail(t=None):
   global errors, stopOnFail
   msg('*** FAIL ***')
   errors += 1
   if t is not None:
      msg(t)

class Memory:

    def __init__(self, locs, bits, init=0):
        self.mem = [init] * locs
        self.bits = bits

    def read(self, adr):
        return self.mem[adr]

    def readall(self):
       mem = []
       for i in range(len(self.mem)):
          mem.append(self.mem[i])
       return mem

    def write(self, adr, dat):
        self.mem[adr] = dat

    def __str__(self):
        t = ''
        for i in range(0,len(self.mem),4):
            t1 = f'[{i:02X}] {self.mem[i]:018X}'
            for j in range(i+1, i+4):
                t1 += f'  [{j:02X}] {self.mem[j]:018X}'
                #t1 += f'  {self.mem[j]:018X}\n'
            t += t1 + '\n'
        return t

class Port:

    def __init__(self, id, type='r'):
        self.id = id
        self.type = type

    def read(self, adr):
        sim.io[f'rd_enb_{self.id}'] = 1
        sim.io[f'rd_adr_{self.id}'] = adr
        msg(f'Port={self.id} RD @{adr:02X}')
    def write(self, adr, dat):
        sim.io[f'wr_enb_{self.id}'] = 1
        sim.io[f'wr_adr_{self.id}'] = adr
        sim.io[f'wr_dat_{self.id}'] = dat
        msg(f'Port={self.id} WR @{adr:02X}={dat:02X}')

    def data(self):
        return int(sim.io[f'rd_dat_{self.id}'])

    def idle(self):
        if self.type == 'r':
            sim.io[f'rd_enb_{self.id}'] = 0
            sim.io[f'rd_adr_{self.id}'] = 0 # random
        else:
            sim.io[f'wr_enb_{self.id}'] = 0
            sim.io[f'wr_adr_{self.id}'] = 0 # random
            sim.io[f'wr_dat_{self.id}'] = 0 # random

def printstate():
   mac = sim.internals.ra
   if sdr:
      msg(f'R0: {mac.rd_enb_0_q:01X} {mac.rd_adr_0_q:02X} {mac.rd_dat_0_q:018X} R1: {mac.rd_enb_1_q:01X} {mac.rd_adr_1_q:02X} {mac.rd_dat_1_q:018X}')
      msg(f'W0: {mac.wr_enb_0_q:01X} {mac.wr_adr_0_q:02X} {mac.wr_dat_0_q:018X}')
   else:
      msg(f'R0: {mac.rd_enb_0_q:01X} {mac.rd_adr_0_q:02X} {mac.rd_dat_0_q:018X} R1: {mac.rd_enb_1_q:01X} {mac.rd_adr_1_q:02X} {mac.rd_dat_1_q:018X} R2: {mac.rd_enb_2_q:01X} {mac.rd_adr_2_q:02X} {mac.rd_dat_2_q:018X} R3: {mac.rd_enb_3_q:01X} {mac.rd_adr_3_q:02X} {mac.rd_dat_3_q:018X}')
      msg(f'W0: {mac.wr_enb_0_q:01X} {mac.wr_adr_0_q:02X} {mac.wr_dat_0_q:018X} W1: {mac.wr_enb_1_q:01X} {mac.wr_adr_1_q:02X} {mac.wr_dat_1_q:018X}')

def printfinal():

   print()
   print()
   print('Final State')
   print(f'Model       : {top}')
   print()
   print(data)
   # should be checking actual mem[][] here, but can't access signals
   print()
   for i in range(len(portsRd)):
      print(f'Reads Port {i}:  {reads[i]}')
   for i in range(len(portsWr)):
      print(f'Writes Port {i}: {writes[i]}')
   print()
   print(f'Seed:          {seed:08X}')
   print(f'Cycles:        {cyc}')
   print(f'Errors:        {errors}')

def check(port, adr, exp=None):

   if exp is None:
      exp = data.read(adr)
   act = portsRd[port].data()
   if act != exp:
      fail(f'* RD MISCOMPARE * port={port} adr={adr:02X} act={act:018X} exp={exp:018X}')
      return False
   elif verbose:
      msg(f'* RD COMPARE * port={port} adr={adr:02X} act={act:018X} exp={exp:018X}')
   return True

####################################################################
# Do something

msg(f'Initializing seed to {hex(seed)}')

random.seed(seed)

data = Memory(64, 72)
if sdr:
   portsRd = [Port(0, 'r'), Port(1, 'r')]
   portsWr = [Port(0, 'w')]
else:
   portsRd = [Port(0, 'r'), Port(1, 'r'), Port(2, 'r'), Port(3, 'r')]
   portsWr = [Port(0, 'w'), Port(1, 'w')]

# Array Cycle Timings
#
# write
# | e/a/d |   acc  | valid |
#         * latched by wrapper (in)
#
#
# read
# |  e/a  |   acc  | valid |
#         * latched by wrapper (in)
#                  * latched by wrapper (out)
#
# rd(a) = wr(a) (both enabled):


# reset
sim.io.reset = 1
run(1)
sim.io.reset = 0

# idle
for p in portsRd:
    p.idle()
for p in portsWr:
    p.idle()

run(10)

# init array
if sdr:
   for a in range(0, 64, 1):
      d0 = int(f'5555555555555555{a:02X}', 16)
      portsWr[0].write(a, d0)
      run(1, printstate)
      data.write(a, d0)  # now visible for reads
      portsWr[0].idle()
else:
   for a in range(0, 64, 2):
      d0 = int(f'5555555555555555{a:02X}', 16)
      portsWr[0].write(a, d0)
      d1 = int(f'5555555555555555{a+1:02X}', 16)
      portsWr[1].write(a+1, d1)
      run(1, printstate)
      data.write(a, d0)  # now visible for reads
      data.write(a+1, d1)  # now visible for reads
      portsWr[0].idle()
      portsWr[1].idle()

# random cmds
# writes: visible to all reads in cycle n+1,...
# reads: check in cycle n+2 vs mem data in cycle n+1
#
# every cycle:
# save data state
# pick weighted read0, read1, read2, read3, write0, write1 (cmd freq, adr) and ensure no adr coll if req'd
# schedule data change (write)
# schedule checks (read)

updates = []
checks = []
reads = [0, 0, 0, 0]
writes = [0, 0]
saveData = None
quiesced = False
quiesceCyc = cyc + runCycs - quiesceCyc

#d = int('1000', 16)
msg('Starting random loop.')
for c in range(runCycs):

   ok = True

   # check reads
   checksNext = []
   for i in range(len(checks)):
      rd = checks[i]
      if cyc == rd[0]:
         ok = ok and check(rd[1], rd[2], saveData[rd[2]])
      else:
         checksNext.append(rd)
   checks = checksNext

   # do writes
   updatesNext = [] # always only 1 cycle
   for i in range(len(updates)):
      wr = updates[i]
      if cyc == wr[0]:
         data.write(wr[2], wr[3])
      else:
         print('HUH? should always be this cycle!', cyc, updates)
         quit()
   updates = updatesNext

   # save current data
   saveData = data.readall()

   # quiesce?
   if cyc >= quiesceCyc:
      if not quiesced:
         msg('Quiescing...')
         quiesced = True

   # write coll will give w1 precedence - or make it avoid
   aw = [None] * 2
   for i in range(len(portsWr)):
      portsWr[i].idle()
      aw[i] = -1
      if not quiesced and randint(1, 10) < 5:
         r = rangesWr[i]
         aw[i] = randint(r[0], r[1])
         d = int(hexrandom(18), 16)
         portsWr[i].write(aw[i], d)
         updates.append((cyc+1, i, aw[i], d))
         writes[i] += 1

   for i in range(len(portsRd)):
      portsRd[i].idle()
      if not quiesced and randint(1, 10) < 5:
         r = rangesRd[i]
         ar = randint(r[0], r[1])
         while ar == aw[0] or ar == aw[1]:
            ar = randint(r[0], r[1])
         portsRd[i].read(ar)
         checks.append((cyc+2, i, ar))
         reads[i] += 1

   run(1, printstate)
   if not ok and stopOnFail:
      break

####################################################################
# Clean up

printfinal()

if ok and errors == 0:
      print()
      print('You has opulence.')
      print()
else:
      print()
      print('You are worthless and weak!')
      print()

print('Done.')
