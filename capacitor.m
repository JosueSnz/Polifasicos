function [banco,corrigido]= capacitor(S31,S32,S33,S34,S35,vab,vbc,vca,van,vbn,vcn)

  %% ---------------------------------------------------------------------------

  %% Banco de capacitores
  alvo= acos(0.935);

  %% -------

  %% Caso 1- Banco de Capacitores próximo a distribuição
  P3c1= real(S31+S32+S33+S34+S35);
  Q3c1= imag(S31+S32+S33+S34+S35);
  Qb1= Q3c1-(P3c1*tan(alvo));

  %% Conexão em estrela 1.1
  Y_Xc1= (abs(vab)^2)/Qb1;
  C_Y1= 1/(2*pi*60*Y_Xc1);
  Ia6Y1= van/(-i*Y_Xc1);
  Ib6Y1= vbn/(-i*Y_Xc1);
  Ic6Y1= vcn/(-i*Y_Xc1);

  %% Conexão em delta 1.2
  T_Xc1= (3*(abs(vab)^2))/Qb1;
  C_T1= 1/(2*pi*60*T_Xc1);
  Ia6T1= vab/(-i*T_Xc1);
  Ib6T1= vbc/(-i*T_Xc1);
  Ic6T1= vca/(-i*T_Xc1);

  banco(1)= struct("Caso", "Perto da Fonte", "VARc", Qb1, "Impedancia Y", Y_Xc1, "Capacitancia Y", C_Y1, "Ia Y", Ia6Y1, "Ib Y", Ib6Y1, "Ic Y", Ic6Y1, "Impedancia T", T_Xc1, "Capacitancia T", C_T1, "Ia T", Ia6T1, "Ib T", Ib6T1, "Ic T", Ic6T1);
  %% -------

  %% Caso 2- Banco de Capacitores ao lado de cada consumidor
  consumidores= [S31,S32,S33,S34,S35];
  for j= 1:length(consumidores);

    P3c2= real(consumidores(j));
    Q3c2= imag(consumidores(j));
    Qb2= Q3c2-(P3c2*tan(alvo));

    S3c2= P3c2+((Q3c2-Qb2)*i);
    Q3c= imag(S3c2);
    fpc2= cos(angle(S3c2));
    corrigido(j)= struct("S", S3c2);

    %% Conexão em estrela 2.1
    Y_Xc2= (abs(vab)^2)/Qb2;
    C_Y2= 1/(2*pi*60*Y_Xc2);
    Ia6Y2= van/(-i*Y_Xc2);
    Ib6Y2= vbn/(-i*Y_Xc2);
    Ic6Y2= vcn/(-i*Y_Xc2);

    %% Conexão em delta 2.2
    T_Xc2= (3*(abs(vab)^2))/Qb2;
    C_T2= 1/(2*pi*60*T_Xc2);
    Ia6T2= vab/(-i*T_Xc2);
    Ib6T2= vbc/(-i*T_Xc2);
    Ic6T2= vca/(-i*T_Xc2);

    referencia= sprintf("Consumidor %d", j);

    banco(j+1)= struct("Caso", referencia,"VARc", Qb2, "Impedancia Y", Y_Xc2, "Capacitancia Y", C_Y2, "Ia Y", Ia6Y2, "Ib Y", Ib6Y2, "Ic Y", Ic6Y2, "Impedancia T", T_Xc2, "Capacitancia T", C_T2, "Ia T", Ia6T2, "Ib T", Ib6T2, "Ic T", Ic6T2);
  endfor

  %% ---------------------------------------------------------------------------

endfunction
