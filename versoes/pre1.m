%% ---------------------------------------------------------------------------
%% Trabalho Polifásicos - Universidade Federal de Engenharia de Itajuba
%% Data - 13/05/24
%% ---------------------------------------------------------------------------

close all;
clear all;
clc;

pkg load io;
format long;

%% Tensão de linha
vab= 9758.07358+9758.07358i;
vca= -13329.7764+3571.702822i;
vbc= 3571.702822-13329.7764i;

%% Tensão de fase pós impedancia de linha
Van= (abs(vab)/sqrt(3))*exp(1i*(angle(vab)-deg2rad(30)));
Vcn= (abs(vca)/sqrt(3))*exp(1i*(angle(vca)-deg2rad(30)));
Vbn= (abs(vbc)/sqrt(3))*exp(1i*(angle(vbc)-deg2rad(30)));

disp("\nGerador desligado");
%% ---------------------------------------------------------------------------

%% Consumidor 1
za= 2000+1000i;
zb= 1550+2684.678752i;
zc= 2900+2500i;

Ia= Van/za;
Ib= Vbn/zb;
Ic= Vcn/zc;
In= Ia+Ib+Ic;

Sa= Van*conj(Ia);
Sb= Vbn*conj(Ib);
Sc= Vcn*conj(Ic);

St= Sa+Sb+Sc;
S31= abs(St);
fp1= cos(angle(St));
P31= real(St);
Q31= imag(St);

disp("\nConsumidor 1");
disp(["In= ", num2str(abs(In)),"∠", num2str(rad2deg(angle(In))), " [A]"]);
disp(["S= ", num2str(S31), " [VA]"]);
disp(["P= ", num2str(P31), " [W]"]);
disp(["Q= ", num2str(Q31), " [VAR]"]);
disp(["F.P= ", num2str(fp1)]);

dados(1)= struct("Consumidor", "Consumidor 1", "W", P31, "Q", Q31, "S", S31, "FP", fp1);

%% ---------------------------------------------------------------------------

%% Consumidor 2 sem a geração fotovoltaica
P32= 55000;
fp2= 0.89;
S32= P32/fp2;
angulo2= acos(fp2);
Q32= S32*sin(angulo2);
S2= P32+(Q32*i);

Ia2= conj(S2/(sqrt(3)*vab));
Ib2= conj(S2/(sqrt(3)*vbc));  %% formula alterada, calculos ok
Ic2= conj(S2/(sqrt(3)*vca));

disp("\nConsumidor 2");
disp(["S= ", num2str(S32), " [VA]"]);
disp(["P= ", num2str(P32), " [W]"]);
disp(["Q= ", num2str(Q32), " [VAR]"]);
disp(["F.P= ", num2str(fp2)]);

dados(2)= struct("Consumidor", "Consumidor 2", "W", P32, "Q", Q32, "S", S32, "FP", fp2);

%% ---------------------------------------------------------------------------

%% Consumidor 3
Ia3= 2.260266434-0.6056365655i;
Ib3= -1.654629868-1.654629868i;
Ic3= -0.6056365655+2.260266434i;
S3= 3*Van*conj(Ia3);
P33= sqrt(3)*abs(vab)*abs(Ia3)*cos(angle(S3));
Q33= sqrt(3)*abs(vab)*abs(Ia3)*sin(angle(S3));
S33= abs(S3);
fp3= cos(angle(S3));

disp("\nConsumidor 3");
disp(["S= ", num2str(S33), " [VA]"]);
disp(["P= ", num2str(P33), " [W]"]);
disp(["Q= ", num2str(Q33), " [VAR]"]);
disp(["F.P= ", num2str(fp3)]);

dados(3)= struct("Consumidor", "Consumidor 3", "W", P33, "Q", Q33, "S", S33, "FP", fp3);

%% ---------------------------------------------------------------------------

%% Impedancia da linha
Ial= Ia+Ia2+Ia3;
Ibl= Ib+Ib2+Ib3;
Icl= Ic+Ic2+Ic3;
zl= 25+21i;

Vza= zl*Ial;
Vzb= zl*Ibl;
Vzc= zl*Icl;

