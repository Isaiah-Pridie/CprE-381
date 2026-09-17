-- Isaiah Pridie
-- CprE 3810 Lab1 Part 3.4
-- Start Date: 2.3.2026, 6:21 AM

library ieee;
use IEEE.std_logic_1164.all;

entity tb_basic_adder_n is
end entity;

architecture SimpleAdder_n of tb_basic_adder_n is
    constant N : integer := 32; -- can change this value to whatever

    -- "input_signal_adder_Bit_0"
    -- "input_signal_Carry"
    signal is_aB0    :   std_logic_vector(N-1 downto 0) := (others => '0');
    signal is_aB1    :   std_logic_vector(N-1 downto 0) := (others => '0');
    signal c_in      :   std_logic := '0';  -- carry in bit
    signal os_S      :   std_logic_vector(N-1 downto 0);
    signal os_C      :   std_logic;         -- carry out bit

    component basic_adder_n is
        generic ( N : natural := 4); -- 4 by default
        port (  i_aB0   :   in std_logic_vector(N-1 downto 0);
                i_aB1   :   in std_logic_vector(N-1 downto 0);
                o_S     :   out std_logic_vector(N-1 downto 0);
                -- Next two are not controlled through a bus. They are used
                -- inside of the adder. Thus, don't need "(N-1 downto 0)"
                i_C     :   in std_logic;  -- I am not supply a bus of inputs to this
                o_C     :   out std_logic   ); -- I am not supplying 

    end component;

    begin
        DUT: basic_adder_n
            -- Left N is DUT (Component). Right N is Architecture (Signal)
            generic map(N => N)
            port map (  i_aB0   =>  is_aB0,
                        i_aB1   =>  is_aB1,
                        o_S     =>  os_S,
                        i_C     =>  c_in,
                        o_C     =>  os_C    );
        process
        variable var : std_logic_vector(N-1 downto 0);  -- cover entire bus dynamically
        begin  

            -- load initial signals for test values:
            c_in    <=  '0';    -- input Carry assigned to 0 initially
            is_aB0  <=  (others => '0');    -- initialize every input as 0 to start
            is_aB1  <=  (others => '0');

            ----------   Test Case 1:   ----------
                -- set only aB0 bus to 10101010... 
            for k in 0 to N-1 loop
                if (k mod 2 = 0) then
                    var(k) := '0';
                else
                    var(k) := '1';
                end if;
            end loop;
                
            is_aB0  <= var;    -- assign input
            wait for 10 ns;
            -- expecting  <-...101010  +  ...0000  =  ...101010


            ----------   Test Case 2:   ----------
                -- add  1010  +  01010  =  1111
            for k in 0 to N-1 loop
                if (var(k) = '1') then
                    var(k) := '0';
                else    -- it is 0 -> set to 1
                    var(k) := '1';
                end if;
            end loop;

            is_aB1  <= var;  -- assign input
            wait for 10 ns;
            -- expecting  <-...101010  +  <-...010101  =  ...111111


            ----------   Test Case 3:   ----------
                -- add  0000 ... 0001  +  ...00001  =  100...000
            -- 0111...1111
            is_aB0      <= (others => '1');  -- set all to 1
            is_aB0(N-1) <= '0';         -- set MSB to 0

            -- 0000...0001
            is_aB1      <= (others => '0');  -- set all to 0
            is_aB1(0)   <= '1';           -- set LSB to 1

            wait for 10 ns;
            -- expecting  1000...0000

            ----------   Test Case 4:   ----------
                -- Test carry in bit AND carry out bit
                -- Add  100...  +  100..  +  Carry_In=1

            is_aB0      <= (others => '0');  -- set all to 0
            is_aB0(N-1) <= '1';     -- set MSB to 1

            is_aB1      <= (others => '0');  -- set all to 0
            is_aB1(N-1) <= '1';     -- set MSB to 1

            c_in        <= '1';     -- set carry in bit to 1
            wait for 10 ns;
            -- Expecting Carry_out to be 1. Expecting LSB to be 1

            wait;   -- stop all wave changes
        end process;
end architecture;






