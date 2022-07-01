# toysram sdr tb
# converted from pyverilator version
#
# variations:
#  sdr: 1x
#  ddr: 1x
#  ddr: 2x

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.handle import Force
from cocotb.handle import Release

import itertools
from dotmap import DotMap
from random import getrandbits
from random import randint

from OPEnv import *

def hexrandom(w=16):
  n = getrandbits(w*4)
  return '{0:0{l}X}'.format(n, l=w)

# Classes ----------------------------------------------------------------------------------------

class Memory:

    def __init__(self, rows, bits, init=0):
        self.mem = [init] * rows
        self.rows = rows
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
        for i in range(self.rows, 4):
            t1 = f'[{i:02X}] {self.mem[i]:0{bits/4}X}'
            for j in range(i+1, i+4):
                t1 += f'  [{j:02X}] {self.mem[j]:0{bits/4}X}'
            t += t1 + '\n'
        return t

class Port:

   def __init__(self, sim, id, type='r', nibbles=18):
      self.sim = sim
      self.dut = sim.dut
      self.id = id
      self.type = type
      self.nibbles = nibbles

   def read(self, adr):
      if self.id == 0:
         self.dut.rd_enb_0.value = 1
         self.dut.rd_adr_0.value = adr
      elif self.id == 1:
         self.dut.rd_enb_1.value = 1
         self.dut.rd_adr_1.value = adr
      elif self.id == 2:
         self.dut.rd_enb_2.value = 1
         self.dut.rd_adr_2.value = adr
      elif self.id == 3:
         self.dut.rd_enb_3.value = 1
         self.dut.rd_adr_3.value = adr

      self.sim.msg(f'Port={self.id} RD @{adr:02X}')

   def write(self, adr, dat):
      if self.id == 0:
         self.dut.wr_enb_0.value = 1
         self.dut.wr_adr_0.value = adr
         self.dut.wr_dat_0.value = dat
      elif self.id == 1:
         self.dut.wr_enb_1.value = 1
         self.dut.wr_adr_1.value = adr
         self.dut.wr_dat_1.value = dat
      elif self.id == 2:
         self.dut.wr_enb_2.value = 1
         self.dut.wr_adr_2.value = adr
         self.dut.wr_dat_2.value = dat
      elif self.id == 3:
         self.dut.wr_enb_3.value = 1
         self.dut.wr_adr_3.value = adr
         self.dut.wr_dat_3.value = dat

      self.sim.msg(f'Port={self.id} WR @{adr:02X}={dat:0{self.nibbles}X}')

   def data(self):
      if self.id == 0:
         return self.dut.rd_dat_0.value.integer
      elif self.id == 1:
         return self.dut.rd_dat_1.value.integer
      elif self.id == 2:
         return self.dut.rd_dat_2.value.integer
      elif self.id == 3:
         return self.dut.rd_dat_3.value.integer

   def idle(self):
      if self.type == 'r':
         if self.id == 0:
            self.dut.rd_enb_0.value = 0
            self.dut.rd_adr_0.value = 0 # random
         elif self.id == 1:
            self.dut.rd_enb_1.value = 0
            self.dut.rd_adr_1.value = 0 # random
         elif self.id == 2:
            self.dut.rd_enb_2.value = 0
            self.dut.rd_adr_2.value = 0 # random
         elif self.id == 3:
            self.dut.rd_enb_3.value = 0
            self.dut.rd_adr_3.value = 0 # random
      else:
         if self.id == 0:
            self.dut.wr_enb_0.value = 0
            self.dut.wr_adr_0.value = 0 # random
            self.dut.wr_dat_0.value = 0 # random
         elif self.id == 1:
            self.dut.wr_enb_1.value = 0
            self.dut.wr_adr_1.value = 0 # random
            self.dut.wr_dat_1.value = 0 # random
         elif self.id == 2:
            self.dut.wr_enb_2.value = 0
            self.dut.wr_adr_2.value = 0 # random
            self.dut.wr_dat_2.value = 0 # random
         elif self.id == 3:
            self.dut.wr_enb_3.value = 0
            self.dut.wr_adr_3.value = 0 # random
            self.dut.wr_dat_31.value = 0 # random

def hex(n, pad=0):
   if pad:
      return f'000000000000000000000000{n.value.hex()[2:].upper()}'[-pad:]
   else:
      return n.value.hex()[2:].upper()

