%% ---------------------------------------------------------------------------
%% Trabalho Polifásicos - Universidade Federal de Engenharia de Itajuba
%% Data - 13/05/24
%% ---------------------------------------------------------------------------

close all;
clear all;
clc;

format long;
pkg load io;

dadosF= xlsread("dados.xlsx");

%% ---------------------------------------------------------------------------

%% Tensão de linha
vab= 9758.07358+9758.07358i;
vca= -13329.7764+3571.702822i;
vbc= 3571.702822-13329.7764i;

%% Tensão de fase pós impedancia de linha
van= (abs(vab)/sqrt(3))*exp(1i*(angle(vab)-deg2rad(30)));
vcn= (abs(vca)/sqrt(3))*exp(1i*(angle(vca)-deg2rad(30)));
vbn= (abs(vbc)/sqrt(3))*exp(1i*(angle(vbc)-deg2rad(30)));

%% Calculo de cada consumidor
[Ia1,Ib1,Ic1,S31,P31,Q31,fp1]= consumidor_1(van,vbn,vcn);
[Ia2,Ib2,Ic2,S32,P32,Q32,fp2]= consumidor_2(vab,vbc,vca);
[Ia3,Ib3,Ic3,S33,P33,Q33,fp3]= consumidor_3(vab,van);
[Ia4,Ib4,Ic4,S34,P34,Q34,fp4]= consumidor_4(vab,vbc,vca);
[Ia5,Ib5,Ic5,S35,P35,Q35,fp5]= consumidor_5(vab,vbc,vca);

%% Calculo do banco de capacitores, ajustado para 0,935
[banco,corrigido]= capacitor(S31,S32,S33,S34,S35,vab,vbc,vca,van,vbn,vcn);

%% Impedancia de linha e fonte
linha= impedancia(banco,Ia1,Ib1,Ic1,Ia2,Ib2,Ic2,Ia3,Ib3,Ic3,Ia4,Ib4,Ic4,Ia5,Ib5,Ic5);
consumo= fonte(linha,banco,S31,S32,S33,S34,S35,vab,vbc,vca);

%% Decisao estrela ou delta no banco de capacitores
decisao(1)= struct("Conexao", "Estrela", "Capacitancia [uF]", banco(1).("Capacitancia Y")*10^6, "Corrente Maxima", abs(linha(1).Ia), "Tensão Máxima", abs(consumo(1).Ean));
decisao(2)= struct("Conexao", "Delta", "Capacitancia [uF]", banco(1).("Capacitancia T")*10^6, "Corrente Maxima", abs(linha(2).Ia), "Tensão Máxima", abs(consumo(2).Ean));

%% Correção feita em um banco próximo a distribuição, em estrela (verifique linha e fonte)
dados(1)= struct("Consumidor", "Consumidor 1", "W", P31, "Q", Q31, "S", abs(S31), "FP", fp1);
dados(2)= struct("Consumidor", "Consumidor 2", "W", P32, "Q", Q32, "S", abs(S32), "FP", fp2);
dados(3)= struct("Consumidor", "Consumidor 3", "W", P33, "Q", Q33, "S", abs(S33), "FP", fp3);
dados(4)= struct("Consumidor", "Consumidor 4", "W", P34, "Q", Q34, "S", abs(S34), "FP", fp4);
dados(5)= struct("Consumidor", "Consumidor 5", "W", P35, "Q", Q35, "S", abs(S35), "FP", fp5);
dados(6)= struct("Consumidor", "Correção", "W", 0, "Q", banco(1).("VARc"), "S", 0, "FP", 0);
dados(7)= struct("Consumidor", "Linha", "W", linha(1).("W"), "Q", linha(1).("Q"), "S", abs(linha(1).("S")), "FP", linha(1).("FP"));
dados(8)= struct("Consumidor", "Fonte", "W", consumo(1).("W"), "Q", consumo(1).("Q"), "S", consumo(1).("S"), "FP", consumo(1).("FP"));

%% Correção feita em um banco para cada consumidor, em estrela (verifique linha e fonte)
individual(1)= struct("Consumidor", "Consumidor 1", "W", real(corrigido(1).("S")), "Q", imag(corrigido(1).("S")), "S", abs(corrigido(1).("S")), "FP", cos(angle(corrigido(1).("S"))));
individual(2)= struct("Consumidor", "Consumidor 2", "W", real(corrigido(2).("S")), "Q", imag(corrigido(2).("S")), "S", abs(corrigido(2).("S")), "FP", cos(angle(corrigido(2).("S"))));
individual(3)= struct("Consumidor", "Consumidor 3", "W", real(corrigido(3).("S")), "Q", imag(corrigido(3).("S")), "S", abs(corrigido(3).("S")), "FP", cos(angle(corrigido(3).("S"))));
individual(4)= struct("Consumidor", "Consumidor 4", "W", real(corrigido(4).("S")), "Q", imag(corrigido(4).("S")), "S", abs(corrigido(4).("S")), "FP", cos(angle(corrigido(4).("S"))));
individual(5)= struct("Consumidor", "Consumidor 5", "W", real(corrigido(5).("S")), "Q", imag(corrigido(5).("S")), "S", abs(corrigido(5).("S")), "FP", cos(angle(corrigido(5).("S"))));
individual(6)= struct("Consumidor", "Linha", "W", linha(1).("W"), "Q", linha(1).("Q"), "S", abs(linha(1).("S")), "FP", linha(1).("FP"));
individual(7)= struct("Consumidor", "Fonte", "W", consumo(1).("W"), "Q", consumo(1).("Q"), "S", consumo(1).("S"), "FP", consumo(1).("FP"));

