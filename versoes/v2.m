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

disp("\n=====================================================================");
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
S33= sqrt(3)*vab*conj(Ia3);
P33= real(S33);     %% alterada
Q33= imag(S33);
fp3= cos(angle(S33));

disp("\nConsumidor 3");
disp(["S= ", num2str(abs(S33)), " [VA]"]);
disp(["P= ", num2str(P33), " [W]"]);
disp(["Q= ", num2str(Q33), " [VAR]"]);
disp(["F.P= ", num2str(fp3)]);

dados(3)= struct("Consumidor", "Consumidor 3", "W", P33, "Q", Q33, "S", abs(S33), "FP", fp3);

%% ---------------------------------------------------------------------------

%% Consumidor 4
W1= 35000;
W2= 18000;
P34= W1+W2;
Q34= sqrt(3)*(W1-W2);
S34= P34+(Q34*i);
fp4= cos(angle(S34));

Ia4= conj(S34/(sqrt(3)*vab));
Ib4= conj(S34/(sqrt(3)*vbc));
Ic4= conj(S34/(sqrt(3)*vca));

disp("\nConsumidor 4");
disp(["S= ", num2str(abs(S34)), " [VA]"]);
disp(["P= ", num2str(P34), " [W]"]);
disp(["Q= ", num2str(Q34), " [VAR]"]);
disp(["F.P= ", num2str(fp4)]);

dados(4)= struct("Consumidor", "Consumidor 4", "W", P34, "Q", Q34, "S", abs(S34), "FP", fp4);

%% ---------------------------------------------------------------------------

%% Consumidor 5
P5= 25980;
P35= 42000;
Q35= P5*sqrt(3);
S35= P35+(Q35*i);
fp5= cos(angle(S35));

Ia5= conj(S35/(sqrt(3)*vab));
Ib5= conj(S35/(sqrt(3)*vbc));
Ic5= conj(S35/(sqrt(3)*vca));

disp("\nConsumidor 5");
disp(["S= ", num2str(abs(S35)), " [VA]"]);
disp(["P= ", num2str(P35), " [W]"]);
disp(["Q= ", num2str(Q35), " [VAR]"]);
disp(["F.P= ", num2str(fp5)]);

dados(5)= struct("Consumidor", "Consumidor 5", "W", P35, "Q", Q35, "S", abs(S35), "FP", fp5);

%% ---------------------------------------------------------------------------

%% Banco de capacitores, F.P esperado 0.94
alvo= acos(0.935);
P3c= P31+P32+P33+P34+P35;
Q3c= Q31+Q32+Q33+Q34+Q35;
Qb= Q3c-(P3c*tan(alvo));

estrela_Xc= (abs(vab)^2)/Qb;
delta_Xc= (3*(abs(vab)^2))/Qb;

C_estrela= 1/(2*pi*60*estrela_Xc);
C_delta= 1/(2*pi*60*delta_Xc);

Ia6E= Van/(-i*estrela_Xc);
Ib6E= Vbn/(-i*estrela_Xc);
Ic6E= Vcn/(-i*estrela_Xc);

disp("\nBanco de Capacitores");
disp(["Q= ", num2str(Qb), " [VAR]"]);
disp(["Capacitor= ", num2str(C_estrela*10^6), " [uF]"]);

disp("\nCorrente");
disp(["Ia= ", num2str(abs(Ia6E)),"∠", num2str(rad2deg(angle(Ia6E))), " [A]"]);
disp(["Ib= ", num2str(abs(Ib6E)),"∠", num2str(rad2deg(angle(Ib6E))), " [A]"]);
disp(["Ic= ", num2str(abs(Ic6E)),"∠", num2str(rad2deg(angle(Ic6E))), " [A]"]);

dados(6)= struct("Consumidor", "Banco de Capacitores", "W", 0, "Q", Qb, "S", 0, "FP", 0.935);

%% ---------------------------------------------------------------------------

%% Impedancia da linha
Ial= Ia+Ia2+Ia3+Ia4+Ia5+Ia6E;
Ibl= Ib+Ib2+Ib3+Ib4+Ib5+Ib6E;
Icl= Ic+Ic2+Ic3+Ic4+Ic5+Ic6E;
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