Plta= 25*(abs(Ial)^2); %% formula alterada, apresentacao previa
Qlta= 21*(abs(Ial)^2);

Pltb= 25*(abs(Ibl)^2);
Qltb= 21*(abs(Ibl)^2);

Pltc= 25*(abs(Icl)^2);
Qltc= 21*(abs(Icl)^2);

Plt= Plta+Pltb+Pltc;
Qlt= Qlta+Qltb+Qltc;
Slt= sqrt((Plt^2)+(Qlt^2));
fpl= Plt/Slt;

disp("\nImpedancia de linha");
disp(["S= ", num2str(Slt), " [VA]"]);
disp(["P= ", num2str(Plt), " [W]"]);
disp(["Q= ", num2str(Qlt), " [VAR]"]);
disp(["F.P= ", num2str(fpl)]);

dados(4)= struct("Consumidor", "Impedancia de linha", "W", Plt, "Q", Qlt, "S", Slt, "FP", fpl);

%% ---------------------------------------------------------------------------

%% Fonte
P3f= Plt+P33+P32+P31;
Q3f= Qlt+Q33+Q32+Q31;
S3f= sqrt((P3f^2)+(Q3f^2));
fpf= P3f/S3f;
Sf= P3f+(Q3f*i);

disp("\nFonte");
disp(["S= ", num2str(S3f), " [VA]"]);
disp(["P= ", num2str(P3f), " [W]"]);
disp(["Q= ", num2str(Q3f), " [VAR]"]);
disp(["F.P= ", num2str(fpf)]);

dados(5)= struct("Consumidor", "Fonte", "W", P3f, "Q", Q3f, "S", S3f, "FP", fpf);

Ean= Vza+Van; %% conferir se essa conta bate com o esperado
Ebn= Vzb+Vbn;
Ecn= Vzc+Vcn;

disp("\nTensão fonte");
disp(["Ea= ", num2str(abs(Ean)),"∠", num2str(rad2deg(angle(Ean))), " [V]"]);
disp(["Eb= ", num2str(abs(Ebn)),"∠", num2str(rad2deg(angle(Ebn))), " [V]"]);
disp(["Ec= ", num2str(abs(Ecn)),"∠", num2str(rad2deg(angle(Ecn))), " [V]"]);

disp("\nCorrente linha");
disp(["Ia= ", num2str(abs(Ial)),"∠", num2str(rad2deg(angle(Ial))), " [A]"]);
disp(["Ib= ", num2str(abs(Ibl)),"∠", num2str(rad2deg(angle(Ibl))), " [A]"]);
disp(["Ic= ", num2str(abs(Icl)),"∠", num2str(rad2deg(angle(Icl))), " [A]"]);

disp("\nGerador ligado");
%% ---------------------------------------------------------------------------

%% Consumidor 2 com a geração fotovoltaica (media)
P32g= 45417.6;
fp2g= 0.869552;
S32g= P32g/fp2g;
angulo2g= acos(fp2g);
Q32g= S32g*sin(angulo2g);
S2g= (P32-P32g)+(Q32-Q32g)*i; %% - q
S2gi= S2g/3;
P32gg= real(S2g);
Q32gg= imag(S2g);
fp2gg= cos(angle(S2g));

Ia2g= conj(S2gi/Van);
Ib2g= conj(S2gi/Vbn);
Ic2g= conj(S2gi/Vcn);

disp("\nConsumidor 2 Gerador ligado");
disp(["S= ", num2str(abs(S2g)), " [VA]"]);
disp(["P= ", num2str(P32gg), " [W]"]);
disp(["Q= ", num2str(Q32gg), " [VAR]"]);
disp(["F.P= ", num2str(fp2gg)]);

Ialg= Ia+Ia2g+Ia3;
Iblg= Ib+Ib2g+Ib3;
Iclg= Ic+Ic2g+Ic3;

Vzag= zl*Ialg;
Vzbg= zl*Iblg;
Vzcg= zl*Iclg;

Pltag= 25*(abs(Ialg)^2); %% conta alterada, apresentacao parcial
Qltag= 21*(abs(Ialg)^2);

