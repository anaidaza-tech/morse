library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity morse is
    Port (
        clk          : in  std_logic;                    
        reset        : in  std_logic;                    
        iniciar      : in  std_logic;                    
        letra_sw     : in  std_logic_vector(2 downto 0); 
        led_morse    : out std_logic                     
    );
end morse;

architecture Comportamiento of morse is
    type tipo_estado is (reposo, verificar, punto, raya_1, raya_2, raya_3, pausa);

    signal edo_presente, edo_futuro : tipo_estado;

    constant limite_medio_seg : integer := 10;
    signal contador_tiempo    : integer range 0 to limite_medio_seg := 0;
    signal pulso_medio_seg    : std_logic := '0';

    signal registro_bits   : std_logic_vector(3 downto 0);
    signal simbolos_restan : integer range 0 to 4;

    signal patron_letra    : std_logic_vector(3 downto 0);
    signal cantidad_puntos : integer range 1 to 4;

    signal cargar     : std_logic;
    signal desplazar  : std_logic;

    signal bit_actual : std_logic;

begin
    bit_actual <= registro_bits(3);

    process (clk, reset)
        variable edo_anterior : tipo_estado := reposo;
    begin
        if (reset = '0') then
            contador_tiempo <= 0;
            pulso_medio_seg <= '0';
            edo_anterior    := reposo;
        elsif rising_edge(clk) then
            if (edo_presente = reposo) then
                contador_tiempo <= 0;
                pulso_medio_seg <= '0';
            else

                if (edo_presente /= edo_anterior) then
                    contador_tiempo <= 0;
                    pulso_medio_seg <= '0';
                elsif (contador_tiempo = limite_medio_seg - 1) then
                    contador_tiempo <= 0;
                    pulso_medio_seg <= '1';
                else
                    contador_tiempo <= contador_tiempo + 1;
                    pulso_medio_seg <= '0';
                end if;
            end if;
            edo_anterior := edo_presente;
        end if;
    end process;

    process (letra_sw)
    begin
        case letra_sw is
            when "000" => -- A: .-
                patron_letra    <= "0100";
                cantidad_puntos <= 2;
            when "001" => -- B: -...
                patron_letra    <= "1000";
                cantidad_puntos <= 4;
            when "010" => -- C: -.-.
                patron_letra    <= "1010";
                cantidad_puntos <= 4;
            when "011" => -- D: -..
                patron_letra    <= "1000";
                cantidad_puntos <= 3;
            when "100" => -- E: .
                patron_letra    <= "0000";
                cantidad_puntos <= 1;
            when "101" => -- F: ..-.
                patron_letra    <= "0010";
                cantidad_puntos <= 4;
            when "110" => -- G: --.
                patron_letra    <= "1100";
                cantidad_puntos <= 3;
            when others => -- H: .... ("111")
                patron_letra    <= "0000";
                cantidad_puntos <= 4;
        end case;
    end process;

    -- Registro de desplazamiento y contador de longitud
    process (clk, reset)
    begin
        if (reset = '0') then
            registro_bits   <= (others => '0');
            simbolos_restan <= 0;
        elsif rising_edge(clk) then
            if (cargar = '1') then
                registro_bits   <= patron_letra;
                simbolos_restan <= cantidad_puntos;
            elsif (desplazar = '1') then
                registro_bits   <= registro_bits(2 downto 0) & '0';
                simbolos_restan <= simbolos_restan - 1;
            end if;
        end if;
    end process;

    -- Memoria de estado 
    memoria_estado : process (clk, reset)
    begin
        if (reset = '0') then            
            edo_presente <= reposo;
        elsif rising_edge(clk)      then       
            edo_presente <= edo_futuro;
        end if;
    end process;

    -- Lógica de transición de estados
    transicion_estados : process (edo_presente, iniciar, pulso_medio_seg, simbolos_restan, bit_actual)
    begin
        edo_futuro <= edo_presente;

        case edo_presente is
            when reposo =>
                if (iniciar = '0') then 
                    edo_futuro <= verificar;
                else
                    edo_futuro <= reposo;
                end if;

            when verificar =>
                if (simbolos_restan = 0) then
                    edo_futuro <= reposo;
                else
                    if (bit_actual = '0') then
                        edo_futuro <= punto;
                    else
                        edo_futuro <= raya_1;
                    end if;
                end if;

            when punto =>
                if (pulso_medio_seg = '1') then
                    edo_futuro <= pausa;
                end if;

            when raya_1 =>
                if (pulso_medio_seg = '1') then
                    edo_futuro <= raya_2;
                end if;

            when raya_2 =>
                if (pulso_medio_seg = '1') then
                    edo_futuro <= raya_3;
                end if;

            when raya_3 =>
                if (pulso_medio_seg = '1') then
                    edo_futuro <= pausa;
                end if;

            when pausa =>
                if (pulso_medio_seg = '1') then
                    edo_futuro <= verificar;
                end if;

            when others =>
                edo_futuro <= reposo;
        end case;
    end process;
    
    -- Lógica de salidas
    logica_salida : process (edo_presente, pulso_medio_seg)
    begin
        led_morse <= '0';
        cargar    <= '0';
        desplazar <= '0';

        case edo_presente is
            when reposo =>
                led_morse <= '0';
                cargar    <= '1';  

            when verificar =>
                led_morse <= '0';

            when punto =>
                led_morse <= '1';  

            when raya_1 =>
                led_morse <= '1';  

            when raya_2 =>
                led_morse <= '1';

            when raya_3 =>
                led_morse <= '1';

            when pausa =>
                led_morse <= '0';
                if (pulso_medio_seg = '1') then
                    desplazar <= '1';
                end if;

            when others =>
                led_morse <= '0';
                cargar    <= '0';
                desplazar <= '0';
        end case;
    end process;
end Comportamiento;