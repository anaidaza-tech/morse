library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture prueba of testbench is

    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1';
    signal iniciar      : std_logic := '1';
    signal letra_sw     : std_logic_vector(2 downto 0) := "000";
    signal led_morse    : std_logic;

    constant CLK_PERIOD : time := 20 ns; 

begin
    uut: entity work.morse
        port map (
            clk          => clk,
            reset        => reset,
            iniciar      => iniciar,
            letra_sw     => letra_sw,
            led_morse    => led_morse
        );

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

   
    stim_proc: process
    begin
        
        reset <= '0';
        iniciar <= '1';
        letra_sw <= "000"; 
        wait for 100 ns;
        reset <= '1'; 
        wait for 100 ns;
  
        iniciar <= '0';
        wait for 100 ns;
        iniciar <= '1';
        
        wait for 2.5 sec;

        letra_sw <= "100"; 
        wait for 100 ns;
        iniciar <= '0';
        wait for 100 ns;
        iniciar <= '1';
        
        wait for 1.5 sec;

        letra_sw <= "010"; 
        wait for 100 ns;
        iniciar <= '0';
        wait for 100 ns;
        iniciar <= '1';
        wait for 3.5 sec;

        wait; 
    end process;

end prueba;
