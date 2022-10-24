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
            -- CLOCK AND RESETS
            HCLK : in std_logic,
            HRESETn : in std_logic,

            -- AHB_LITE MASTER PORT
            HADDR : out std_logic_vector(31 downto 0),
            HBURST : out std_logic_vector(2 downto 0),
            HMASTLOCK : out std_logic,
            HPROT : out std_logic_vector(3 downto 0),
            HSIZE : out std_logic_vector(2 downto 0),
            HTRANS : out std_logic_vector(1 downto 0),
            HWDATA : out std_logic_vector(31 downto 0),
            HWRITE : out std_logic,
            HRDATA : in std_logic_vector(31 downto 0),
            HREADY: in std_logic,
            HRESP: in std_logic,

            -- MISCELLANEOUS
            NMI : in std_logic,
            IRQ : in std_logic_vector(15 downto 0),
            TXEV :out std_logic,
            RXEV : in std_logic,
            LOCKUP: out std_logic,
            SYSRESETREQ : out std_logic,

            -- POWER MANAGEMENT
            SLEEPING : out std_logic

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

signal HADDR : std_logic_vector (31 downto 0); -- AHB transaction address
signal HSIZE : std_logic_vector (2 downto 0); -- AHB size: byte, half-word or word
signal HTRANS : std_logic_vector (1 downto 0); -- AHB transfer: non-sequential only
signal HWDATA : std_logic_vector (31 downto 0); -- AHB write-data
signal HWRITE : std_logic; -- AHB write control
signal HRDATA : std_logic_vector (31 downto 0); -- AHB read-data
signal HREADY : std_logic; -- AHB stall signal

    begin

        cortexm0 : cortexm0 port map(
            HCLK => clkm,
            HRESETn => rstn,

            HADDR =>HADDR,
            HBURST => ahmbo.hburst,
            HMASTLOCK => ahmbo.lock,
            HPROT => ahmbo.hprot,
            HSIZE => ahmbo.hsize,
            HTRANS => ahmbo.htrans,
            HWDATA => ahmbo.hwdata,
            HWRITE => ahmbo.hwrite,
            HRDATA => ahmbi.hrdata,
            HREADY => ahmbi.hready,
            HRESP => ahmbi.hresp,

            NMI => '0',
            IRQ => "0000000000000000",
            TXEV => OPEN,
            RXEV => '0',
            LOCKUP=>OPEN,
            SYSRESETREQ => OPEN,

            SLEEPING=>OPEN

        );

        
        ahb_bridge : AHB_bridge port map(
            clkm => clkm,
            rstn => rstn,

            ahbmi => ahbmi,
            ahbmo => ahbmo,

            HADDR => HADDR,
            HSIZE => HSIZE,
            HTRANS => HTRANS,
            HWDATA => HWDATA,
            HWRITE => HWRITE,
            HRDATA => HRDATA,
            HREADY => HREADY
        );