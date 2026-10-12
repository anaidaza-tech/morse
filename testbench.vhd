library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end testbench;

architecture sim of testbench is

    component morse
        Port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            iniciar   : in  std_logic;
            letra_sw  : in  std_logic_vector(2 downto 0);
            led_morse : out std_logic
        );
    end component;

    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';   
    signal iniciar   : std_logic := '1';  
    signal letra_sw  : std_logic_vector(2 downto 0) := "000";
    signal led_morse : std_logic;

    constant periodo : time := 20 ns;     

begin

    uut : morse
        port map (
            clk       => clk,
            reset     => reset,
            iniciar   => iniciar,
            letra_sw  => letra_sw,
            led_morse => led_morse
        );
    reloj : process
    begin
        clk <= '0';
        wait for periodo / 2;
        clk <= '1';
        wait for periodo / 2;
    end process;

    estimulos : process
    begin
        reset   <= '0';
        iniciar <= '1';
        wait for 100 ns;
        reset   <= '1';
        wait for 100 ns;
        letra_sw <= "000";
        wait for 40 ns;
        iniciar <= '0';
        wait for 60 ns;
        iniciar <= '1';
        wait for 5 us;
        letra_sw <= "001";
        wait for 40 ns;
        iniciar <= '0';
        wait for 60 ns;
        iniciar <= '1';
        wait for 5 us;

        letra_sw <= "010";
        wait for 40 ns;
        iniciar <= '0';
        wait for 60 ns;
        iniciar <= '1';
        wait for 5 us;
        letra_sw <= "011";
        wait for 40 ns;
        iniciar <= '0';
        wait for 60 ns;
        iniciar <= '1';
        wait for 5 us;
        letra_sw <= "100";
        wait for 40 ns;
        iniciar <= '0';
        wait for 60 ns;
        iniciar <= '1';
        wait for 5 us;
        letra_sw <= "101";
        wait for 40 ns;
        iniciar <= '0';
        wait for 60 ns;
        iniciar <= '1';
        wait for 5 us;
        letra_sw <= "110";
        wait for 40 ns;
        iniciar <= '0';
        wait for 60 ns;
        iniciar <= '1';
        wait for 5 us;
        letra_sw <= "111";
        wait for 40 ns;
        iniciar <= '0';
        wait for 60 ns;
        iniciar <= '1';
        wait for 5 us;
        letra_sw <= "001";
        wait for 40 ns;
        iniciar <= '0';
        wait for 60 ns;
        iniciar <= '1';
        wait for 600 ns;     
        reset <= '0';           
        wait for 100 ns;
        reset <= '1';
        wait for 3 us;

        wait;         
    end process;

end sim;