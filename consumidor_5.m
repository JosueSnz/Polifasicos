function [Ia5,Ib5,Ic5,S35,P35,Q35,fp5]= consumidor_5(van,vbn,vcn)

  %% Consumidor 5
  P5= 25980;
  P35= 42000;

  %% Potencias e fp
  Q35= P5*sqrt(3);
  S35= P35+(Q35*i);
  fp5= cos(angle(S35));

  %% Corrente de cada fase
  Ia5= conj(S35/(3*van));
  Ib5= conj(S35/(3*vbn));
  Ic5= conj(S35/(3*vcn));

  disp("\nConsumidor 5");
  disp(["S= ", num2str(abs(S35)), " [VA]"]);
  disp(["P= ", num2str(P35), " [W]"]);
  disp(["Q= ", num2str(Q35), " [VAR]"]);
  disp(["F.P= ", num2str(fp5)]);
  disp("\n=====================================================================");

  %% ---------------------------------------------------------------------------

endfunction