Pltbg= 25*(abs(Iblg)^2);
Qltbg= 21*(abs(Iblg)^2);

Pltcg= 25*(abs(Iclg)^2);
Qltcg= 21*(abs(Iclg)^2);

Pltg= Pltag+Pltbg+Pltcg;
Qltg= Qltag+Qltbg+Qltcg;
Sltg= sqrt((Pltg^2)+(Qltg^2));
fplg= Pltg/Sltg;

P3fg= Pltg+P33+P32g+P31;
Q3fg= Qltg+Q33+Q32g+Q31;
S3fg= sqrt((P3fg^2)+(Q3fg^2));
fpfg= P3fg/S3fg;
Sfg= P3fg+(Q3fg*i);

disp("\nImpedancia de linha");
disp(["S= ", num2str(Sltg), " [VA]"]);
disp(["P= ", num2str(Pltg), " [W]"]);
disp(["Q= ", num2str(Qltg), " [VAR]"]);
disp(["F.P= ", num2str(fplg)]);

disp("\nFonte");
disp(["S= ", num2str(S3fg), " [VA]"]);
disp(["P= ", num2str(P3fg), " [W]"]);
disp(["Q= ", num2str(Q3fg), " [VAR]"]);
disp(["F.P= ", num2str(fpfg)]);

mediag(1)= struct("Consumidor", "Consumidor 1", "W", P31, "Q", Q31, "S", S31, "FP", fp1);
mediag(2)= struct("Consumidor", "Consumidor 2", "W", P32gg, "Q", Q32gg, "S", abs(S2g), "FP", fp2gg);
mediag(3)= struct("Consumidor", "Consumidor 3", "W", P33, "Q", Q33, "S", S33, "FP", fp3);
mediag(4)= struct("Consumidor", "Impedancia de linha", "W", Pltg, "Q", Qltg, "S", Sltg, "FP", fplg);
mediag(5)= struct("Consumidor", "Fonte", "W", P3fg, "Q", Q3fg, "S", S3fg, "FP", fpfg);

Eang= Vzag+Van;
Ebng= Vzbg+Vbn;
Ecng= Vzcg+Vcn;

disp("\nTensão fonte");
disp(["Ea= ", num2str(abs(Eang)),"∠", num2str(rad2deg(angle(Eang))), " [V]"]);
disp(["Eb= ", num2str(abs(Ebng)),"∠", num2str(rad2deg(angle(Ebng))), " [V]"]);
disp(["Ec= ", num2str(abs(Ecng)),"∠", num2str(rad2deg(angle(Ecng))), " [V]"]);

disp("\nCorrente linha");
disp(["Ia= ", num2str(abs(Ialg)),"∠", num2str(rad2deg(angle(Ialg))), " [A]"]);
disp(["Ib= ", num2str(abs(Iblg)),"∠", num2str(rad2deg(angle(Iblg))), " [A]"]);
disp(["Ic= ", num2str(abs(Iclg)),"∠", num2str(rad2deg(angle(Iclg))), " [A]"]);

%% ---------------------------------------------------------------------------

%% Tensão e corrente da fonte, gerador desligado e ligado (media)

iad= sprintf("%f∠%f", abs(Ial), rad2deg(angle(Ial)));
ibd= sprintf("%f∠%f", abs(Ibl), rad2deg(angle(Ibl)));
icd= sprintf("%f∠%f", abs(Icl), rad2deg(angle(Icl)));

Ead= sprintf("%f∠%f", abs(Ean), rad2deg(angle(Ean)));
Ebd= sprintf("%f∠%f", abs(Ebn), rad2deg(angle(Ebn)));
Ecd= sprintf("%f∠%f", abs(Ecn), rad2deg(angle(Ecn)));

ial= sprintf("%f∠%f", abs(Ialg), rad2deg(angle(Ialg)));
ibl= sprintf("%f∠%f", abs(Iblg), rad2deg(angle(Iblg)));
icl= sprintf("%f∠%f", abs(Iclg), rad2deg(angle(Iclg)));

