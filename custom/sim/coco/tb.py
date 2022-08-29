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
            t += t1 + '\n'
        return t

class Port:

   def __init__(self, sim, id, type='r'):
      self.sim = sim
      self.dut = sim.dut
      self.id = id
      self.type = type

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

      self.sim.msg(f'Port={self.id} WR @{adr:02X}={dat:018X}')

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
         if id == 0:
            self.dut.rd_enb_0.value = 0
            self.dut.rd_adr_0.value = 0 # random
         elif id == 1:
            self.dut.rd_enb_1.value = 0
            self.dut.rd_adr_1.value = 0 # random
         elif id == 2:
            self.dut.rd_enb_2.value = 0
            self.dut.rd_adr_2.value = 0 # random
         elif id == 3:
            self.dut.rd_enb_3.value = 0
            self.dut.rd_adr_3.value = 0 # random
      else:
         if id == 0:
            self.dut.wr_enb_0.value = 0
            self.dut.wr_adr_0.value = 0 # random
            self.dut.wr_dat_0.value = 0 # random
         elif id == 1:
            self.dut.wr_enb_1.value = 0
            self.dut.wr_adr_1.value = 0 # random
            self.dut.wr_dat_1.value = 0 # random
         elif id == 2:
            self.dut.wr_enb_2.value = 0
            self.dut.wr_adr_2.value = 0 # random
            self.dut.wr_dat_2.value = 0 # random
         elif id == 3:
            self.dut.wr_enb_3.value = 0
            self.dut.wr_adr_3.value = 0 # random
            self.dut.wr_dat_31.value = 0 # random

def printstate(sim):
   if sim.sdr:
      sim.msg(f'R0: {sim.dut.ra.rd_enb_0_q.value} {sim.dut.ra.rd_adr_0_q.value} {sim.dut.ra.rd_dat_0_q.value} R1: {sim.dut.ra.rd_enb_1_q.value} {sim.dut.ra.rd_adr_1_q.value} {sim.dut.ra.rd_dat_1_q.value}')
      sim.msg(f'W0: {sim.dut.ra.wr_enb_0_q.value} {sim.dut.ra.wr_adr_0_q.value} {sim.dut.ra.wr_dat_0_q.value}')
   else:
      sim.msg(f'R0: {sim.dut.ra.rd_enb_0_q:01X} {sim.dut.ra.rd_adr_0_q:02X} {sim.dut.ra.rd_dat_0_q:018X} R1: {sim.dut.ra.rd_enb_1_q:01X} {sim.dut.ra.rd_adr_1_q:02X} {sim.dut.ra.rd_dat_1_q:018X} R2: {sim.dut.ra.rd_enb_2_q:01X} {sim.dut.ra.rd_adr_2_q:02X} {sim.dut.ra.rd_dat_2_q:018X} R3: {sim.dut.ra.rd_enb_3_q:01X} {sim.dut.ra.rd_adr_3_q:02X} {sim.dut.ra.rd_dat_3_q:018X}')
      sim.msg(f'W0: {sim.dut.ra.wr_enb_0_q:01X} {sim.dut.ra.wr_adr_0_q:02X} {sim.dut.ra.wr_dat_0_q:018X} W1: {sim.dut.ra.wr_enb_1_q:01X} {sim.dut.ra.wr_adr_1_q:02X} {sim.dut.ra.wr_dat_1_q:018X}')

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

# ------------------------------------------------------------------------------------------------
# Tasks