def printstate(sim):
   if sim.sdr:
      try:
         sim.msg(f'R0: {sim.dut.ra.rd_enb_0_q.value} {hex(sim.dut.ra.rd_adr_0_q, 2)} {hex(sim.dut.ra.rd_dat_0_q, 18)} R1: {sim.dut.ra.rd_enb_1_q.value} {hex(sim.dut.ra.rd_adr_1_q, 2)} {hex(sim.dut.ra.rd_dat_1_q, 18)}')
      except:
         sim.msg(f'R0: {sim.dut.ra.rd_enb_0_q.value} {sim.dut.ra.rd_adr_0_q.value} {sim.dut.ra.rd_dat_0_q.value} R1: {sim.dut.ra.rd_enb_1_q.value} {sim.dut.ra.rd_adr_1_q.value} {sim.dut.ra.rd_dat_1_q.value}')

      try:
         sim.msg(f'W0: {sim.dut.ra.wr_enb_0_q.value} {hex(sim.dut.ra.wr_adr_0_q, 2)} {hex(sim.dut.ra.wr_dat_0_q, 18)}')
      except:
         sim.msg(f'W0: {sim.dut.ra.wr_enb_0_q.value} {sim.dut.ra.wr_adr_0_q.value} {sim.dut.ra.wr_dat_0_q.value}')
   else:
      pass

def printstate_32(sim):
   if sim.sdr:
      try:
         sim.msg(f'R0: {sim.dut.ra.rd_enb_0_q.value} {hex(sim.dut.ra.rd_adr_0_q, 2)} {hex(sim.dut.ra.rd_dat_0_q, 8)} R1: {sim.dut.ra.rd_enb_1_q.value} {hex(sim.dut.ra.rd_adr_1_q, 2)} {hex(sim.dut.ra.rd_dat_1_q, 8)}')
      except:
         sim.msg(f'R0: {sim.dut.ra.rd_enb_0_q.value} {sim.dut.ra.rd_adr_0_q.value} {sim.dut.ra.rd_dat_0_q.value} R1: {sim.dut.ra.rd_enb_1_q.value} {sim.dut.ra.rd_adr_1_q.value} {sim.dut.ra.rd_dat_1_q.value}')

      try:
         sim.msg(f'W0: {sim.dut.ra.wr_enb_0_q.value} {hex(sim.dut.ra.wr_adr_0_q, 2)} {hex(sim.dut.ra.wr_dat_0_q, 8)}')
      except:
         sim.msg(f'W0: {sim.dut.ra.wr_enb_0_q.value} {sim.dut.ra.wr_adr_0_q.value} {sim.dut.ra.wr_dat_0_q.value}')
   else:
      pass

# ------------------------------------------------------------------------------------------------
# Tasks

# get rid of z on anything that will be sampled here
# is there a func to get all inputs?
async def init(dut, sim):
   """Initialize inputs. """

   return

async def initSite(dut, sim):
   """Initialize inputs. """

   dut.wbs_stb_i.value = 0
   dut.wbs_cyc_i.value = 0
   dut.la_data_in.value = 0
   dut.la_oenb.value = 0
   dut.io_in.value = 0

   return

async def config(dut, sim):
   """Configure core, etc. """

   return

async def coreMonitor(dut, sim):
   """Watch for core events. """

   return

async def genReset(dut, sim):
   """Generate reset. """

   first = True
   done = False

   while not done:
      await RisingEdge(sim.clk1x)
      if sim.cycle < sim.resetCycle:
         if first:
            sim.msg(f'Resetting...')
            first = False
         dut.reset.value = 1
      elif not done:
         sim.msg(f'Releasing reset.')
         dut.reset.value = 0
         done = True

async def genClocks(dut, sim):
   """Generate clock pulses. """

   sim.clk1x = dut.clk
   clk = Clock(sim.clk1x, sim.clk1xPeriod, 'ns')
   await cocotb.start(clk.start())

   sim.cycle = 0
   while True:
      sim.cycle += 1
      if sim.cycle % sim.hbCycles == 0:
         sim.msg(f'...tick...')
      await RisingEdge(sim.clk1x)


async def configSite(dut, sim):
   """Configure core, etc. """

   return

async def genResetSite(dut, sim):
   """Generate reset. """

   first = True
   done = False

   while not done:
      await RisingEdge(sim.clk1x)
      if sim.cycle < sim.resetCycle:
         if first:
            sim.msg(f'Resetting...')
            first = False
         dut.wb_rst_i.value = 1
      elif not done:
         sim.msg(f'Releasing reset.')
         dut.wb_rst_i.value = 0
         done = True

