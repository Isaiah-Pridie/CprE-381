-- Isaiah Pridie
-- CprE 3810 Lab1 Part 3.4
-- Start Date: 2.3.2026, 1:07 AM

library ieee;
use IEEE.std_logic_1164.all;


entity tb_mux2t1_n is
end entity;

architecture BusMux_n of tb_mux2t1_n is 
    constant N : integer := 32;     -- Can change this value to 1, 4, 8, etc
    
    signal s_D0    :    std_logic_vector(N-1 downto 0) := (others => '0');  -- input bus
    signal s_D1    :    std_logic_vector(N-1 downto 0) := (others => '0');  -- input bus
    signal s_S     :    std_logic := '0';   -- Still 1 select bit
    signal s_O     :    std_logic_vector(N-1 downto 0);  -- output bus


    component mux2t1_n is 
        generic ( N : natural := 16 );  -- 16 by default
        port (  i_D0   :   in std_logic_vector(N-1 downto 0);   -- Bus
                i_D1   :   in std_logic_vector(N-1 downto 0);   -- Bus
                i_S    :   in std_logic;                    -- Singular
                o_O    :   out std_logic_vector(N-1 downto 0) );
    end component;

    begin
        DUT: mux2t1_n
            -- Left 'N' is DUT's (Component) generic name. Right side is Signal
            generic map (N => N)  
            port map ( i_D0 => s_D0,
                       i_D1 => s_D1,
                       i_S  => s_S,
                       o_O  => s_O );
        process 
        begin
            -- port <= (other => '0');
                -- Assign port  x  with  'y'
                -- "other" refers to other (all) ports for that bus
            
            -- s_S set to 0
            -- Case 1:
            s_S <= '0';   
            s_D0 <= (others => '0');    s_D1 <= (others => '0');
            wait for 10 ns;

            -- Case 2:
            s_D0 <= (others => '0');    s_D1 <= (others => '1');
            wait for 10 ns;

            -- Case 3:
            s_D0 <= (others => '1');    s_D1 <= (others => '0');
            wait for 10 ns;

            -- Case 4:
            s_D0 <= (others => '1');    s_D1 <= (others => '1');
            wait for 10 ns;

            
            -- s_S changes to 1
            -- Case 5:
            s_S <= '1';   
            s_D0 <= (others => '0');    s_D1 <= (others => '0');
            wait for 10 ns;

            -- Case 6:
            s_D0 <= (others => '0');    s_D1 <= (others => '1');
            wait for 10 ns;

            -- Case 7:
            s_D0 <= (others => '1');    s_D1 <= (others => '0');
            wait for 10 ns;

            -- Case 8:
            s_D0 <= (others => '1');    s_D1 <= (others => '1');
            wait for 10 ns;

            wait;   -- wait forever. Do not update waves
        end process;

end architecture;