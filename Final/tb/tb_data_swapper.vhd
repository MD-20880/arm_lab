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
    
    signal clk              :std_logic := '0';
    signal rst              :std_logic := '0';
    signal data             :std_logic_vector(31 downto 0);
    signal data_validation  :std_logic_vector(31 downto 0);
    signal eof              :std_logic := '0';
    signal checked          :std_logic := '0';
    signal ready            :std_logic := '0';

    type STD_FILE is file of std_logic_vector(31 downto 0);

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


        ClockGenerator: process
        begin
           clk <= '0' after C_CLK, '1' after 2*C_CLK;
           wait for 2*C_CLK;
        end process;
        

        GetData_proc: process
            variable statrd         :FILE_OPEN_STATUS;
            variable statwr         :FILE_OPEN_STATUS;
            variable varstd_data    :std_logic_vector(31 downto 0);
            variable validation_data :std_logic_vector(31 downto 0);
         begin
            data      <= (others => '0');
            eof       <= '0';
            wait until rst = '0';
            file_open(statrd, fptrrd, C_FILE_NAME_RD, read_mode);
            while (not endfile(fptrrd)) loop
               wait until clk = '1';
               read(fptrrd, varstd_data);
               data <= varstd_data;
               wait until clk = '1';
               read(fptrrd, validation_data);
               data_validation <= validation_data;
               ready <= '1'; 
               wait until checked = '1';
               ready <= '0';
            end loop;
            wait until rising_edge(clk);
            eof       <= '1';
            file_close(fptrrd);
            file_close(fptrwr);
            wait;
        end process;

         

        testSwapper : process
            begin
                dmao_t.start <= '0';
                dmao_t.active <= '0';
                dmao_t.ready <= '0';
                dmao_t.retry <= '0';
                dmao_t.mexc <= '0';
                dmao_t.haddr <= "0000000000";
            while (eof = '0') loop
                wait until ready = '1';
                -- TODO Check result
                checked <='1';
                wait until ready ='0';
                checked <= '0';
            end loop;



    
    
    

    
