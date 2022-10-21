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


entity cm0_wrapper is
    port(
    ---- Clock and Reset --------------
    clkm : in std_logic;
    rstn : in std_logic;
    ---- AHB Master records -----------
    ahbmi : in ahb_mst_in_type;
    ahbmo : out ahb_mst_out_type;
    );
end;

architecture structural of cm0_wrapper is 

    component cortexm0
        port(

        );
        
    END component cortexm0;

    component AHB_bridge
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
    END component AHB_bridge;

signal HADDR : in std_logic_vector (31 downto 0); -- AHB transaction address
signal HSIZE : in std_logic_vector (2 downto 0); -- AHB size: byte, half-word or word
signal HTRANS : in std_logic_vector (1 downto 0); -- AHB transfer: non-sequential only
signal HWDATA : in std_logic_vector (31 downto 0); -- AHB write-data
signal HWRITE : in std_logic; -- AHB write control
signal HRDATA : out std_logic_vector (31 downto 0); -- AHB read-data
signal HREADY : out std_logic -- AHB stall signal

    begin

        cortexm0 : cortexm0 port map(

        );

        
        ahb_bridge : AHB_bridge port map(
            
        );