async def genClocksSite(dut, sim):
   """Generate clock pulses. """

   sim.clk1x = dut.wb_clk_i
   clk = Clock(sim.clk1x, sim.clk1xPeriod, 'ns')
   await cocotb.start(clk.start())

   sim.cycle = 0
   while True:
      sim.cycle += 1
      if sim.randomIO:
         dut.io_in.value = int(hexrandom(9),16)*2  # randomize 1:36 (test_enable=0)
      assert sim.cycle < sim.maxCycles, f'Maximum cycles reached!'
      if sim.cycle % sim.hbCycles == 0:
         sim.msg(f'...tick...')
      await RisingEdge(sim.clk1x)


# ------------------------------------------------------------------------------------------------
# Interfaces

# ------------------------------------------------------------------------------------------------
# Do something

# ------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------
@cocotb.test()
async def tb(dut):
   """ToySRAM 64x72 array test"""

   sim = Sim(dut)
   sim.sdr = True
   sim.ddr = False
   sim.clk1xPeriod = 1
   sim.clk2x = False
   sim.maxCycles = 50000

   # init stuff
   await init(dut, sim)

   # start clocks,reset
   clkGen = await cocotb.start(genClocks(dut, sim))
   await cocotb.start(genReset(dut, sim))

   await Timer(sim.resetCycle + 5, units='ns')
   if dut.reset.value != 0:
      sim.ok = False
      sim.fail = 'Reset active too long!'

   # config stuff
   await config(dut, sim)

   # monitor stuff
   await cocotb.start(coreMonitor(dut, sim))

   # do stuff
   data = Memory(64, 72)
   if sim.sdr:
      portsRd = [Port(sim, 0, 'r'), Port(sim, 1, 'r')]
      portsWr = [Port(sim, 0, 'w')]
   else:
      portsRd = [Port(sim, 0, 'r'), Port(sim, 1, 'r'), Port(sim, 2, 'r'), Port(sim, 3, 'r')]
      portsWr = [Port(sim, 0, 'w'), Port(sim, 1, 'w')]

   await RisingEdge(sim.clk1x)

   # idle
   for p in portsRd:
      p.idle()
   for p in portsWr:
      p.idle()

   for i in range(10):
      await RisingEdge(sim.clk1x)

   # init array
   sim.msg('Initializing array...')
   if sim.sdr:
      for a in range(64):
         d0 = int(f'{a:02X}55555555555555{a:02X}', 16)
         portsWr[0].write(a, d0)
         await RisingEdge(sim.clk1x)
         data.write(a, d0)  # now visible for reads
         portsWr[0].idle()
   else:
      pass
      '''
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
      '''

   # random cmds
   sim.msg('Running random commands...')
   updates = []
   checks = []
   reads = [0, 0, 0, 0]
   writes = [0, 0]
   saveData = None
   quiesced = False
   quiesceCyc = sim.cycle + sim.maxCycles - 10
   errors = 0
   #rangesRd = [(0,63), (0,63), (0,63), (0,63)]
   rangesRd = [(0,7), (0,7), (0,7), (0,7)]
   #rangesWr = [(0,63), (0,63),(0,63), (0,63)]
   rangesWr = [(0,7), (0,7)]
   verbose = True

   for c in range(sim.maxCycles):

      sim.ok = True

      await FallingEdge(sim.clk1x)

      # check reads
      checksNext = []
      for i in range(len(checks)):
         rd = checks[i]
         if sim.cycle == rd[0]:
            port = rd[1]
            adr = rd[2]
            act = portsRd[port].data()
            exp = saveData[rd[2]]
            if act != exp:
               sim.ok = False
               try:
                  sim.msg(f'* RD MISCOMPARE * port={port} adr={adr:02X} act={act:018X} exp={exp:018X}')
               except:
                  sim.msg(f'* RD MISCOMPARE * port={port} adr={adr} act={act} exp={exp}')
            elif verbose:
               sim.msg(f'* RD COMPARE * port={port} adr={adr:02X} act={act:018X} exp={exp:018X}')

         else:
            checksNext.append(rd)
      checks = checksNext

      # do writes
      updatesNext = [] # always only 1 cycle
      for i in range(len(updates)):
         wr = updates[i]
         if sim.cycle == wr[0]:
            data.write(wr[2], wr[3])
         else:
            assert False, f'HUH? should always be this cycle! {sim.cycle},{updates}'
      updates = updatesNext

      # save current data
      saveData = data.readall()

      # quiesce?
      if sim.cycle >= quiesceCyc:
         if not quiesced:
            sim.msg('Quiescing...')
            quiesced = True

      # w0/w1 write coll will give w1 precedence - or make it avoid
      aw = [None] * 2
      for i in range(len(portsWr)):
         portsWr[i].idle()
         aw[i] = -1
         if not quiesced and randint(1, 10) < 5:
            r = rangesWr[i]
            aw[i] = randint(r[0], r[1])
            d = int(hexrandom(18), 16)
            portsWr[i].write(aw[i], d)
            updates.append((sim.cycle + 1, i, aw[i], d))
            writes[i] += 1

      for i in range(len(portsRd)):
         portsRd[i].idle()
         if not quiesced and randint(1, 10) < 5:
            r = rangesRd[i]
            ar = randint(r[0], r[1])
            while ar == aw[0] or ar == aw[1]:
               ar = randint(r[0], r[1])
            portsRd[i].read(ar)
            checks.append((sim.cycle + 2, i, ar))
            reads[i] += 1

      await RisingEdge(sim.clk1x)
      #printstate(sim)

      if not sim.ok: # and stopOnFail:
         break

   sim.msg('Done.')
   # idle
   for p in portsRd:
      p.idle()
   for p in portsWr:
      p.idle()

   sim.msg('Final State')
   print(data)
   for i in range(len(portsRd)):
      print(f'Reads Port {i}:  {reads[i]}')
   for i in range(len(portsWr)):
      print(f'Writes Port {i}: {writes[i]}')

   if sim.ok:
      sim.msg(f'You has opulence.')
   else:
      for i in range(10):
          await RisingEdge(sim.clk1x)
      sim.msg(f'You are worthless and weak!')
      assert False, f'[{sim.cycle:08d}] {sim.fail}'

