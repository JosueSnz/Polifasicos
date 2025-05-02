function [Ia4,Ib4,Ic4,S34,P34,Q34,fp4]= consumidor_4(van,vbn,vcn)

  %% ---------------------------------------------------------------------------

  %% Consumidor 4
  W1= 35000;
  W2= 18000;

  %% Potencias e fp
  P34= W1+W2;
  Q34= sqrt(3)*(W1-W2);
  S34= P34+(Q34*i);
  fp4= cos(angle(S34));

  %% Corrente de cada fase
  Ia4= conj(S34/(3*van));
  Ib4= conj(S34/(3*vbn));
  Ic4= conj(S34/(3*vcn));

  disp("\nConsumidor 4");
  disp(["S= ", num2str(abs(S34)), " [VA]"]);
  disp(["P= ", num2str(P34), " [W]"]);
  disp(["Q= ", num2str(Q34), " [VAR]"]);
  disp(["F.P= ", num2str(fp4)]);

  %% ---------------------------------------------------------------------------

endfunction
