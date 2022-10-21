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

-- TODO: Write TB for data_swapper Using std.textio
use std.textio.all;


entity data_swapper_tb is
end entity;

architecture behavioral of data_swapper_tb is 

    component data_swapper
        port(
          dmao : in ahb_dma_out_type,
          HRDATA : out std_logic_vector (31 downto 0)
        );
    end component;

    constant TEST_FILE_RD :string := "";
    constant C_CLK :time := 10 ns;
    
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    
    signal dmao_t : ahb_dma_out_type;
    signal HRDATA_t : std_logic_vector (31 downto 0);
    -- Test FIle
    file fptr : text;
    variable flptr : line;


    begin

        dsut : data_swapper port map(
            dmao => dmao_t,
            HRDATA => HRDATA_t
        );

    dmao_t.start <= '0';
    dmao_t.active <= '0';
    dmao_t.ready <= '0';
    dmao_t.retry <= '0';
    dmao_t.mexc <= '0';
    dmao_t.haddr <= "0000000000";

    
    

    