dados(7)= struct("Consumidor", "Impedancia de linha", "W", Plt, "Q", Qlt, "S", Slt, "FP", fpl);

disp("\n=====================================================================");
%% ---------------------------------------------------------------------------

%% Fonte
P3f= Plt+P35+P34+P33+P32+P31;
Q3f= Qlt+Q35+Q34+Q33+Q32+Q31-Qb;
S3f= sqrt((P3f^2)+(Q3f^2));
fpf= P3f/S3f;
Sf= P3f+(Q3f*i);

disp("\nFonte");
disp(["S= ", num2str(S3f), " [VA]"]);
disp(["P= ", num2str(P3f), " [W]"]);
disp(["Q= ", num2str(Q3f), " [VAR]"]);
disp(["F.P= ", num2str(fpf)]);

dados(8)= struct("Consumidor", "Fonte", "W", P3f, "Q", Q3f, "S", S3f, "FP", fpf);

Ean= (abs(Vza+vab)/sqrt(3))*exp(1i*(angle(Vza+vab)-deg2rad(30)));
Ecn= (abs(Vzb+vca)/sqrt(3))*exp(1i*(angle(Vzb+vca)-deg2rad(30)));
Ebn= (abs(Vzc+vbc)/sqrt(3))*exp(1i*(angle(Vzc+vbc)-deg2rad(30)));

disp("\nTensão fonte");
disp(["Ean= ", num2str(abs(Ean)),"∠", num2str(rad2deg(angle(Ean))), " [V]"]);
disp(["Ebn= ", num2str(abs(Ebn)),"∠", num2str(rad2deg(angle(Ebn))), " [V]"]);
disp(["Ecn= ", num2str(abs(Ecn)),"∠", num2str(rad2deg(angle(Ecn))), " [V]"]);

disp("\nCorrente linha");
disp(["Ia= ", num2str(abs(Ial)),"∠", num2str(rad2deg(angle(Ial))), " [A]"]);
disp(["Ib= ", num2str(abs(Ibl)),"∠", num2str(rad2deg(angle(Ibl))), " [A]"]);
disp(["Ic= ", num2str(abs(Icl)),"∠", num2str(rad2deg(angle(Icl))), " [A]"]);

disp("\n=====================================================================");

%% Tensão e corrente da fonte

iad= sprintf("%f∠%f", abs(Ial), rad2deg(angle(Ial)));
ibd= sprintf("%f∠%f", abs(Ibl), rad2deg(angle(Ibl)));
icd= sprintf("%f∠%f", abs(Icl), rad2deg(angle(Icl)));

Ead= sprintf("%f∠%f", abs(Ean), rad2deg(angle(Ean)));
Ebd= sprintf("%f∠%f", abs(Ebn), rad2deg(angle(Ebn)));
Ecd= sprintf("%f∠%f", abs(Ecn), rad2deg(angle(Ecn)));

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
    Q32n= Q32-Qg;
    S32n= sqrt((P32n^2)+(Q32n^2));
    fp2n= norm(P32n)/S32n;
    S2n= P32n+(Q32n*i);

    Ia2n= conj(S2n/(sqrt(3)*vab));
    Ib2n= conj(S2n/(sqrt(3)*vbc));
    Ic2n= conj(S2n/(sqrt(3)*vca));

    Ialn= Ia+Ia2n+Ia3+Ia4+Ia5+Ia6E;
    Ibln= Ib+Ib2n+Ib3+Ib4+Ib5+Ib6E;
    Icln= Ic+Ic2n+Ic3+Ic4+Ic5+Ic6E;

    Vzan= zl*Ialn;
    Vzbn= zl*Ibln;
    Vzcn= zl*Icln;

    Eann= Vzan+Van;
    Ebnn= Vzbn+Vbn;
    Ecnn= Vzcn+Vcn;

    consumidor2g(j)= struct("Horas", horas, "Wg", Pg, "VARg", Qg, "VAg", Sg, "F.Pg", fpg, "W2", P32n, "VAR2", Q32n, "VA2", S32n, "F.P2", fp2n);
  endif

  P3fn= Plt+P35+P34+P33+(consumidor2g(j).W2)+P31;
  Q3fn= Qlt-Qb+Q35+Q34+Q33+(consumidor2g(j).VAR2)+Q31;
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
