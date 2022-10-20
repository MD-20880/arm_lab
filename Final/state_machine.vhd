library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.misc.all;
library UNISIM;
use UNISIM.VComponents.all;


entity state_machine is
 port(
 -- Clock and Reset -----------------
 clkm : in std_logic;
 rstn : in std_logic;
 -- AHB Master records --------------
 dmai : in DMA_In_Type;
 dmao : out DMA_OUt_Type;
 -- ARM Cortex-M0 AHB-Lite signals -- 
 HADDR : in std_logic_vector (31 downto 0); -- AHB transaction address
 HSIZE : in std_logic_vector (2 downto 0); -- AHB size: byte, half-word or word
 HTRANS : in std_logic_vector (1 downto 0); -- AHB transfer: non-sequential only
 HWDATA : in std_logic_vector (31 downto 0); -- AHB write-data
 HWRITE : in std_logic; -- AHB write control
 HRDATA : out std_logic_vector (31 downto 0); -- AHB read-data
 HREADY : out std_logic -- AHB stall signal
 );
end;

architecture structural of state_machine is
  
  --register for dmai input
  signal dmai_reg: DMA_In_Type;
  
  --register for HTRANS input
  signal HTRANS_reg: std_logic_vector(2 downto 0);
  
  --build enumerated state types:
  type StateType is (idle,instr_fetch);
    
  signal curState, nextState: StateType;
  
  begin
  
  combi_nextState: process(curState, dmai_reg, HTRANS_reg)

		BEGIN
			CASE curState IS

	      			WHEN idle =>
	            			IF HTRANS_reg = '0' THEN 
	              				nextState <= instr_fetch;
	            			ELSE
	              				nextState <= idle; 
	            			END IF;
	              
	         WHEN instr_fetch =>
	            			IF dmao ='1' THEN
	              				nextState <= idle;
	            			ELSE
	              				nextState <= instr_fetch;
	            			END IF;

	                   
	        	END CASE;
	     END PROCESS; 
  
  
  
  