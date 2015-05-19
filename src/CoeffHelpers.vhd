library ieee;
use ieee.math_real.all;

library ieee_proposed;
use ieee_proposed.standard_additions.all;

package CoeffHelpers is

  function optimum_scaling(coeffs : real_vector) return integer;
  function scale_coeffs(coeffs : real_vector; scale : real) return integer_vector;

end package;

package body CoeffHelpers is

  -- Determine the optimum power of two scaling for filter coefficients
  -- to make the fixed point representation with minimum leading zeros
  function optimum_scaling(coeffs : real_vector) return integer is
  begin
    return integer(trunc(log2(maximum(coeffs))));
  end optimum_scaling;

  -- Scale a real ceofficient vector and convert to integers
  function scale_coeffs(coeffs : real_vector; scale : real) return integer_vector is
    variable result_vec : integer_vector(0 to coeffs'length-1);
  begin
    for ct in coeffs'range loop
      result_vec(ct) := integer(scale*coeffs(ct));
    end loop;
    return result_vec;
  end scale_coeffs;

end CoeffHelpers;
