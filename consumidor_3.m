function [Ia3,Ib3,Ic3,S33,P33,Q33,fp3]= consumidor_3(vab,van)

  %% ---------------------------------------------------------------------------

  %% Consumidor 3
  Ia3= 2.260266434-0.6056365655i;
  Ib3= -1.654629868-1.654629868i;
  Ic3= -0.6056365655+2.260266434i;

  %% Potencias e fp
  phi= abs(angle(van)-angle(Ia3));
  S3= sqrt(3)*abs(vab)*abs(Ia3);
  P33= sqrt(3)*abs(vab)*abs(Ia3)*cos(phi);
  Q33= sqrt(3)*abs(vab)*abs(Ia3)*sin(phi);
  S33= P33+(Q33*i);
  fp3= cos(phi);

  disp("\nConsumidor 3");
  disp(["S= ", num2str(abs(S33)), " [VA]"]);
  disp(["P= ", num2str(P33), " [W]"]);
  disp(["Q= ", num2str(Q33), " [VAR]"]);
  disp(["F.P= ", num2str(fp3)]);

  %% ---------------------------------------------------------------------------

endfunction
