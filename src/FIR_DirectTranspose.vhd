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

-- synthesis translate off
use work.DataTypes.all;
-- synthesis translate on

entity FIR_DirectTranspose is
  generic(
    coeffs : integer_vector := (2,3,4,5,6);
    data_in_width : natural := 16
  );
  port (
        rst : in std_logic;
        clk : in std_logic;
        data_in : in std_logic_vector(data_in_width-1 downto 0);
        data_in_vld : std_logic;
        data_in_last : std_logic;
        data_out : out std_logic_vector(47 downto 0));
end FIR_DirectTranspose;

architecture Behavioral of FIR_DirectTranspose is

constant NUM_TAPS : natural := coeffs'length;

type chainedSum_t is array(0 to NUM_TAPS-1) of signed(47 downto 0);
signal chainedSum : chainedSum_t := (others => (others => '0'));

signal data_in_d : signed(data_in_width-1 downto 0) := (others => '0');
--Vivado does not infer DSP for constant multiplier so force DSP
-- see http://www.xilinx.com/support/answers/60913.html
attribute use_dsp48 : string;
attribute use_dsp48 of chainedSum : signal is "yes";

begin

  main : process(clk)
  begin
    if rising_edge(clk) then
      --register input data adn convert to signed for DSP slice
      data_in_d <= signed(data_in);

      --Multiply by coeffs and chain the sum
      --We resize to 18 bits because the DSP slices offer 18x25 bit multipliers
      chainedSum(0) <= resize(data_in_d * to_signed(coeffs(coeffs'high),18), 48);

      sumLooper : for ct in 1 to NUM_TAPS-1 loop
        chainedSum(ct) <= resize(data_in_d * to_signed(coeffs(coeffs'high-ct),18), 48) + chainedSum(ct-1);
      end loop;

      data_out <= std_logic_vector(chainedSum(chainedSum'high));
    end if;
  end process;

end Behavioral;
