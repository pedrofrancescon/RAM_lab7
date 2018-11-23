library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port( clk : in std_logic;
		  endereco : in unsigned(15 downto 0);
		  dado : out unsigned(14 downto 0) --instrução
		);
end entity;

architecture a_rom of rom is
	type mem is array (0 to 2047) of unsigned(14 downto 0);
	constant conteudo_rom : mem := (
		0=> "000000000000000",  -- NOP
		1=> "001000100000000",  -- ADD reg1,0
		2=> "001001000011110",  -- ADD reg2,30
		3=> "011101000101010",  -- ST.W reg2,10[reg1] # salva 30 no endereço 10
		4=> "001001100000101",  -- ADD reg3,5
		5=> "100110001100101",  -- LD.W 5[reg3],reg4 # valor da RAM no endr 10 => reg4
		6=> "010111110000000",  -- MOV reg7,reg4
		7=> "011111100100001",  -- ST.W reg7,1[reg1]
		8=> "001000100000001",  -- ADD reg1,1
		9=> "100111000100000",  -- LD.W 0[reg1],reg6
		10=> "010101011000000",  -- MOV reg2,reg6
		11=> "010100101000000",  -- MOV reg1,reg2
		others => (others=>'0')
	);
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			dado <= conteudo_rom(to_integer(endereco));
		end if;
	end process;
end architecture;
