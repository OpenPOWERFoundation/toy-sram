## Cells needed for the Skywater test site

We need to produce the necessary 
* Schematic
* Layout 
* Logic and timing models for 



### Low level cells

1)	10T SRAM 
   a.	WWL, RWL0, , RWL1
   b.	(WBL WBL_B), RBL0, RBL1
   
2)	Local eval (NAND2 with 2 precharged inputs)

   a.	PC_Left, PC_Right, In_Left, In_Right -> Q (output)   

3)	LSDL state-holding latch (Latch with 2 dynamic inputs forming an 'Or')

   a.	In_Left, In_Right, CLK -> Q (output)   


### Mid level cell

Partially decode 2R1W 64Rx24 bit array). (Includes early/late output latch)

Inputs:

1)	Clock*A0,Clock*~A0
2)	~A1*~A2,~A1,*~A2, A1*~A2,A1*~A2,
3)	A3 ,~A3
4)	~A4*~A5,~A4,*~A5, A14*~A5,A4*~A5,
5)	DataIn0..DI23
6)	Early and late Clock for LSDL state holding latch.

Outputs:

1)	DataOut00..DO023
2)	DO10..DO123
3)	DO20..DO223
4)	DO30..DO323

