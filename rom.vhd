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
		-- Lab 5

		--0=> "000000000000000",  -- NOP
		--1=> "001001100000101",  -- ADD reg3,5
		--2=> "001010000001000",  -- ADD reg4,8
		--3=> "000101110000000",  -- ADD reg3,reg4
		--4=> "010110101100000",  -- MOV reg5,reg3
		--5=> "010010100000001",  -- SUB reg5,1
		--6=> "001011000010100",  -- ADD reg6,20
		--7=> "011011000000000",  -- SWITCH reg6
		--20=> "010101110100000", -- MOV reg3,reg5
		--21=> "001011100000011", -- ADD reg7,3
		--22=> "011011100000000", -- SWITCH reg7

		-- Lab 6

		0=> "000000000000000",  -- NOP
		1=> "001001100000000",  -- ADD reg3,0
		2=> "001010000000000",  -- ADD reg4,0
		3=> "000110001100000",  -- ADD reg4,reg3
		4=> "110001101100001",  -- ADDI reg3,reg3,1
		5=> "010110101100000",  -- MOV reg5,reg3
		6=> "010010100000010",  -- SUB reg5,2 //coloquei 2 ao invés de 30 p/ os testes ficarem mais curtos
		7=> "101011111111101",  -- BL -3
		8=> "010110110000000",  -- MOV reg5,reg4

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