Eal= sprintf("%f∠%f", abs(Eang), rad2deg(angle(Eang)));
Ebl= sprintf("%f∠%f", abs(Ebng), rad2deg(angle(Ebng)));
Ecl= sprintf("%f∠%f", abs(Ecng), rad2deg(angle(Ecng)));

tensao(1)= struct("Fonte", "Gerador desligado", "Ean", Ead, "Ebn", Ebd, "Ecn", Ecd, "Ia", iad, "Ib", ibd, "Ic", icd);
tensao(2)= struct("Fonte", "Gerador ligado média", "Ean", Eal, "Ebn", Ebl, "Ecn", Ecl, "Ia", ial, "Ib", ibl, "Ic", icl);

%% ---------------------------------------------------------------------------

%% Banco de capacitores, F.P esperado 0.94

%% ---------------------------------------------------------------------------

%% Geração Fotovoltaica
dadosF= xlsread("dados.xlsx");
for j= 1:38
  Pg= dadosF(j,2);
  fpg= dadosF(j,3);
  horas= datestr(dadosF(j,1), "HH:MM");

  if Pg == 0
    P32n= P32;
    Q32n= Q32;
    S32n= S32;
    fp2n= fp2;
    S2n= S2;

    Ia2n= Ia2;
    Ib2= Ib2;
    Ic2= Ic2;

    Ialn= Ial;
    Ibln= Ibl;
    Icln= Icl;

    Vzan= Vza;
    Vzbn= Vzb;
    Vzcn= Vzc;

    Eann= Ean;
    Ebnn= Ebn;
    Ecnn= Ecn;

    consumidor2g(j)= struct("Horas", horas, "Wg", Pg, "VARg", 0, "VAg", 0, "F.Pg", fpg,  "W2", P32n, "VAR2", Q32n, "VA2", S32n, "F.P2", fp2n);
  else
    Sg= Pg/fpg;
    Qg= sqrt((Sg^2)-(Pg^2));
    P32n= P32-Pg;
    Q32n= Q32-Qg; %% - q
    S32n= sqrt((P32n^2)+(Q32n^2));
    fp2n= norm(P32n)/S32n;
    S2n= P32n+(Q32n*i);

    Ia2n= conj(S2n/sqrt(3)*vab); %% conta alterada
    Ib2n= conj(S2n/sqrt(3)*vbc);
    Ic2n= conj(S2n/sqrt(3)*vca);

    Ialn= Ia+Ia2n+Ia3;
    Ibln= Ib+Ib2n+Ib3;
    Icln= Ic+Ic2n+Ic3;

    Vzan= zl*Ialn;
    Vzbn= zl*Ibln;
    Vzcn= zl*Icln;

    Eann= Vzan+Van;
    Ebnn= Vzbn+Vbn;
    Ecnn= Vzcn+Vcn;

    consumidor2g(j)= struct("Horas", horas, "Wg", Pg, "VARg", Qg, "VAg", Sg, "F.Pg", fpg, "W2", P32n, "VAR2", Q32n, "VA2", S32n, "F.P2", fp2n);
  endif

  P3fn= Plt+P33+(consumidor2g(j).W2)+P31;
  Q3fn= Qlt+Q33+(consumidor2g(j).VAR2)+Q31;
  S3fn= sqrt((P3fn^2)+(Q3fn^2));
  fpfn= P3fn/S3fn;

  ia= sprintf("%f∠%f", abs(Ialn), rad2deg(angle(Ialn)));
  ib= sprintf("%f∠%f", abs(Ibln), rad2deg(angle(Ibln)));
  ic= sprintf("%f∠%f", abs(Icln), rad2deg(angle(Icln)));

  Ea= sprintf("%f∠%f", abs(Eann), rad2deg(angle(Eann)));
  Eb= sprintf("%f∠%f", abs(Ebnn), rad2deg(angle(Ebnn)));
  Ec= sprintf("%f∠%f", abs(Ecnn), rad2deg(angle(Ecnn)));

  dadosg(j)= struct("Horas", horas, "Wt", P3fn, "VARt", Q3fn, "VAt", S3fn, "F.P", fpfn, "Ean", Ea, "Ebn", Eb, "Ecn", Ec, "Ia", ia, "Ib", ib, "Ic", ic);
endfor
