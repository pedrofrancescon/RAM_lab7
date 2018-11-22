library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank8regs is
	port ( selOut1: in unsigned(2 downto 0);
		   selOut2: in unsigned(2 downto 0);
		   dataIn: in unsigned(15 downto 0);
		   selIn: in unsigned(2 downto 0);
		   wr_en: in std_logic;
		   clk: in std_logic;
		   rst: in std_logic;
		   out1: out unsigned(15 downto 0);
		   out2: out unsigned(15 downto 0)
	);
end entity;

architecture a_bank8regs of bank8regs is

	component reg16bits
	    port( clk: in std_logic;
		  	  rst: in std_logic;
		  	  wr_en: in std_logic;
		  	  data_in: in unsigned(15 downto 0);
		  	  data_out: out unsigned(15 downto 0)
			);
    end component;

    component mux16b_8in
    	port(entr0 : in unsigned(15 downto 0);
			 entr1 : in unsigned(15 downto 0);
			 entr2 : in unsigned(15 downto 0);
			 entr3 : in unsigned(15 downto 0);
			 entr4 : in unsigned(15 downto 0);
			 entr5 : in unsigned(15 downto 0);
			 entr6 : in unsigned(15 downto 0);
			 entr7 : in unsigned(15 downto 0);
			 sel : in unsigned(2 downto 0);
			 saida : out unsigned(15 downto 0)
			 );
    end component;

    component demux1bit
    	 port(  saida0 : out std_logic;
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
    end component;

    signal en0,en1,en2,en3,en4,en5,en6,en7: std_logic;
	signal out_0,out_1,out_2,out_3,out_4,out_5,out_6,out_7: unsigned(15 downto 0);

	begin

		demuxIn: demux1bit port map( saida0=>en0 , saida1=>en1 , saida2=>en2 , saida3=>en3 , saida4=>en4 , saida5=>en5 , saida6=>en6 , saida7=>en7 , sel=>selIn , enable=>wr_en );

		r0: reg16bits port map( rst=>rst , wr_en=>en0 , data_in=>dataIn , data_out=>out_0 , clk=>clk );
		r1: reg16bits port map( rst=>rst , wr_en=>en1 , data_in=>dataIn , data_out=>out_1 , clk=>clk );
		r2: reg16bits port map( rst=>rst , wr_en=>en2 , data_in=>dataIn , data_out=>out_2 , clk=>clk );
		r3: reg16bits port map( rst=>rst , wr_en=>en3 , data_in=>dataIn , data_out=>out_3 , clk=>clk );
		r4: reg16bits port map( rst=>rst , wr_en=>en4 , data_in=>dataIn , data_out=>out_4 , clk=>clk );
		r5: reg16bits port map( rst=>rst , wr_en=>en5 , data_in=>dataIn , data_out=>out_5 , clk=>clk );
		r6: reg16bits port map( rst=>rst , wr_en=>en6 , data_in=>dataIn , data_out=>out_6 , clk=>clk );
		r7: reg16bits port map( rst=>rst , wr_en=>en7 , data_in=>dataIn , data_out=>out_7 , clk=>clk );

		mux1Out: mux16b_8in port map( entr0=>out_0 , entr1=>out_1 , entr2=>out_2 , entr3=>out_3 , entr4=>out_4 , entr5=>out_5 , entr6=>out_6 , entr7=>out_7 , sel=>selOut1 , saida=>out1 );
		mux2Out: mux16b_8in port map( entr0=>out_0 , entr1=>out_1 , entr2=>out_2 , entr3=>out_3 , entr4=>out_4 , entr5=>out_5 , entr6=>out_6 , entr7=>out_7 , sel=>selOut2 , saida=>out2 );

end architecture;
