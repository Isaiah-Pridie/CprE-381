-- Isaiah Pridie
-- CprE 3810 Lab1 Part 3.5
-- Start Date: 2.3.2026, 9:31 PM

library ieee;
use IEEE.std_logic_1164.all;


entity tb_ones_comp_N is
end entity;

architecture Bus1Comp_N of tb_ones_comp_N is
    constant N : integer := 32;     -- can change this value to whatever we want

    signal s_I  :   std_logic_vector(N-1 downto 0) := (others => '0');   -- input bus
    signal s_O  :   std_logic_vector(N-1 downto 0);     -- output bus

    component ones_comp_n is 
        generic ( N : integer := 32 );  -- 32 by defualt
        port ( i_OC    : in std_logic_vector(N-1 downto 0);
               o_O     : out std_logic_vector(N-1 downto 0));
    end component;

    begin
        DUT: ones_comp_n
            generic map (N => N)
            port map ( i_OC => s_I,
                       o_O  => s_O );
        
        process
        variable var : std_logic_vector(N-1 downto 0);
        begin
            -- initialize the value of i_OC (with var)
            var := (others => '0'); -- initialize as all 0 for safety
            --var := "11001100110011001100110011001100";  -- 32 bits
            var := x"03579BDF"; -- 32 bits. 8 hex characters

            s_I <= var;  -- assign input
            wait for 10 ns;

            for k in 0 to (N/4)-1 loop  -- loop this
                -- v(N-1)  v(N-2)  ...  v(1)  v(0)
                -- start at v(N-2). End at v(0)
                -- take v(N-1) and add it after v(0)
                -- Doing this moves the bits left 1 and wrap around

                -- & is concatenation
                -- Take bits on the left, concatenate the bits on the right after them
                var := var(N-5 downto 0) & var(N-1 downto N-4);
                s_I <= var;  -- reassign input
                wait for 10 ns;

            end loop;   -- Go back up to "for", or exit
            
            wait;   -- stop wave form from changing when done
        end process;
end architecture;



