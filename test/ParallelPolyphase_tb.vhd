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

entity ParallelPolyphase_tb is
--  Port ( );
end ParallelPolyphase_tb;

architecture Behavioral of ParallelPolyphase_tb is

signal rst : std_logic := '0';
signal clk : std_logic := '0';
signal finished : boolean := false;

signal data_out : std_logic_vector(15 downto 0);

begin

  dut : entity work.ParallelPolyphase
    port map (
      rst => rst,
      clk => clk,
      data_in => (others => '0'),
      data_in_vld => '0',
      data_in_last => '0',
      data_out => data_out);

  stim : process
  begin
    wait for 1us;
    finished <= true;
  end process;

  --clock generation
  clk <= not clk after 10ns when not finished;

end Behavioral;
