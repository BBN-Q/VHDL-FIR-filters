----------------------------------------------------------------------------------
-- Testbench for ParallelPolyphase

-- Initial version: Colm Ryan (cryan@bbn.com)
-- Create Date: 05/05/2015

-- Dependencies:
--
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library ieee_proposed;
use ieee_proposed.standard_additions.all;
use work.TestVectors.all;

entity FIR_tb is
--  Port ( );
end FIR_tb;

architecture Behavioral of FIR_tb is

constant coeffs : real_vector := (0.01662606, -0.00696415, -0.03403663, -0.04855056, -0.01434685, 0.08048669,  0.20301046,  0.28957738,  0.28957738,  0.20301046, 0.08048669, -0.01434685, -0.04855056, -0.03403663, -0.00696415, 0.01662606);

signal rst : std_logic := '0';
signal clk : std_logic := '0';
signal finished : boolean := false;

signal data_in : std_logic_vector(15 downto 0) := (others => '0');
signal data_out : std_logic_vector(15 downto 0);

constant scale : real := real(2 ** 15) - 1.0;

begin

  dut : entity work.FIR_DirectTranspose
    generic map(coeffs => coeffs, data_in_width=>16, data_out_width=>16)
    port map (
      rst => rst,
      clk => clk,
      data_in => data_in,
      data_in_vld => '0',
      data_in_last => '0',
      data_out => data_out);

  stim : process
  begin
    rst <= '1';
    wait for 100ns;
    rst <= '0';

    wait until rising_edge(clk);
    sampleDriver : for ct in 0 to chirp'high loop
      data_in <= std_logic_vector(to_signed(integer(scale*chirp(ct)), 16));
      wait until rising_edge(clk);
    end loop;
    data_in <= (others => '0');

    wait for 1us;
    finished <= true;
  end process;

  --clock generation
  clk <= not clk after 10ns when not finished;

end Behavioral;