%% Geração fotovoltaica Consumidor 2
for j= 1:38
  %% Dados Fornecidos pela tabela
  Pg= dadosF(j,2);
  fpg= dadosF(j,3);
  horas= datestr(dadosF(j,1), "HH:MM");

  %% Geração 0
  if Pg == 0
    P32n= P32;
    Q32n= Q32; %%-banco(3).VARc correcao local
    S32n= P32n+(Q32n*i);
    fp2n= cos(angle(S32n));

    Ialn= linha(1).Ia; %% altere para 2 T
    Ibln= linha(1).Ib;
    Icln= linha(1).Ic;

    Eann= consumo(1).Ean;
    Ebnn= consumo(1).Ebn;
    Ecnn= consumo(1).Ecn;

    consumidor2g(j)= struct("Horas", horas, "Wg", Pg, "VARg", 0, "VAg", 0, "F.Pg", fpg,  "W2", P32n, "VAR2", Q32n, "VA2", abs(S32n), "F.P2", fp2n, "CARGA", "Indutiva");

  %% Geração >0
  else

    %% Potencias e fp com geração
    Sg= Pg/fpg;
    Qg= sqrt((Sg^2)-(Pg^2));
    P32n= P32-Pg;
    Q32n= Q32-Qg-banco(3).VARc; %%-banco(3).VARc correcao local
    S32n= P32n+(Q32n*i);
    fp2n= abs(cos(angle(S32n)));

    if Q32n>0
      carga= "Indutiva";
    else
      carga= "Capacitiva";
    endif

    %% Corrente com geração
    Ia2n= conj(S32n/(sqrt(3)*vab));
    Ib2n= conj(S32n/(sqrt(3)*vbc));
    Ic2n= conj(S32n/(sqrt(3)*vca));

    %% Corrente total da linha
    Ialn= Ia1+Ia2n+Ia3+Ia4+Ia5+banco(1).("Ia Y"); %% alterar para T "Ia T"
    Ibln= Ib1+Ib2n+Ib3+Ib4+Ib5+banco(1).("Ib Y");
    Icln= Ic1+Ic2n+Ic3+Ic4+Ic5+banco(1).("Ic Y");

    %% Queda de tensao na linha
    zl= 25+21i;
    vzan= zl*Ialn;
    vzbn= zl*Ibln;
    vzcn= zl*Icln;

    %% Tensao de fase da fonte
    Eann= (abs(vzan+vab)/sqrt(3))*exp(1i*(angle(vzan+vab)-deg2rad(30)));
    Ecnn= (abs(vzan+vca)/sqrt(3))*exp(1i*(angle(vzan+vca)-deg2rad(30)));
    Ebnn= (abs(vzan+vbc)/sqrt(3))*exp(1i*(angle(vzan+vbc)-deg2rad(30)));

    consumidor2g(j)= struct("Horas", horas, "Wg", Pg, "VARg", Qg, "VAg", Sg, "F.Pg", fpg, "W2", P32n, "VAR2", Q32n, "VA2", abs(S32n), "F.P2", fp2n, "CARGA", carga);
  endif

  %% Novo triangulo total
  P3fn= (linha(1).W)+P35+P34+P33+(consumidor2g(j).W2)+P31;
  Q3fn= (linha(1).Q)-(banco(1).VARc)+Q35+Q34+Q33+(consumidor2g(j).VAR2)+Q31; %% linha(2) T
  S3fn= P3fn+(Q3fn*i);
  fpfn= cos(angle(S3fn));

  ia= sprintf("%.3f∠%.3f", abs(Ialn), rad2deg(angle(Ialn)));
  ib= sprintf("%.3f∠%.3f", abs(Ibln), rad2deg(angle(Ibln)));
  ic= sprintf("%.3f∠%.3f", abs(Icln), rad2deg(angle(Icln)));

  Ea= sprintf("%.3f∠%.3f", abs(Eann), rad2deg(angle(Eann)));
  Eb= sprintf("%.3f∠%.3f", abs(Ebnn), rad2deg(angle(Ebnn)));
  Ec= sprintf("%.3f∠%.3f", abs(Ecnn), rad2deg(angle(Ecnn)));

  dadosg(j)= struct("Horas", horas, "Wt", P3fn, "VARt", Q3fn, "VAt", abs(S3fn), "F.P", fpfn, "Ean", Ea, "Ebn", Eb, "Ecn", Ec, "Ia", ia, "Ib", ib, "Ic", ic);
endfor

correntes= formatar(Ia1, Ib1, Ic1, Ia2, Ib2, Ic2, Ia3, Ib3, Ic3, Ia4, Ib4, Ic4, Ia5, Ib5, Ic5, banco, linha);







