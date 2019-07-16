----------------------------------------------------------------------------------
-- Simple FIR filter using systolic form.

-- Initial version: Colm Ryan (cryan@bbn.com)
-- Create Date: 06/05/2015

-- Dependencies:
--
--
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library ieee_proposed;
use ieee_proposed.standard_additions.all;

entity FIR_Systolic is
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
end FIR_Systolic;

architecture Behavioral of FIR_Systolic is

constant NUM_TAPS : natural := coeffs'length;

type multRegs_t is array(0 to NUM_TAPS-1) of signed(42 downto 0); -- MREG is 43 bits
signal multRegs : multRegs_t := (others => (others => '0'));

type chainedSum_t is array(0 to NUM_TAPS-1) of signed(47 downto 0);
signal chainedSum : chainedSum_t := (others => (others => '0'));

type dataRegs_t is array(0 to NUM_TAPS-2) of signed(data_in_width-1 downto 0);
signal dataRegs_1, dataRegs_2 : dataRegs_t := (others => (others => '0'));
signal data_in_d : signed(data_in_width-1 downto 0);

--Vivado does not infer DSP for constant multiplier so force DSP
-- see http://www.xilinx.com/support/answers/60913.html
attribute use_dsp48 : string;
attribute use_dsp48 of chainedSum : signal is "yes";

begin

  main : process(clk)
  begin
    if rising_edge(clk) then
      --register input data and convert to signed for DSP slice
      data_in_d <= signed(data_in);
      -- double register
      dataRegs_1(0) <= data_in_d;
      regLooper1 : for ct in 1 to NUM_TAPS-2 loop
        dataRegs_1(ct) <= dataRegs_2(ct-1);
      end loop;
      regLooper2 : for ct in 0 to NUM_TAPS-2 loop
        dataRegs_2(ct) <= dataRegs_1(ct);
      end loop;

      -- DSP48 coeff and mreg widths are 18 and 43 bits respectively
      multRegs(0) <= resize(data_in_d * to_signed(coeffs(0), 18), 43);
      multLooper : for ct in 1 to NUM_TAPS-1 loop
        multRegs(ct) <= resize(dataRegs_2(ct-1) * to_signed(coeffs(ct), 18), 43);
      end loop;

      --Multiply by coeffs and chain the sum
      --We resize to 18 bits because the DSP slices offer 18x25 bit multipliers
      chainedSum(0) <= resize(multRegs(0), 48);
      sumLooper : for ct in 1 to NUM_TAPS-1 loop
        chainedSum(ct) <= resize(multRegs(ct) + chainedSum(ct-1), 48);
      end loop;

      --register out
      data_out <= std_logic_vector(chainedSum(chainedSum'high));
    end if;
  end process;

end Behavioral;
