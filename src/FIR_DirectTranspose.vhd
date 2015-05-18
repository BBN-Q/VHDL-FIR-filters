----------------------------------------------------------------------------------
-- Simple FIR filter using transposed direct form.

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

entity FIR_DirectTranspose is
  generic(
    --Default 1/4 band low-pass filter generated in Python with
    -- import scipy.signal
    -- br = scipy.signal.remez(16, [0,0.1,0.2,0.5], [1,0])
    coeffs : real_vector := (0.01662606, -0.00696415, -0.03403663, -0.04855056, -0.01434685, 0.08048669,  0.20301046,  0.28957738,  0.28957738,  0.20301046, 0.08048669, -0.01434685, -0.04855056, -0.03403663, -0.00696415, 0.01662606);
    data_in_width : natural := 16;
    data_out_width : natural := 16
  );
  port (
        rst : in std_logic;
        clk : in std_logic;
        data_in : in std_logic_vector(data_in_width-1 downto 0);
        data_in_vld : std_logic;
        data_in_last : std_logic;
        data_out : out std_logic_vector(data_out_width-1 downto 0));
end FIR_DirectTranspose;

architecture Behavioral of FIR_DirectTranspose is

constant NUM_TAPS : natural := coeffs'length;

type chainedSum_t is array(0 to NUM_TAPS-1) of signed(47 downto 0);
signal chainedSum : chainedSum_t := (others => (others => '0'));
--Vivado does not infer DSP for constant multiplier so force DSP
-- see http://www.xilinx.com/support/answers/60913.html
attribute use_dsp48 : string;
attribute use_dsp48 of chainedSum : signal is "yes";

signal data_in_d : signed(data_in_width-1 downto 0) := (others => '0');

--We resize to 18 bits because the DSP slices offer 18x25 bit multipliers
constant COEFF_SCALE : real := real(2 ** 17);

--we resize the sum to 48 bits because the DSP slices offer 48 bit adder accumulators
constant SUM_NUM_BITS : natural := 48;

--The multiplication gives us 18 + data_in_width - 1 bits
--If we assume the coefficients are normalized then we don't need to worry about overflow
constant TOP_OUTPUT_BIT : natural := SUM_NUM_BITS - 1 - (48 - (18 + data_in_width - 1));
constant BOTTOM_OUTPUT_BIT : natural := TOP_OUTPUT_BIT - data_out_width + 1;

begin

  main : process(clk)
  begin
    if rising_edge(clk) then
      --register input data and convert to signed for DSP slice
      data_in_d <= signed(data_in);

      --Multiply by coeffs and chain the sum
      chainedSum(0) <= resize(data_in_d * to_signed(integer(COEFF_SCALE*coeffs(coeffs'high)),18), SUM_NUM_BITS);

      sumLooper : for ct in 1 to NUM_TAPS-1 loop
        chainedSum(ct) <= resize(data_in_d * to_signed(integer(COEFF_SCALE*coeffs(coeffs'high-ct)),18), SUM_NUM_BITS) + chainedSum(ct-1);
      end loop;

      --Slice out the appropriate portion of the output - for now just truncate LSB
      data_out <= std_logic_vector(chainedSum(chainedSum'high)(TOP_OUTPUT_BIT downto BOTTOM_OUTPUT_BIT));
    end if;
  end process;

end Behavioral;
