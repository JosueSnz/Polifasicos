function [Ia2,Ib2,Ic2,S32,P32,Q32,fp2]= consumidor_2(vab,vbc,vca)

  %% ---------------------------------------------------------------------------

  %% Consumidor 2, sem a geração fotovoltaica
  P32= 55000;
  fp2= 0.89;

  %% Potencias e fp
  S2= P32/fp2;
  angulo2= acos(fp2);
  Q32= S2*sin(angulo2);
  S32= P32+(Q32*i);

  %% Corrente de cada fase
  Ia2= conj(S32/(sqrt(3)*vab));
  Ib2= conj(S32/(sqrt(3)*vbc));
  Ic2= conj(S32/(sqrt(3)*vca));

  disp("\nConsumidor 2");
  disp(["S= ", num2str(abs(S32)), " [VA]"]);
  disp(["P= ", num2str(P32), " [W]"]);
  disp(["Q= ", num2str(Q32), " [VAR]"]);
  disp(["F.P= ", num2str(fp2)]);

  %% ---------------------------------------------------------------------------

endfunction
