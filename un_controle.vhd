library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
	port(clk: in std_logic;
         rst: in std_logic;
		 pc_wr_en: out std_logic;
		 regs_wr_en: out std_logic;
		 ram_wr_en: out std_logic;
         jump_en: out std_logic;
		 origemJump: out std_logic;
		 flagsRst: out std_logic;
		 operacao: out unsigned(1 downto 0);
		 reg1OuConst: out std_logic; -- ADD e SUB
		 reg2OuConst: out std_logic; -- ADDI e LD.W
		 ulaOuRam: out std_logic;
		 opcode: in unsigned(3 downto 0)
	);
end entity;

architecture a_un_controle of un_controle is

	component maquinaEst -- flipflop_T substituido por maquina de estados
	port( clk: in std_logic;
		  rst: in std_logic;
		  opcode : in unsigned(3 downto 0);
		  estado : out unsigned(1 downto 0)
	);
   	end component;

	signal estado: unsigned(1 downto 0);
    begin

    maqEstados: maquinaEst port map(clk=>clk, rst=>rst, opcode=>opcode, estado=>estado);

    jump_en <= '1' when opcode="0110" and estado="00" else
    		   '0'; 

    pc_wr_en <= '1' when estado="00" else
    			'0';

	--regs_wr_en <= '1' when estado="10" and not opcode="0111" else -- aqui mudei pra ele não escrever nada nos regs acidentalmente quando for escrever na RAM
 --   			  '1' when estado="01" and not opcode="0111" else
 --   			  '0';

    regs_wr_en <= '1' when estado="10" else -- aqui mudei pra ele não escrever nada nos regs acidentalmente quando for escrever na RAM
    			  '1' when estado="01" else
    			  '0';

	origemJump <= '1' when opcode="0110" else
	'0';

	operacao <= "00" when opcode="0001" or opcode="0010" or opcode="1101" or opcode="0101" or opcode="1001" or opcode="0111" else --soma
	 			"01" when opcode="0011" or opcode="0100" else -- subtracao
	 			"11";

	reg1OuConst <=  '0' when estado="01" else --R
					'1' when estado="10" else --I
					'0';

	reg2OuConst <=  '1' when opcode="1001" or opcode="1101" or opcode="0111" or opcode="0101" else -- operações "especiais" pois lidam com os dois regs e com constante
					'0';	

	ulaOuRam <= '1' when opcode="1001" else -- origem do dado de entrada do banco de regs
				'0';

	ram_wr_en <= '1' when opcode="0111" and estado="01" else 
				'0';

	flagsRst <= '1' when estado="10" and opcode="1010" else
				'1' when rst='1' else 
				'0';

end architecture;