# get rid of z on anything that will be sampled here
# is there a func to get all inputs?
async def init(dut, sim):
   """Initialize inputs. """

   return

   dut.nclk.value = 0
   dut.scan_in.value = 0
   dut.an_ac_scan_type_dc.value = 0x0
   dut.an_ac_chipid_dc.value = 0x0
   dut.an_ac_coreid.value = 0x0
   dut.an_ac_scom_sat_id.value = 0x0

   dut.an_ac_lbist_ary_wrt_thru_dc.value = 0
   dut.an_ac_gsd_test_enable_dc.value = 0
   dut.an_ac_gsd_test_acmode_dc.value = 0
   dut.an_ac_ccflush_dc.value = 0
   dut.an_ac_ccenable_dc.value = 0
   dut.an_ac_lbist_en_dc.value = 0
   dut.an_ac_lbist_ip_dc.value = 0
   dut.an_ac_lbist_ac_mode_dc.value = 0
   dut.an_ac_scan_diag_dc.value = 0
   dut.an_ac_scan_dis_dc_b.value = 0

   dut.an_ac_rtim_sl_thold_8.value = 0
   dut.an_ac_func_sl_thold_8.value = 0
   dut.an_ac_func_nsl_thold_8.value = 0
   dut.an_ac_ary_nsl_thold_8.value = 0
   dut.an_ac_sg_8.value = 0
   dut.an_ac_fce_8.value = 0
   dut.an_ac_abst_scan_in.value = 0

   dut.an_ac_checkstop.value = 0

   dut.an_ac_reset_1_complete.value = 0
   dut.an_ac_reset_2_complete.value = 0
   dut.an_ac_reset_3_complete.value = 0
   dut.an_ac_reset_wd_complete.value = 0

   dut.an_ac_pm_fetch_halt.value = 0
   dut.an_ac_debug_stop.value = 0

   dut.an_ac_tb_update_enable.value = 1
   dut.an_ac_tb_update_pulse.value = 0 # tb clock if xucr0[tcs]=1 (must be <1/2 proc clk; tb pulse is 2x this clock)

   # why is coco turning [0] into non-vector??? or is that gpi/vpi/icarus/???
   if sim.threads == 1:
      dut.an_ac_pm_thread_stop.value = 0x1
      dut.an_ac_external_mchk.value = 0
      dut.an_ac_sleep_en.value = 0
      dut.an_ac_ext_interrupt.value = 0
      dut.an_ac_crit_interrupt.value = 0
      dut.an_ac_perf_interrupt.value = 0
      dut.an_ac_hang_pulse.value = 0
      dut.an_ac_uncond_dbg_event.value = 0
   else:
      for i in range(sim.threads):
         dut.an_ac_pm_thread_stop[i].value = 0x1
         dut.an_ac_external_mchk[i].value = 0
         dut.an_ac_sleep_en[i].value = 0
         dut.an_ac_ext_interrupt[i].value = 0
         dut.an_ac_crit_interrupt[i].value = 0
         dut.an_ac_perf_interrupt[i].value = 0
         dut.an_ac_hang_pulse[i].value = 0
         dut.an_ac_uncond_dbg_event[i].value = 0

   await Timer(9, units='ns')

async def config(dut, sim):
   """Configure core, etc. """

   return

   #wtf make A2 module to do core-specific stuff
   # A2L2 load/store credits
   creditsLd = dut.c0.lq0.lsq.arb.load_cred_cnt_d           # 8 max
   creditsLdMax = dut.c0.lq0.lsq.arb.ld_cred_max            # hdw check
   creditsSt = dut.c0.lq0.lsq.arb.store_cred_cnt_d          # 32 max
   creditsStMax = dut.c0.lq0.lsq.arb.st_cred_max            # hdw check
   creditsLdStSingle = dut.c0.lq0.lsq.arb.spr_xucr0_cred_d.value   # 1 total credit
   #wtf this affects A2L2 - default=1
   #creditsLdStSingle = dut.c0.lq0.lsq.arb.spr_lsucr0_b2b_q.value   # 0=crit first, every other 1=crit first, b2b **the a2l2 spec does not say crit must be first**

   await RisingEdge(sim.clk1x)

   if sim.config.core.creditsLd is not None:
      creditsLd.value = Force(sim.config.core.creditsLd)
      creditsLdMax.value = Force(sim.config.core.creditsLd)
      sim.msg(f'A2L2: load credits changed from {creditsLd.value.integer} to {sim.config.core.creditsLd}.')
      await RisingEdge(sim.clk1x)
      creditsLd.value = Release()

   if sim.config.core.creditsSt is not None:
      creditsSt.value = Force(sim.config.core.creditsSt)
      creditsStMax.value = Force(sim.config.core.creditsSt)
      sim.msg(f'A2L2: store credits changed from {creditsSt.value.integer} to {sim.config.core.creditsSt}.')
      await RisingEdge(sim.clk1x)
      creditsSt.value = Release()

   if sim.config.core.creditsLdStSingle:
      creditsLdStSingle = Force(1)
      sim.msg(f'A2L2: only one load OR store allowed when credits=1/1.')
      await RisingEdge(sim.clk1x)
      creditsLdStSingle.value = Release()

   await RisingEdge(sim.clk1x)

