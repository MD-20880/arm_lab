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

entity tb_data_swapper is end tb_data_swapper;

architecture testSwapper of tb_data_swapper is
  
  component data_swapper
    port (
      dmao : in ahb_dma_out_type;
      HRDATA : out std_logic_vector (31 downto 0) -- AHB read-data
    );
  end component;
  
  for dS: data_swapper use entity WORK.data_swapper(structural);
  
  signal input: ahb_dma_out_type;
  signal output: std_logic_vector (31 downto 0);
  
begin
  
  