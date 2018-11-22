library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux1bit is
	 port(   saida0 : out std_logic;
			 saida1 : out std_logic;
			 saida2 : out std_logic;
			 saida3 : out std_logic;
			 saida4 : out std_logic;
			 saida5 : out std_logic;
			 saida6 : out std_logic;
			 saida7 : out std_logic;
			 sel : in unsigned(2 downto 0);
			 enable : std_logic
			 );
end entity;

architecture a_demux1bit of demux1bit is
begin

	 saida0 <= '1' when sel="000" and enable='1' else
	 '0';
	 saida1 <= '1' when sel="001" and enable='1' else
	 '0';
	 saida2 <= '1' when sel="010" and enable='1' else
	 '0';
	 saida3 <= '1' when sel="011" and enable='1' else
	 '0';
	 saida4 <= '1' when sel="100" and enable='1' else
	 '0';
	 saida5 <= '1' when sel="101" and enable='1' else
	 '0';
	 saida6 <= '1' when sel="110" and enable='1' else
	 '0';
	 saida7 <= '1' when sel="111" and enable='1' else
	 '0';

end architecture;
