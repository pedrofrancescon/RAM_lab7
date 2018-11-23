library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port (clk: in std_logic;
          rst: in std_logic
    );
end entity;

architecture a_processador of processador is

    component pc16bits
        port( clk: in std_logic;
    		      rst: in std_logic;
    		      wr_en: in std_logic;
    		      jump_en: in std_logic;
    		      data_in: in unsigned(15 downto 0); --proximo endereco pro jump
    		      data_out: out unsigned(15 downto 0) --endereco atual
    	);
   	end component;

   	component rom
    	  port( clk: in std_logic;
		  	      endereco: in unsigned(15 downto 0);
		          dado: out unsigned(14 downto 0)
		);
    end component;

    component un_controle
        port( clk: in std_logic;
              rst: in std_logic;
              pc_wr_en: out std_logic;
              regs_wr_en: out std_logic;
              ram_wr_en: out std_logic;
              jump_en: out std_logic;
              origemJump: out std_logic;
              flagsRst: out std_logic;
              operacao: out unsigned(1 downto 0);
              reg1OuConst: out std_logic;
              reg2OuConst: out std_logic;
              ulaOuRam: out std_logic;
              opcode: in unsigned(3 downto 0)
        );
    end component;

    component decoder
    	  port( instr: in unsigned(14 downto 0);
    		      opcode: out unsigned(3 downto 0);
              valor: out unsigned(15 downto 0);
              selReg1: out unsigned(2 downto 0);
    		      selReg2: out unsigned(2 downto 0);
              endereco: out unsigned(15 downto 0)
    	);
    end component;

    component bank8regs
        port( selOut1: in unsigned(2 downto 0);
    		      selOut2: in unsigned(2 downto 0);
    		      dataIn: in unsigned(15 downto 0);
    		      selIn: in unsigned(2 downto 0);
    		      wr_en: in std_logic;
    		      clk: in std_logic;
    		      rst: in std_logic;
    		      out1: out unsigned(15 downto 0);
    		      out2: out unsigned(15 downto 0)
    	);
    end component;

    component ula
        port( entr0: in unsigned(15 downto 0);
              entr1: in unsigned(15 downto 0);
              sel: in unsigned(1 downto 0);
              result: out unsigned(15 downto 0);
              maiorIgual: out std_logic; --flag antiga, nao estamos usando
              CY: out std_logic; --se deu carry é 1
              OV: out std_logic; --se deu overflow é 1
              S: out std_logic; -- 0 se o resultado é positivo, 1 se negativo
              Z: out std_logic ); --o famoso que quando é zero o zero é um
    end component;

    component mux16b_2in
        port( entr0: in unsigned(15 downto 0);
              entr1: in unsigned(15 downto 0);
              sel: in std_logic;
              saida: out unsigned(15 downto 0) );
    end component;

    component flipFlop
        port( clk: in std_logic;
              rst: in std_logic;
              wr_en: in std_logic;
              estado: out std_logic );
    end component;

    component ram
        port( clk: in std_logic;
              endereco: in unsigned(15 downto 0);
              wr_en: in std_logic;
              dado_in: in unsigned(15 downto 0);
              dado_out: out unsigned(15 downto 0) );
    end component;

    signal endPcPraRom, busDecPraUla, busReg1ToMux, busReg2ToMux: unsigned(15 downto 0);
    signal dadoOutUla, dadoRamToRegMux, outMuxToRegsIn, muxOuPraUla, muxEPraUla, endDecPraMux, endMuxPraMuxPc, endMuxProPc: unsigned(15 downto 0);
    signal endRomProDec: unsigned(14 downto 0);
    signal codigo: unsigned(3 downto 0);
    signal selDecProReg1, selDecProReg2: unsigned(2 downto 0);
    signal pule, escrevaPC, escrevaReg, escrevaRam, reg1OuConst, reg2OuConst, RegOuDec, ulaOuRam, lixo, zero, negativo, selConstOuDec, flagsRst, overflow, carry: std_logic;
    signal calculeIsto: unsigned(1 downto 0);
    signal constantePulo: unsigned(15 downto 0);

    begin

    constantePulo <= "0000000000000001";

    memProg: rom port map(clk=>clk,
                          endereco=>endPcPraRom,
                          dado=>endRomProDec);

    contador: pc16bits port map(clk=>clk,
                                rst=>rst,
                                wr_en=>escrevaPC,
                                jump_en=>pule,
                                data_in=>endMuxProPc,
                                data_out=>endPcPraRom);

    decodificador: decoder port map(instr=>endRomProDec,
                                    opcode=>codigo,
                                    valor=>busDecPraUla,
                                    selReg1=>selDecProReg1,
                                    selReg2=>selDecProReg2,
                                    endereco=>endDecPraMux);

    unidControle: un_controle port map(clk=>clk,
                                       rst=>rst,
                                       pc_wr_en=>escrevaPC,
                                       regs_wr_en=>escrevaReg,
                                       ram_wr_en=>escrevaRam,
                                       jump_en=>pule,
                                       origemJump=>RegOuDec,
                                       flagsRst=>flagsRst,
                                       operacao=>calculeIsto,
                                       reg1OuConst=>reg1OuConst,
                                       reg2OuConst=>reg2OuConst,
                                       ulaOuRam=>ulaOuRam,
                                       opcode=>codigo);

    bancoReg: bank8regs port map(selOut1=>selDecProReg1,
                                 selOut2=>selDecProReg2,
                                 dataIn=>outMuxToRegsIn,
                                 selIn=>selDecProReg2,
                                 wr_en=>escrevaReg,
                                 clk=>clk,
                                 rst=>rst,
                                 out1=>busReg1ToMux,
                                 out2=>busReg2ToMux);

    unLogArit: ula port map(entr0=>muxOuPraUla,
                            entr1=>muxEPraUla,
                            sel=>calculeIsto,
                            result=>dadoOutUla,
                            maiorIgual=>lixo,
                            Z=>zero,
                            S=>negativo,
                            OV=>overflow,
                            CY=>carry);

    -- Esse Mux é pros ADD ou SUB de registrador com constante
    -- Escolhe entre reg1 ou constante vinda do decodificador
    MuxOpIouR: mux16b_2in port map(entr0=>busReg1ToMux,
                                entr1=>busDecPraUla,
                                sel=>reg1OuConst,
                                saida=>muxOuPraUla);

    -- Esse Mux é pros ADDI ou LD.W
    -- Escolhe entre reg2 ou constante vinda do decodificador
    MuxOpIeR: mux16b_2in port map(entr0=>busReg2ToMux,
                                entr1=>busDecPraUla,
                                sel=>reg2OuConst,
                                saida=>muxEPraUla);

    -- Esse Mux é pra entrada do banco de regs
    -- Escolhe entre o valor que vem direto da ULA ou o valor que vem da RAM
    MuxRegsIn: mux16b_2in port map(entr0=>dadoOutUla,
                                entr1=>dadoRamToRegMux,
                                sel=>ulaOuRam,
                                saida=>outMuxToRegsIn);

    MuxConstOuDec: mux16b_2in port map(entr0=>constantePulo,
                                       entr1=>endDecPraMux,
                                       sel=>selConstOuDec,
                                       saida=>endMuxPraMuxPc);

    MuxPCjump: mux16b_2in port map(entr0=>endMuxPraMuxPc,
                                   entr1=>busReg2ToMux,
                                   sel=>RegOuDec,
                                   saida=>endMuxProPc);

    NegativoFlag: flipFlop port map(clk=>clk,
                                    rst=>flagsRst,
                                    wr_en=>negativo,
                                    estado=>selConstOuDec);

    MemRam: ram port map( clk=>clk,
                          endereco=>dadoOutUla, -- aqui é tando o endereço de leitura quanto de escrita
                          wr_en=>escrevaRam,
                          dado_in=>busReg2ToMux, -- pra escrever na RAM o dado sempre vem do reg2
                          dado_out=>dadoRamToRegMux); 


end architecture;