async def coreMonitor(dut, sim):
   """Watch for core events. """

   return

   me = 'a2oMonitor'

   # errors
   creditsLdErr = dut.c0.lq0.lsq.arb.ld_cred_err_q
   creditsStErr = dut.c0.lq0.lsq.arb.st_cred_err_q

   # watches
   iu0Comp = dut.c0.iu_lq_i0_completed
   iu0CompIFAR = dut.c0.iuq0.iuq_cpl_top0.iuq_cpl0.cp2_i0_ifar
   iu1Comp = dut.c0.iu_lq_i1_completed
   iu1CompIFAR = dut.c0.iuq0.iuq_cpl_top0.iuq_cpl0.cp2_i1_ifar
   iuCompFlushIFAR = dut.c0.cp_t0_flush_ifar
   cp3NIA = dut.c0.iuq0.iuq_cpl_top0.iuq_cpl0.iuq_cpl_ctrl.cp3_nia_q           # nia after last cycle's completions

   # queue depths, etc.

   errors = [
      {'name': 'Load Credits', 'sig': creditsLdErr},
      {'name': 'Store Credits', 'sig': creditsStErr},
   ]

   done = False

   while not done:

      await RisingEdge(sim.clk1x)

      for i in range(len(errors)):
          assert errors[i]['sig'].value == 0, f'{me} Error: {errors[i]["name"]}'

      comp = ''
      if iu0Comp.value == 1:
         comp = f'0:{int(iu0CompIFAR.value.binstr + "00", 2):06X} '

      if iu1Comp.value == 1:
         comp = f'{comp}1:{int(iu1CompIFAR.value.binstr + "00", 2):06X} '

      if comp != '':
         comp = f'{comp}{int(iuCompFlushIFAR.value.binstr + "00", 2):016X}'
         sim.msg(f'C0: CP {comp}')


async def genReset(dut, sim):
   """Generate reset. """

   first = True
   done = False

   while not done:
      await RisingEdge(sim.clk1x)
      if sim.cycle < sim.resetCycle:
         if first:
            sim.msg(f'[{sim.cycle:08d}] Resetting...')
            first = False
         dut.reset.value = 1
      elif not done:
         sim.msg(f'[{sim.cycle:08d}] Releasing reset.')
         dut.reset.value = 0
         done = True

async def genClocks(dut, sim):
   """Generate clock pulses. """

   sim.clk1x = dut.clk
   clk = Clock(sim.clk1x, sim.clk1xPeriod, 'ns')
   await cocotb.start(clk.start())

   for cycle in range(sim.maxCycles):

      sim.cycle = cycle

      if cycle % sim.hbCycles == 0:
         sim.msg(f'[{cycle:08d}] ...tick...')

      await RisingEdge(sim.clk1x)

   sim.msg(f'[{sim.cycle:08d}] Reached max cycle.  Clocks stopped.')

# ------------------------------------------------------------------------------------------------
# Interfaces



# ------------------------------------------------------------------------------------------------
# Do something

@cocotb.test()
async def tb(dut):
   """ToySRAM array test"""

   sim = Sim(dut)
   sim.sdr = True
   sim.ddr = False
   sim.clk1xPeriod = 1
   sim.clk2x = False
   sim.maxCycles = 500

   # init stuff
   await init(dut, sim)

   # start clocks,reset
   await cocotb.start(genClocks(dut, sim))
   await cocotb.start(genReset(dut, sim))

   # start interfaces

   #await cocotb.start(A2L2.driver(dut, sim))
   #await cocotb.start(A2L2.checker(dut, sim))
   #await cocotb.start(A2L2.monitor(dut, sim))

   await Timer((sim.resetCycle + 5)*8, units='ns')
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

   updates = []
   checks = []
   reads = [0, 0, 0, 0]
   writes = [0, 0]
   saveData = None
   quiesced = False
   quiesceCyc = sim.cycle + sim.maxCycles - 10
   errors = 0
   rangesRd = [(0,7), (0,7), (0,7), (0,7)]
   #rangesWr = [(0,63), (0,63)]
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
      printstate(sim)

      if not sim.ok: # and stopOnFail:
         break

   if sim.ok:
      sim.msg(f'[{sim.cycle:08d}] You has opulence.')
   else:
      for i in range(10):
          await RisingEdge(sim.clk1x)
      sim.msg(f'[{sim.cycle:08d}] You are worthless and weak!')
      assert False, f'[{sim.cycle:08d}] {sim.fail}'

