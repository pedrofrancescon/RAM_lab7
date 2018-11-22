library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipFlop is
	port( clk: in std_logic;
		  rst: in std_logic;
		  wr_en : in std_logic;
 	  	  estado : out std_logic
	);
end entity;

architecture a_flipFlop of flipFlop is
	signal estado_s: std_logic;
begin
	process(clk,rst,wr_en)
	begin
		if rst='1' then
			estado_s <= '0';
		elsif wr_en='1' then
			if rising_edge(clk) then
				estado_s <= not estado_s;
			end if;
		end if;
	end process;

	estado <= estado_s ;

end architecture;