# ------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------
@cocotb.test()
async def tb_32x32(dut):
   """ToySRAM 32x32 array test"""

   sim = Sim(dut)
   sim.sdr = True
   sim.ddr = False
   sim.clk1xPeriod = 1
   sim.clk2x = False
   sim.maxCycles = 10000

   # init stuff
   await init(dut, sim)

   # start clocks,reset
   clkGen = await cocotb.start(genClocks(dut, sim))
   await cocotb.start(genReset(dut, sim))

   await Timer(sim.resetCycle + 5, units='ns')
   if dut.reset.value != 0:
      sim.ok = False
      sim.fail = 'Reset active too long!'

   # config stuff
   await config(dut, sim)

   # monitor stuff
   await cocotb.start(coreMonitor(dut, sim))

   # do stuff
   data = Memory(32, 32)
   if sim.sdr:
      portsRd = [Port(sim, 0, 'r', 8), Port(sim, 1, 'r', 8)]
      portsWr = [Port(sim, 0, 'w', 8)]
   else:
      portsRd = [Port(sim, 0, 'r', 8), Port(sim, 1, 'r', 8), Port(sim, 2, 'r', 8), Port(sim, 3, 'r', 8)]
      portsWr = [Port(sim, 0, 'w', 8), Port(sim, 1, 'w', 8)]

   await RisingEdge(sim.clk1x)

   # idle
   for p in portsRd:
      p.idle()
   for p in portsWr:
      p.idle()

   for i in range(10):
      await RisingEdge(sim.clk1x)

   # init array
   sim.msg('Initializing array...')
   if sim.sdr:
      for a in range(32):
         d0 = int(f'{a:02X}5555{a:02X}', 16)
         portsWr[0].write(a, d0)
         await RisingEdge(sim.clk1x)
         data.write(a, d0)  # now visible for reads
         portsWr[0].idle()
   else:
      pass

   # random cmds
   sim.msg('Running random commands...')
   updates = []
   checks = []
   reads = [0, 0, 0, 0]
   writes = [0, 0]
   saveData = None
   quiesced = False
   quiesceCyc = sim.cycle + sim.maxCycles - 10
   errors = 0
   #rangesRd = [(0,1), (0,1), (0,1), (0,1)]
   rangesRd = [(0,31), (0,31), (0,31), (0,31)]
   #rangesWr = [(0,1), (0,1)]
   rangesWr = [(0,31), (0,31)]
   verbose = True

   for c in range(sim.maxCycles):

      sim.ok = True

      await FallingEdge(sim.clk1x)

      # check reads
      checksNext = []
      for i in range(len(checks)):
         rd = checks[i]
         if sim.cycle == rd[0]:
            port = rd[1]
            adr = rd[2]
            act = portsRd[port].data()
            exp = saveData[rd[2]]
            if act != exp:
               sim.ok = False
               try:
                  sim.msg(f'* RD MISCOMPARE * port={port} adr={adr:02X} act={act:08X} exp={exp:08X}')
               except:
                  sim.msg(f'* RD MISCOMPARE * port={port} adr={adr} act={act} exp={exp}')
            elif verbose:
               sim.msg(f'* RD COMPARE * port={port} adr={adr:02X} act={act:08X} exp={exp:08X}')

         else:
            checksNext.append(rd)
      checks = checksNext

      # do writes
      updatesNext = [] # always only 1 cycle
      for i in range(len(updates)):
         wr = updates[i]
         if sim.cycle == wr[0]:
            data.write(wr[2], wr[3])
         else:
            assert False, f'HUH? should always be this cycle! {sim.cycle},{updates}'
      updates = updatesNext

      # save current data
      saveData = data.readall()

      # quiesce?
      if sim.cycle >= quiesceCyc:
         if not quiesced:
            sim.msg('Quiescing...')
            quiesced = True

      # w0/w1 write coll will give w1 precedence - or make it avoid
      aw = [None] * 2
      for i in range(len(portsWr)):
         portsWr[i].idle()
         aw[i] = -1
         if not quiesced and randint(1, 10) < 5:
            r = rangesWr[i]
            aw[i] = randint(r[0], r[1])
            d = int(hexrandom(8), 16)
            portsWr[i].write(aw[i], d)
            updates.append((sim.cycle + 1, i, aw[i], d))
            writes[i] += 1

      for i in range(len(portsRd)):
         portsRd[i].idle()
         if not quiesced and randint(1, 10) < 5:
            r = rangesRd[i]
            ar = randint(r[0], r[1])
            while ar == aw[0] or ar == aw[1]:
               ar = randint(r[0], r[1])
            portsRd[i].read(ar)
            checks.append((sim.cycle + 2, i, ar))
            reads[i] += 1

      await RisingEdge(sim.clk1x)
      #printstate_32(sim)

      if not sim.ok: # and stopOnFail:
         break

   sim.msg('Done.')
   # idle
   for p in portsRd:
      p.idle()
   for p in portsWr:
      p.idle()

   sim.msg('Final State')
   print(data)
   for i in range(len(portsRd)):
      print(f'Reads Port {i}:  {reads[i]}')
   for i in range(len(portsWr)):
      print(f'Writes Port {i}: {writes[i]}')

   if sim.ok:
      sim.msg(f'You has opulence.')
   else:
      for i in range(10):
          await RisingEdge(sim.clk1x)
      sim.msg(f'You are worthless and weak!')
      assert False, f'[{sim.cycle:08d}] {sim.fail}'

