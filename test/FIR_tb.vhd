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
use ieee.math_real.all;

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
signal data_out, data_check : std_logic_vector(15 downto 0) := (others => '0');

constant DATA_IN_WIDTH : natural := 16;
constant DATA_IN_SCALE : real := real(2 ** (DATA_IN_WIDTH-1)) - 1.0;

constant DATA_OUT_WIDTH : natural := 16;
constant DATA_OUT_SCALE : real := real(2 ** (DATA_OUT_WIDTH-1)) - 1.0;

constant FILTER_DELAY : natural := 1;

begin

  dut : entity work.FIR_DirectTranspose
    generic map(coeffs => coeffs, data_in_width=>DATA_IN_WIDTH, data_out_width=>DATA_OUT_WIDTH)
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
    wait until rising_edge(clk);
    rst <= '0';
    wait until rising_edge(clk);
    sampleDriver : for ct in chirp'range loop
      data_in <= std_logic_vector(to_signed(integer(DATA_IN_SCALE*chirp(ct)), 16));
      wait until rising_edge(clk);
    end loop;
    data_in <= (others => '0');

    wait for 1us;
    finished <= true;
  end process;

  check : process
  variable curOutput : real;
  begin
    wait for 100ns;
    wait until rising_edge(clk);
    wait until rising_edge(clk);

    for ct in 0 to FILTER_DELAY loop
      wait until rising_edge(clk);
    end loop;
    for ct in 0 to chirp'high + coeffs'high loop
      curOutput := 0.0;
      for tap in coeffs'range loop
        if (ct-tap >= 0) and (ct-tap <= chirp'high) then
          curOutput := curOutput + chirp(ct-tap)*coeffs(tap);
        end if;
      end loop;
      data_check <= std_logic_vector(to_signed(integer(trunc(DATA_OUT_SCALE * curOutput)), 16));
      --Arbitrarly allow 2 differences due to fixed point errors
      assert abs(signed(data_check) - signed(data_out)) <= 2 report "FIR filter output incorrect!";
      wait until rising_edge(clk);
    end loop;
    data_check <= (others => '0');

    wait for 1us;

  end process;


  --clock generation
  clk <= not clk after 10ns when not finished;

end Behavioral;
