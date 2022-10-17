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
entity AHB_bridge is
 port(
 -- Clock and Reset -----------------
 clkm : in std_logic;
 rstn : in std_logic;
 -- AHB Master records --------------
 ahbmi : in ahb_mst_in_type;
 ahbmo : out ahb_mst_out_type;
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
architecture structural of AHB_bridge is
--declare a component for state_machine
 component State_Machine 
  port (
    --- Clock and Reset --- 
  clkm : in std_logic;
  rstn : in std_logic;
   --- AHB Master Records --- (naming convention 'H' -> 'G')
  GADDR : in std_logic_vector (31 downto 0); -- AHB transaction address
  GSIZE : in std_logic_vector (2 downto 0); -- AHB size: byte, half-word or word
  GTRANS : in std_logic_vector (1 downto 0); -- AHB transfer: non-sequential only
  GWDATA : in std_logic_vector (31 downto 0); -- AHB write-data
  GWRITE : in std_logic; -- AHB write control
  dataMAin : in ahb_mst_in_type; -- dmai
  dataMAout : out ahb_mst_out_type; -- dmao
  GREADY : out std_logic -- AHB stall signal

 
 );
 END component State_Machine;
--declare a component for ahbmst 
--declare a component for data_swapper 
 
signal dmai : ahb_dma_in_type;
signal dmao : ahb_dma_out_type;
begin
--instantiate state_machine component and make the connections
sm1: State_Machine port map (
  clkm => clkm,
  rstn => rstn,
  GADDR => HADDR,
  GSIZE => HSIZE,
  GTRANS => HTRANS,
  GWDATA => HWDATA,
  GWRITE => HWRITE,
  dataMAin => ahbmi,
  dataMAout => ahbmo,
  GREADY => HREADY
);

--instantiate the ahbmst component and make the connections 


--instantiate the data_swapper component and make the connections

end structural;
