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
use GRLIB.DMA2AHB_Package.all;

entity state_machine is
 port(
 -- Clock and Reset -----------------
 clkm : in std_logic;
 rstn : in std_logic;
 -- AHB Master records --------------
 dmai : out  ahb_dma_in_type;
 dmao : in  ahb_dma_out_type;
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
  
  --register for dmao input
  signal dmao_reg: ahb_dma_out_type;
  
  --register for HTRANS input
  signal HTRANS_reg: std_logic_vector(1 downto 0);
  
  --build enumerated state types:
  type StateType is (idle,init_trans,instr_fetch);
    
  signal curState, nextState: StateType;
  
  begin
  
  combi_nextState: process(curState, dmao_reg, HTRANS_reg)

		BEGIN
			CASE curState IS

	      			WHEN idle =>
	            			IF HTRANS_reg = "10" THEN 
	              				nextState <= instr_fetch;
	            			ELSE
	              				nextState <= idle; 
	            			END IF;
	            			
	         WHEN init_trans =>
	              				nextState <= instr_fetch;
	            		
	            			    
	         WHEN instr_fetch =>
	            			IF dmao.ready ='1' THEN
	              				nextState <= idle;
	            			ELSE
	              				nextState <= instr_fetch;
	            			END IF;
		 WHEN others => 
					nextState <= idle;
	                   
	        	END CASE;
	     END PROCESS; 
  
  seq_state: PROCESS (clkm, rstn)
  
		BEGIN
	        IF rstn = '1' THEN
	          curState <= idle;
	        ELSIF clkm'event AND clkm='1' THEN
	          curState <= nextState;
	        END IF;
	END PROCESS; -- seq
	
	combi_out: PROCESS(curState)
	 BEGIN
	 
	   if (curState = idle) THEN
	     HREADY <= '1';
	     dmai.start <= '0';
	   END IF;
	     
	   if (curState = init_trans) THEN 
	     dmai.start <= '1';
	   END IF;
	     
	   if (curState = instr_fetch) THEN
	     HREADY <= '0';
	     dmai.start <= '0';
	   END IF;
	END PROCESS;

	
	registerD: PROCESS(clkm)
	  BEGIN
	    IF clkm'event AND clkm='1' THEN
	      dmao_reg <= dmao;
	    END IF;
	  END PROCESS;
	
	HTRANS_register: PROCESS(clkm)
	  BEGIN
	    IF clkm'event AND clkm='1' THEN
	      HTRANS_reg <= HTRANS;
	    END IF;
	  END PROCESS;
END architecture;
  
  
