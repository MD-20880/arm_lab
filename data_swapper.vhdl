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

entity data_swapper is
  port(
    dmao : in ahb_dma_out_type;
    HRDATA : out std_logic_vector (31 downto 0) -- AHB read-data
  );
end entity data_swapper;

architecture structural of data_swapper is

-- I would something like that would work, but I dunno
-- will do a testbench on Monday

signal temp: std_logic_vector(31 downto 0);

signal isData: std_logic;

begin
  
  swap : process(dmao)
  begin
    temp(7 downto 0) <= dmao.rdata(31 downto 24);
    temp(15 downto 8) <= dmao.rdata(23 downto 16);
    temp(23 downto 16) <= dmao.rdata(15 downto 8);
    temp(31 downto 24) <= dmao.rdata(7 downto 0);
    isData <= '1';
  end process;
  
  output : process(isData)
  begin
    if isData = '1' then
      HRDATA <= temp;
      isData <= '0';
    end if;
  end process;
end;


    
  