# ------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------
@cocotb.test()
async def tb_site(dut):
   """ToySRAM site test"""

   sim = Sim(dut)
   sim.sdr = True
   sim.ddr = False
   sim.clk1xPeriod = 1
   sim.clk2x = False
   sim.maxCycles = 50000
   sim.randomIO = True

   cfgBase = 0x00000000
   ctlBase = 0x00010000
   ra0Base = 0x00100000

   # init stuff
   await initSite(dut, sim)

   # start clocks,reset
   clkGen = await cocotb.start(genClocksSite(dut, sim))
   await cocotb.start(genResetSite(dut, sim))

   await Timer(sim.resetCycle + 5, units='ns')
   if dut.wb_rst_i.value != 0:
      sim.ok = False
      sim.fail = 'Reset active too long!'

   if dut.io_in.value != 0:
      sim.ok = False
      sim.fail = 'I/O inputs not zero!'

   # config stuff
   await configSite(dut, sim)

   # monitor stuff
   await cocotb.start(coreMonitor(dut, sim))

   # do stuff

   await RisingEdge(sim.clk1x)

   ra = Memory(32, 32)

   # write and read ra0 w0/r0
   for i in range(32):

      adr = ra0Base + i
      dat = int(hexrandom(8), 16)
      sim.msg(f'Writing Port 0 @{adr:08X} {i:02X}={dat:08X}')
      dut.wbs_cyc_i.value = 1
      dut.wbs_stb_i.value = 1
      dut.wbs_we_i.value = 1
      dut.wbs_adr_i.value = adr
      dut.wbs_sel_i.value = 0xF
      dut.wbs_dat_i.value = dat
      ra.write(i, dat)

      await RisingEdge(sim.clk1x)
      dut.wbs_cyc_i.value = 0
      dut.wbs_stb_i.value = 0

      while (dut.wbs_ack_o.value == 0):
         await RisingEdge(sim.clk1x)

      sim.msg(f'Reading Port 0 @{adr:08X} {i:02X}')
      dut.wbs_cyc_i.value = 1
      dut.wbs_stb_i.value = 1
      dut.wbs_we_i.value = 0
      dut.wbs_adr_i.value = adr

      await RisingEdge(sim.clk1x)
      dut.wbs_cyc_i.value = 0
      dut.wbs_stb_i.value = 0

      while (dut.wbs_ack_o.value == 0):
         await RisingEdge(sim.clk1x)

      sim.msg(f'Read Data: {dut.wbs_dat_o.value.integer:08X}')
      assert dut.wbs_dat_o.value == dat, f'Read data miscompare! exp={dat:08X} act={dut.wbs_dat_o.value.integer:08X}'

   # read ra0 r1
   for i in range(32):

      adr = ra0Base + 0x00004000 + i
      sim.msg(f'Reading Port 1 @{adr:08X}  {i:02X}')
      dut.wbs_cyc_i.value = 1
      dut.wbs_stb_i.value = 1
      dut.wbs_we_i.value = 0
      dut.wbs_adr_i.value = adr

      await RisingEdge(sim.clk1x)
      dut.wbs_cyc_i.value = 0
      dut.wbs_stb_i.value = 0

      while (dut.wbs_ack_o.value == 0):
         await RisingEdge(sim.clk1x)

      sim.msg(f'Read Data: {dut.wbs_dat_o.value.integer:08X}')
      assert dut.wbs_dat_o.value == ra.read(i), f'Read data miscompare! exp={ra.read(i):08X} act={dut.wbs_dat_o.value.integer:08X}'

   # read ra0 r0,r1 through scan

   # control.v
   test_enable = dut.io_in[0];
   scan_clk = dut.io_in[1];
   scan_di = dut.io_in[2];
   scan_do = dut.io_out[3]

   io_ra0_clk = dut.io_in[4];
   io_ra0_rst = dut.io_in[5];
   io_ra0_r0_enb = dut.io_in[6];
   io_ra0_r1_enb = dut.io_in[7];
   io_ra0_w0_enb = dut.io_in[8];

   '''
   io_ra0_r0_adr = scan_reg_q[127:123];
   io_ra0_r0_dat = scan_reg_q[122:91]; // loaded by io_ra0_clk
   io_ra0_r1_adr = scan_reg_q[90:86];
   io_ra0_r1_dat = scan_reg_q[85:54];  // loaded by io_ra0_clk
   io_ra0_w0_adr = scan_reg_q[53:49];
   io_ra0_w0_dat = scan_reg_q[48:17];
   '''

   scanLen = 128
   scanHalfPer = 1
   noisy = False

   sim.msg(f'Starting scan sequences.')
   test_enable.value = 1
   sim.randomIO = False

   # load 0's
   sim.msg(f'Writing zeroes...')
   scan_di.value = 0
   for i in range(scanLen):
      scan_clk.value = 0
      await Timer(scanHalfPer, units='ns')
      scan_clk.value = 1
      await Timer(scanHalfPer, units='ns')
      if noisy:
         sim.msg(f' ScanReg={dut.site.ctl.scan_reg_q.value}')

   # check 0's
   sim.msg(f'Checking zeroes...')
   assert scan_do.value == 0, f'Scanout not 0! {scan_do.value}'
   for i in range(1, scanLen):
      scan_clk.value = 0
      await Timer(scanHalfPer, units='ns')
      scan_clk.value = 1
      await Timer(scanHalfPer, units='ns')
      assert scan_do.value == 0, f'Scanout not 0! {scan_do.value}'

   # read r0,r1
   sim.msg(f'Reading R0@15, R1@16...')
   scanIn = '01111' + '11111111111111111111111111111111' + \
            '10000' + '11111111111111111111111111111111' + \
            '00000' + '00000000000000000000000000000000' + \
            '00000000000000000'

   sim.msg(f'Scanning in...')
   for i in range(scanLen):
      scan_di.value = int(scanIn[i])
      scan_clk.value = 0
      await Timer(scanHalfPer, units='ns')
      scan_clk.value = 1
      await Timer(scanHalfPer, units='ns')
      if noisy:
         sim.msg(f' ScanReg={dut.site.ctl.scan_reg_q.value}')

   readHalfPer = 50

   io_ra0_rst.value = 0
   io_ra0_r0_enb.value = 1
   io_ra0_r1_enb.value = 1
   await Timer(readHalfPer, units='ns')
   # adr
   sim.msg('Blipping RA0 clk...')
   io_ra0_clk.value = 1
   await Timer(readHalfPer, units='ns')
   io_ra0_clk.value = 0
   await Timer(readHalfPer, units='ns')
   if noisy:
      sim.msg(f' ScanReg={dut.site.ctl.scan_reg_q.value}')
   # dat
   sim.msg('Blipping RA0 clk...')
   io_ra0_r0_enb.value = 0
   io_ra0_r1_enb.value = 0
   io_ra0_clk.value = 1
   await Timer(readHalfPer, units='ns')
   io_ra0_clk.value = 0
   await Timer(readHalfPer, units='ns')
   # capture in scan_reg
   sim.msg('Blipping RA0 clk...')
   io_ra0_clk.value = 1
   await Timer(readHalfPer, units='ns')
   io_ra0_clk.value = 0
   await Timer(readHalfPer, units='ns')

   sim.msg(f'Scanning out...')
   scan_di.value = 0
   scanOut = f'{scan_do.value}'
   for i in range(1, scanLen):
      scan_clk.value = 0
      await Timer(scanHalfPer, units='ns')
      scan_clk.value = 1
      await Timer(scanHalfPer, units='ns')
      scanOut += f'{scan_do.value}'

   sim.msg(f'ScanData={int(scanOut,2):032X}')
   sim.msg(f' r0 adr:{int(scanOut[0:5], 2):02X}')
   sim.msg(f' r0 dat:{int(scanOut[5:37], 2):08X}')
   assert int(scanOut[5:37], 2) == ra.read(15), f'R0 Miscompare! exp={ra.read(15):08X} dat={int(scanOut[5:37], 2):08X}'
   sim.msg(f' r1 adr:{int(scanOut[37:42], 2):02X}')
   sim.msg(f' r1 dat:{int(scanOut[42:74], 2):08X}')
   assert int(scanOut[42:74], 2) == ra.read(16), f'R0 Miscompare! exp={ra.read(16):08X} dat={int(scanOut[42:74], 2):08X}'
   sim.msg(f' w0 adr:{int(scanOut[74:79], 2 ):02X}')
   sim.msg(f' w0 dat:{int(scanOut[79:111], 2):08X}')
   sim.msg(f'    cfg:{int(scanOut[111:], 2):05X}')

   # write w0
   sim.msg(f'Writing W0@15=08675309...')
   scanIn = '00000' + '11111111111111111111111111111111' + \
            '00000' + '11111111111111111111111111111111' + \
            '01111' + '00001000011001110101001100001001' + \
            '00000000000000000'

   sim.msg(f'Scanning in...')
   for i in range(scanLen):
      scan_di.value = int(scanIn[i])
      scan_clk.value = 0
      await Timer(scanHalfPer, units='ns')
      scan_clk.value = 1
      await Timer(scanHalfPer, units='ns')
      if noisy:
         sim.msg(f' ScanReg={dut.site.ctl.scan_reg_q.value}')

   readHalfPer = 50

   io_ra0_rst.value = 0
   io_ra0_w0_enb.value = 1
   await Timer(readHalfPer, units='ns')
   # adr/dat
   sim.msg('Blipping RA0 clk...')
   io_ra0_clk.value = 1
   await Timer(readHalfPer, units='ns')
   io_ra0_clk.value = 0
   await Timer(readHalfPer, units='ns')
   if noisy:
      sim.msg(f' ScanReg={dut.site.ctl.scan_reg_q.value}')
   io_ra0_w0_enb.value = 0
   ra.write(15, int('08675309', 16))

   # read r0,r1
   sim.msg(f'Reading R0@15, R1@16...')
   scanIn = '01111' + '11111111111111111111111111111111' + \
            '10000' + '11111111111111111111111111111111' + \
            '00000' + '00000000000000000000000000000000' + \
            '00000000000000000'

   sim.msg(f'Scanning in...')
   for i in range(scanLen):
      scan_di.value = int(scanIn[i])
      scan_clk.value = 0
      await Timer(scanHalfPer, units='ns')
      scan_clk.value = 1
      await Timer(scanHalfPer, units='ns')
      if noisy:
         sim.msg(f' ScanReg={dut.site.ctl.scan_reg_q.value}')

   readHalfPer = 50

   io_ra0_rst.value = 0
   io_ra0_r0_enb.value = 1
   io_ra0_r1_enb.value = 1
   await Timer(readHalfPer, units='ns')
   # adr
   sim.msg('Blipping RA0 clk...')
   io_ra0_clk.value = 1
   await Timer(readHalfPer, units='ns')
   io_ra0_clk.value = 0
   await Timer(readHalfPer, units='ns')
   if noisy:
      sim.msg(f' ScanReg={dut.site.ctl.scan_reg_q.value}')
   # dat
   sim.msg('Blipping RA0 clk...')
   io_ra0_r0_enb.value = 0
   io_ra0_r1_enb.value = 0
   io_ra0_clk.value = 1
   await Timer(readHalfPer, units='ns')
   io_ra0_clk.value = 0
   await Timer(readHalfPer, units='ns')
   # capture in scan_reg
   sim.msg('Blipping RA0 clk...')
   io_ra0_clk.value = 1
   await Timer(readHalfPer, units='ns')
   io_ra0_clk.value = 0
   await Timer(readHalfPer, units='ns')

   sim.msg(f'Scanning out...')
   scan_di.value = 0
   scanOut = f'{scan_do.value}'
   for i in range(1, scanLen):
      scan_clk.value = 0
      await Timer(scanHalfPer, units='ns')
      scan_clk.value = 1
      await Timer(scanHalfPer, units='ns')
      scanOut += f'{scan_do.value}'

   sim.msg(f'ScanData={int(scanOut,2):032X}')
   sim.msg(f' r0 adr:{int(scanOut[0:5], 2):02X}')
   sim.msg(f' r0 dat:{int(scanOut[5:37], 2):08X}')
   assert int(scanOut[5:37], 2) == ra.read(15), f'R0 Miscompare! exp={ra.read(15):08X} dat={int(scanOut[5:37], 2):08X}'
   sim.msg(f' r1 adr:{int(scanOut[37:42], 2):02X}')
   sim.msg(f' r1 dat:{int(scanOut[42:74], 2):08X}')
   assert int(scanOut[42:74], 2) == ra.read(16), f'R0 Miscompare! exp={ra.read(16):08X} dat={int(scanOut[42:74], 2):08X}'
   sim.msg(f' w0 adr:{int(scanOut[74:79], 2 ):02X}')
   sim.msg(f' w0 dat:{int(scanOut[79:111], 2):08X}')
   sim.msg(f'    cfg:{int(scanOut[111:], 2):05X}')

   test_enable.value = 0
   sim.randomIO = True

   await RisingEdge(sim.clk1x)
   sim.msg(f'Starting regular sequences.')

   # write and read ra0 w0/r0
   for i in range(32):

      adr = ra0Base + i
      dat = int(hexrandom(8), 16)
      sim.msg(f'Writing Port 0 @{adr:08X} {i:02X}={dat:08X}')
      dut.wbs_cyc_i.value = 1
      dut.wbs_stb_i.value = 1
      dut.wbs_we_i.value = 1
      dut.wbs_adr_i.value = adr
      dut.wbs_sel_i.value = 0xF
      dut.wbs_dat_i.value = dat
      ra.write(i, dat)

      await RisingEdge(sim.clk1x)
      dut.wbs_cyc_i.value = 0
      dut.wbs_stb_i.value = 0

      while (dut.wbs_ack_o.value == 0):
         await RisingEdge(sim.clk1x)

      sim.msg(f'Reading Port 0 @{adr:08X} {i:02X}')
      dut.wbs_cyc_i.value = 1
      dut.wbs_stb_i.value = 1
      dut.wbs_we_i.value = 0
      dut.wbs_adr_i.value = adr

      await RisingEdge(sim.clk1x)
      dut.wbs_cyc_i.value = 0
      dut.wbs_stb_i.value = 0

      while (dut.wbs_ack_o.value == 0):
         await RisingEdge(sim.clk1x)

      sim.msg(f'Read Data: {dut.wbs_dat_o.value.integer:08X}')
      assert dut.wbs_dat_o.value == dat, f'Read data miscompare! exp={dat:08X} act={dut.wbs_dat_o.value.integer:08X}'

   sim.msg('Done')

   for i in range(10):
      await RisingEdge(sim.clk1x)

