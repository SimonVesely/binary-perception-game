library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is
end tb_debounce;

architecture tb of tb_debounce is

    component debounce
        port (clk       : in std_logic;
              rst       : in std_logic;
              btn_in    : in std_logic;
              btn_press : out std_logic);
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal btn_in    : std_logic;
    signal btn_press : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : debounce
    port map (clk       => clk,
              rst       => rst,
              btn_in    => btn_in,
              btn_press => btn_press);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

    p_stimuli : process
    begin
        -- --- 1. INICIALIZACE ---
        rst <= '1';
        btn_in <= '0';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;
    
        -- --- 2. SIMULACE ZÁKMITŮ PŘI STISKU (Bounce) ---
        btn_in <= '1'; wait for 20 us; -- první dotek
        btn_in <= '0'; wait for 15 us; -- odskočení
        btn_in <= '1'; wait for 25 us; -- druhý dotek
        btn_in <= '0'; wait for 10 us; -- odskočení
        
        -- --- 3. STABILNÍ STISK (Tlačítko držíme) ---
        btn_in <= '1'; 
        wait for 2 ms; 
        
        -- --- 4. SIMULACE ZÁKMITŮ PŘI PUŠTĚNÍ ---
        btn_in <= '0'; wait for 15 us;
        btn_in <= '1'; wait for 10 us;
        btn_in <= '0'; wait for 20 us;
        btn_in <= '1'; wait for 5 us;
        btn_in <= '0'; -- Definitivní puštění
        
        wait for 2 ms; -- Čas na uklidnění logiky
    
        -- --- 5. TEST RYCHLÉHO "FALEŠNÉHO" STISKU ---
        btn_in <= '1'; wait for 100 us;
        btn_in <= '0';
        
        wait for 2 ms;
    end process;

end tb;

configuration cfg_tb_debounce of tb_debounce is
    for tb
    end for;
end cfg_tb_debounce;
