library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
 port( entr0 : in unsigned(15 downto 0);
 	     entr1 : in unsigned(15 downto 0);
 	     sel : in unsigned(1 downto 0);
 	     result : out unsigned(15 downto 0);
 	     maiorIgual : out std_logic; --flag antiga não usamos
       CY: out std_logic; --se deu carry é 1
       OV: out std_logic; --se deu overflow é 1
       S: out std_logic; -- 0 se o resultado é positivo, 1 se negativo
       Z: out std_logic ); --o famoso que quando é zero o zero é um
end entity;

architecture a_ula of ula is

      signal entr0_17,entr1_17,result_17: unsigned(16 downto 0);

      signal result_s: unsigned(15 downto 0);

      begin

      -- tratamento de carry

      entr0_17 <= '0' & entr0;
      entr1_17 <= '0' & entr1;

      result_17 <= entr0_17+entr1_17 when sel = "00" else
                entr1_17-entr0_17 when sel = "01" else
                entr0_17 and entr1_17 when sel = "10" else
                "00000000000000000"; -- 17 zeros

      CY <= result_17(16);

      S <= '0' when entr0<=entr1 else
      '1';
      
      -- sinais para reutilizar os sinais de saida em outras saidas (?)

      result_s <= result_17(15 downto 0);

      -- atribuições

      result <= result_s;

      Z <= '1' when result_s = "0000000000000000" else
      '0';

      -- flags que não são utilizadas ainda

      OV <= '0';

      maiorIgual <= '1' when entr0 > entr1 else
      '0';

end architecture;
