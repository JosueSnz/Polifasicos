function [Ia1,Ib1,Ic1,S31,P31,Q31,fp1]= consumidor_1(van,vbn,vcn)

  disp("\n=====================================================================");
  %% ---------------------------------------------------------------------------

  %% Consumidor 1
  za= 2000+1000i;
  zb= 1550+2684.678752i;
  zc= 2900+2500i;

  %% Corrente de cada fase
  Ia1= van/za;
  Ib1= vbn/zb;
  Ic1= vcn/zc;
  In= Ia1+Ib1+Ic1;

  %% Potencia Aparente calculada em cada fase
  Sa= van*conj(Ia1);
  Sb= vbn*conj(Ib1);
  Sc= vcn*conj(Ic1);

  %% Potencias e fp
  S31= Sa+Sb+Sc;
  fp1= cos(angle(S31));
  P31= real(S31);
  Q31= imag(S31);

  disp("\nConsumidor 1");
  disp(["In= ", num2str(abs(In)),"∠", num2str(rad2deg(angle(In))), " [A]"]);
  disp(["S= ", num2str(abs(S31)), " [VA]"]);
  disp(["P= ", num2str(P31), " [W]"]);
  disp(["Q= ", num2str(Q31), " [VAR]"]);
  disp(["F.P= ", num2str(fp1)]);

  %% ---------------------------------------------------------------------------

endfunction
