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

use work.DataTypes.all;

entity FIR_tb is
--  Port ( );
end FIR_tb;

architecture Behavioral of FIR_tb is
  
constant coeffs : integer_vector := (2179, -913,  -4461,  -6364,  -1880,  10550,  26609, 37955,  37955,  26609,  10550,  -1880,  -6364, -4461, -913, 2179);

signal rst : std_logic := '0';
signal clk : std_logic := '0';
signal finished : boolean := false;

signal data_in : std_logic_vector(15 downto 0) := (others => '0');
signal data_out : std_logic_vector(47 downto 0);

constant testData : integer_vector(0 to 2047) := (0,49,148,296,493,740,1035,1380,1774,2217,2709,3249,3837,4473,5156,5885,
6659,7477,8339,9241,10183,11162,12175,13221,14295,15394,16513,17649,18796,19949,21102,22248,
23380,24491,25572,26615,27611,28550,29422,30218,30925,31534,32033,32412,32659,32764,32716,32505,
32122,31558,30805,29858,28712,27363,25809,24052,22094,19940,17597,15077,12393,9560,6599,3531,
382,-2819,-6042,-9253,-12415,-15491,-18441,-21224,-23799,-26125,-28161,-29868,-31211,-32155,-32672,-32737,
-32332,-31446,-30073,-28218,-25893,-23120,-19930,-16364,-12473,-8315,-3960,517,5033,9501,13827,17918,
21681,25023,27860,30111,31708,32594,32725,32077,30643,28435,25488,21857,17619,12871,7730,2329,
-3187,-8659,-13927,-18826,-23198,-26892,-29776,-31736,-32685,-32565,-31354,-29067,-25757,-21515,-16471,-10791,
-4669,1675,8004,14072,19634,24457,28329,31069,32536,32642,31351,28689,24744,19666,13660,6986,
-60,-7152,-13949,-20114,-25331,-29318,-31849,-32765,-31986,-29520,-25465,-20009,-13425,-6056,1699,9405,
16618,22908,27885,31229,32706,32193,29684,25301,19289,12005,3900,-4508,-12664,-20016,-26049,-30325,
-32517,-32434,-30044,-25481,-19039,-11164,-2416,6560,15086,22499,28204,31727,32752,31159,27034,20676,
12577,3386,-6137,-15184,-22969,-28794,-32116,-32604,-30171,-24993,-17506,-8365,1599,11460,20278,27191,
31500,32746,30764,25704,18034,8496,-1956,-12253,-21316,-28172,-32061,-32525,-29467,-23174,-14297,-3791,
7186,17397,25662,31005,32764,30687,24970,16249,5536,-5894,-16649,-25392,-31009,-32755,-30360,-24079,
-14674,-3326,8502,19255,27489,32069,32331,28188,20157,9304,-2889,-14722,-24513,-30837,-32744,-29905,
-22682,-12088,341,12764,23308,30348,32766,30138,22815,11893,-945,-13678,-24266,-30976,-32677,-29035,
-20592,-8700,4688,17333,27079,32230,31851,25948,15496,2283,-11377,-23055,-30632,-32696,-28815,-19639,
-6809,7328,20140,29200,32751,30060,21583,8903,-5552,-18963,-28674,-32717,-30229,-21648,-8654,6146,
19729,29277,32767,29409,19846,6048,-9082,-22307,-30752,-32537,-27209,-15875,-992,14156,26173,32319,
31145,22852,9283,-6472,-20765,-30239,-32619,-27278,-15421,166,15757,27568,32683,29790,19532,4394,
-11882,-25217,-32214,-31040,-21925,-7148,9518,23752,31810,31519,22888,8143,-8819,-23453,-31777,-31475,
-22559,-7413,9824,24371,32137,30883,20890,4932,-12477,-26342,-32628,-29448,-17656,-649,16591,28948,
32695,26642,12537,-5403,-21739,-31454,-31503,-21798,-5286,12919,27104,32756,28013,14314,-4012,-21086,
-31362,-31441,-21222,-3993,14596,28375,32702,26056,10601,-8485,-24721,-32525,-29150,-15684,3264,21114,
31591,30949,19336,811,-18044,-30452,-31883,-21744,-3651,15818,29504,32303,23101,5251,-14606,-28999,
-32439,-23542,-5628,14485,29050,32386,23118,4789,-15460,-29647,-32107,-21781,-2720,17473,30652,31424,
19396,-593,-20378,-31788,-30038,-15772,5120,23901,32631,27544,10720,-10721,-27598,-32602,-23492,-4143,
17053,30805,31006,17483,-3837,-23484,-32638,-27116,-9324,12734,29027,32059,20358,-764,-21569,-32371,
-28060,-10570,11934,28830,32054,19989,-1675,-22571,-32601,-26837,-7994,14791,30354,30982,16280,-6537,
-26131,-32672,-22795,-1394,20750,32373,27479,8484,-14911,-30637,-30492,-14463,9156,28007,32129,19260,
-3859,-24958,-32735,-22937,-755,21872,32650,25635,4574,-19035,-32180,-27526,-7565,16649,31576,28779,
9740,-14844,-31028,-29537,-11131,13701,30667,29905,11766,-13262,-30566,-29941,-11663,13543,30744,29648,
10818,-14534,-31168,-28983,-9210,16199,31747,27850,6809,-18468,-32335,-26113,-3585,21220,32725,23607,
-463,-24273,-32649,-20159,5284,27360,31789,15616,-10738,-30119,-29800,-9896,16561,32096,26343,3035,
-22334,-32758,-21154,4747,27467,31549,14123,-12988,-31220,-27974,-5394,20955,32763,21723,-4539,-27647,
-31302,-12832,14763,31888,26270,1831,-23954,-32506,-17563,10140,30497,28614,5772,-21340,-32756,-19966,
7649,29606,29491,7294,-20408,-32767,-20374,7480,29679,29262,6451,-21339,-32730,-18855,9645,30682,
27827,3210,-23953,-32303,-15174,13985,32075,24645,-2477,-27645,-30629,-8932,20009,32760,18886,-10407,
-31219,-26441,100,26587,31096,9795,-19685,-32758,-18410,11417,31658,25174,-2648,-28249,-29802,-5885,
23102,32259,13615,-16821,-32703,-20164,9971,31418,25332,-3040,-28759,-29067,-3593,25102,31435,9655,
-20807,-32584,-14980,16191,32706,19488,-11519,-32020,-23173,6995,30741,26082,-2768,-29071,-28294,-1062,
27191,29910,4439,-25251,-31038,-7336,23378,31786,9752,-21669,-32249,-11697,20200,32515,13190,-19025,
-32652,-14254,18182,32713,14905,-17697,-32735,-15158,17583,32735,15016,-17842,-32711,-14476,18468,32646,
13529,-19443,-32504,-12158,20737,32230,10341,-22307,-31753,-8058,24090,30988,5296,-26002,-29836,-2051,
27935,28190,-1657,-29753,-25942,5781,31294,22993,-10235,-32368,-19264,14884,32767,14711,-19540,-32272,
-9343,23954,30671,3245,-27823,-27787,3412,30798,23498,-10350,-32504,-17781,17182,32575,10741,-23417,
-30702,-2645,28485,26685,-6057,-31782,-20500,14728,32742,12356,-22573,-30920,-2744,28701,26102,-7551,
-32222,-18399,17473,32390,8338,-25787,-28759,3115,31226,21346,-14583,-32703,-10755,24417,29551,-1774,
-30925,-21764,14439,32687,10160,-25087,-28912,3579,31584,19754,-17063,-32277,-6503,27564,26486,-8456,
-32583,-14881,21983,30515,-392,-30809,-21245,15965,32379,6492,-27911,-25704,10309,32755,11949,-24684,
-28594,5505,32289,15981,-21715,-30318,1807,31516,18719,-19394,-31249,-682,30829,20322,-17956,-31669,
-1939,30472,20917,-17520,-31738,-1964,30552,20554,-18120,-31485,-758,31047,19203,-19709,-30807,1682,
31801,16752,-22153,-29474,5332,32516,13047,-25193,-27148,10094,32749,7940,-28412,-23429,15723,31917,
1388,-31190,-17936,21739,29350,-6433,-32700,-10437,27358,24398,-14992,-31969,-1032,31467,16628,-23287,
-28039,9645,32717,6089,-29818,-20259,20262,29776,-6383,-32745,-8694,28778,21781,-18948,-30293,5449,
32717,8944,-28818,-21458,19576,29848,-6888,-32767,-6852,29924,19228,-22039,-28218,10627,32495,2329,
-31584,-14738,25847,24744,-16352,-30982,4642,32733,7539,-29958,-18514,23240,26894,-13635,-31734,2485,
32608,8782,-29609,-18839,23274,26610,-14480,-31362,4298,32753,6143,-30821,-15787,25935,23751,-18722,
-29392,9968,32339,-525,-32498,-8772,30021,17184,-25265,-24114,18731,29143,-11006,-32035,2703,32734,
5588,-31341,-13339,28088,20120,-23297,-25607,17351,29592,-10655,-31977,3609,32767,3416,-32050,-10097,
29981,16168,-26760,-21427,22619,25739,-17797,-29025,12532,31266,-7048,-32485,1543,32746,3810,-32139,
-8872,30772,13534,-28766,-17720,26245,21382,-23329,-24498,20136,27067,-16769,-29106,13323,30647,-9878,
-31730,6502,32405,-3249,-32724,160,32741,2734,-32509,-5412,32082,7862,-31507,-10079,30830,12062,
-30072,-13996,29128,16044,-27950,-18177,26506,20359,-24766,-22547,22703,24688,-20297,-26724,17532,28588,
-14402,-30205,10915,31495,-7089,-32374,2962,32757,1409,-32561,-5950,31710,10562,-30139,-15126,27799,
19501,-24667,-23530,20747,27043,-16080,-29861,10749,31807,-4881,-32718,-1350,32452,7724,-30906,-13979,
28030,19818,-23836,-24925,18414,28979,-11939,-31676,4672,32756,3037,-32026,-10764,29391,18029,-24874,
-24324,18637,29150,-10990,-32059,2392,32701,6572,-30873,-15217,26559,22811,-19960,-28634,11510,32056,
-1862,-32615,-8147,30083,17555,-24532,-25370,16364,30677,-6309,-32755,-4619,31192,15208,-25975,-24178,
17545,30336,-6791,-32754,-5011,30925,16333,-24887,-25588,15283,31358,-3333,-32628,-9290,28997,20676,
-20807,-28965,9168,32665,4146,-30953,-16940,23890,26951,-12504,-32258,-1310,31683,15059,-25093,-26090,
13532,32113,879,-31704,-15289,24700,26654,-12343,-32398,-2861,31036,17602,-22613,-28468,8833,32756,
7207,-29194,-21667,18385,30874,-2813,-32288,-13654,25272,26684,-11422,-32630,-5698,29612,21398,-18190,
-31141,1397,31885,15974,-23123,-28698,7229,32708,11065,-26473,-26018,11685,32676,7065,-28588,-23627,
14817,32287,4177,-29803,-21872,16739,31898,2485,-30378,-20958,17557,31727,2018,-30460,-20978,17327,
31852,2781,-30073,-21928,16033,32217,4765,-29112,-23714,13593,32627,7932,-27356,-26125,9890,32745,
12175,-24491,-28807,4827,32097,17253,-20163,-31226,-1590,30097,22715,-14072,-32658,-9136,26124,27835,
-6101,-32222,-17244,19663,31588,3496,-28997,-24905,10520,32717,13919,-22264,-30661,-903,29958,23691,
-11852,-32758,-13348,22435,30717,1458,-29560,-24600,10215,32637,15614,-20219,-31713,-5148,27562,27331,
-5467,-31744,-20352,15117,32714,11767,-22993,-30773,-2554,28626,26459,-6436,-31851,-20430,14544,32760,
13362,-21323,-31625,-5879,26532,28827,-1497,-30109,-24796,8368,32130,19955,-14466,-32767,-14688,19639,
32250,9319,-23836,-30833,-4102,27084,28769,-781,-29462,-26293,5208,31086,23609,-9115,-32088,-20891,
12476,32604,18275,-15298,-32766,-15868,17610,32691,13746,-19449,-32484,-11967,20858,32228,10567,-21876,
-31991,-9570,22537,31820,8991,-22866,-31745,-8837,22875,31778,9110,-22564,-31915,-9806,21921,32131,
10917,-20923,-32386,-12426,19537,32622,14306,-17722,-32759,-16513,15437,32702,18988,-12643,-32338,-21644,
9312,31541,24368,-5435,-30174,-27012,1034,28104,29396,3826,-25205,-31304,-9030,21382,32496,14396,
-16586,-32716,-19676,10835,31714,24550,-4239,-29273,-28636,-2981,25244,31511,10478,-19583,-32748,-17776,
12401,31958,24287,-3993,-28863,-29348,-5135,23360,32281,14265,-15597,-32492,-22503,6026,29571,28855,
4563,-23420,-32349,-15070,14357,32194,24172,-3183,-27968,-30480,-8819,19788,32767,19983,-8441,-30239,
-28468,-4600,22799,32577,17289,-11238,-31141,-27291,-2715,23888,32426,16551,-11722,-31194,-27387,-3231,
23289,32578,17872,-9930,-30434,-28721,-6134,20869,32767,21060,-5744,-28406,-30787,-11285,16186,32193,
25523,957,-24247,-32520,-18192,8712,29569,30061,9945,-16941,-32254,-25654,-1709,23357,32694,20122,
-5864,-27914,-31427,-14170,12396,30789,29020,8336,-17735,-32288,-25989,-2988,21895,32762,22766,-1654,
-24993,-32560,-19682,5486,27200,31991,16978,-8484,-28695,-31306,-14812,10664,29642,30698,13287,-12062,
-30170,-30298,-12460,12713,30364,30179,12357,-12633,-30256,-30363,-12983,11821,29828,30818,14316,-10254,
-29010,-31456,-16310,7897,27684,32134,18877,-4717,-25695,-32646,-21875,702,22865,32728,25088,4107,
-19017,-32059,-28212,-9584,14016,30288,30843,15481,-7812,-27067,-32486,-21394,504,22111,32582,26745,
7599,-15283,-30576,-30797,-15926,6693,26019,32714,23622,3202,-18714,-31677,-29590,-13527,8872,27073,
32609,22981,2736,-18734,-31567,-29950,-14706,7174,25777,32762,25073,6227,-15347,-30101,-31585,-19231,
1488,21521,32210,29011,13382,-7929,-25830,-32767,-25887,-8163,12935,28614,32420,22859,3939,-16552,
-30273,-31713,-20370,-879,18924,31164,31047,18699,-957,-20199,-31553,-30679,-17994,1560,20479,31583,
30726,18313,-932,-19788,-31265,-31175,-19629,-930,18068,30480,31877,21833,4014,-15192,-28984,-32544,
-24698,-8261,11006,26431,32743,27851,13496,-5393,-22424,-31902,-30722,-19353,-1620,16603,29360,32540,
25186,9743,-8785,-24470,-32363,-30031,-18284,-857,16794,29216,32630,26062,11585,-6362,-22351,-31611,
-31437,-21953,-6025,11629,25850,32543,29836,18580,2052,-15016,-27804,-32759,-28560,-16445,177,16708,
28637,32761,28032,15791,-633,-16846,-28570,-32766,-28402,-16680,-686,15441,27587,32705,29566,19025,
3772,-12373,-25427,-32220,-31153,-22551,-8550,7457,21647,30683,32489,26706,14745,-583,-15733,-27256,
-32575,-30549,-21697,-8049,7336,21067,30161,32691,28172,17636,3381,-11546,-24004,-31415,-32291,-26513,
-15326,-1057,13381,25089,31758,32116,26153,15097,1144,-12986,-24582,-31463,-32375,-27205,-16978,-3639,
10325,22358,30294,32745,29329,20712,8468,-5218,-17951,-27539,-32370,-31670,-25617,-15283,-2437,10768,
22158,29894,32762,30354,23110,12231,-531,-13166,-23715,-30581,-32756,-29964,-22678,-12037,346,12633,
23033,30063,32754,30771,24449,14725,2990,-9112,-19921,-27983,-32246,-32185,-27860,-19890,-9359,2341,
13693,23259,29853,32687,31456,26361,18073,7633,-3678,-14505,-23578,-29858,-32654,-31690,-27123,-19516,
-9760,1035,11670,20989,28002,31991,32574,29735,23816,15470,5582,-4827,-14704,-23076,-29140,-32338,
-32401,-29368,-23570,-15589,-6200,3714,13243,21532,27860,31696,32741,30946,26507,19842,11544,2329,
-7032,-15772,-23198,-28735,-31978,-32708,-30909,-26759,-20608,-12951,-4376,4472,12949,20453,26470,30603,
32596,32350,29919,25503,19428,12119,4071,-4191,-12140,-19287,-25205,-29556,-32107,-32737,-31446,-28343,
-23639,-17630,-10675,-3177,4447,11784,18450,24109,28489,31389,32694,32370,30465,27103,22475,16822,
10430,3606,-3333,-10076,-16330,-21836,-26375,-29776,-31923,-32756,-32270,-30515,-27585,-23622,-18798,-13313,
-7383,-1234,4910,10835,16341,21251,25416,28717,31068,32419,32752,32082,30456,27946,24647,20676,
16163,11245,6069,779,-4483,-9581,-14392,-18805,-22722,-26064,-28770,-30796,-32116,-32722,-32623,-31841,
-30415,-28393,-25834,-22805,-19379,-15635,-11650,-7504,-3276,959,5129,9168,13015,16617,19928,22907,
25524,27755,29582,30997,31996,32583,32767,32561,31984,31058,29808,28263,26450,24402,22150,19726,
17161,14485,11730,8924,6093,3264,459,-2300,-4995,-7607,-10122,-12527,-14811,-16966,-18985,-20863,
-22597,-24184,-25624,-26919,-28071,-29082,-29958,-30702,-31321,-31820,-32206,-32485,-32666,-32755,-32759,-32686,
-32543,-32337,-32075,-31764,-31411,-31023,-30604,-30161,-29700,-29226,-28743,-28257,-27771,-27290,-26817,-26356,
-25910,-25481,-25073,-24688,-24328,-23995,-23691,-23417,-23174,-22964,-22787,-22645,-22538,-22466,-22431,-22431);

begin

  dut : entity work.FIR_DirectTranspose
    generic map(coeffs => coeffs, data_in_width=>16)
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
    sampleDriver : for ct in 0 to testData'high loop
      data_in <= std_logic_vector(to_signed(testData(ct), 16));
      wait until rising_edge(clk);
    end loop;
    data_in <= (others => '0');

    wait for 1us;
    finished <= true;
  end process;

  --clock generation
  clk <= not clk after 10ns when not finished;

end Behavioral;
