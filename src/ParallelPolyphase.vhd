----------------------------------------------------------------------------------
-- Polyphase decimation for a parallel data stream such as an ADC

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

entity ParallelPolyphase is
  port ( rst : in std_logic;
       clk : in std_logic;
       data_in : in std_logic_vector(47 downto 0);
       data_in_vld : std_logic;
       data_in_last : std_logic;
       data_out : out std_logic_vector(15 downto 0));
end ParallelPolyphase;

architecture Behavioral of ParallelPolyphase is

begin

  data_out <= std_logic_vector(resize(signed(data_in(11 downto 0)), 16));

end Behavioral;
