library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pc16bits is
	port( clk: in std_logic;
		  rst: in std_logic;
		  wr_en: in std_logic;
		  jump_en: in std_logic;
		  data_in: in unsigned(15 downto 0);
		  data_out: out unsigned(15 downto 0)
	);
end entity;

architecture a_pc16bits of pc16bits is
	component reg16bits
	    port( clk: in std_logic;
		  	  rst: in std_logic;
		  	  wr_en: in std_logic;
		  	  data_in: in unsigned(15 downto 0);
		  	  data_out: out unsigned(15 downto 0)
			);
    end component;

	component mux16b_2in
	port(entr0 : in unsigned(15 downto 0);
		 entr1 : in unsigned(15 downto 0);
		 sel : in std_logic;
		 saida : out unsigned(15 downto 0)
		 );
	end component;

    signal data_i: unsigned(15 downto 0);
    signal data_in_aux: unsigned(15 downto 0);
	signal selecionado: unsigned(15 downto 0);
    signal data_o: unsigned(15 downto 0);

    begin
		reg: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en, data_in=>selecionado, data_out=>data_o);

		esc: mux16b_2in port map(entr0=>data_i, entr1=>data_in, sel=>jump_en, saida=>selecionado);

		data_in_aux <= data_in;

		data_i <= data_o+data_in_aux;
		data_out <= data_o;

end architecture;
