function linha= impedancia(banco,Ia1,Ib1,Ic1,Ia2,Ib2,Ic2,Ia3,Ib3,Ic3,Ia4,Ib4,Ic4,Ia5,Ib5,Ic5)

  %% ---------------------------------------------------------------------------

  %% Impedancia da linha
  zl= 25+21i;

  for j= 1:2

    if j<=1
      tipo= "estrela";
      Ial= Ia1+Ia2+Ia3+Ia4+Ia5+(banco(1).("Ia Y"));
      Ibl= Ib1+Ib2+Ib3+Ib4+Ib5+(banco(1).("Ib Y"));
      Icl= Ic1+Ic2+Ic3+Ic4+Ic5+(banco(1).("Ic Y"));
    else
      tipo= "delta";
      Ial= Ia1+Ia2+Ia3+Ia4+Ia5+(banco(1).("Ia T"));
      Ibl= Ib1+Ib2+Ib3+Ib4+Ib5+(banco(1).("Ib T"));
      Icl= Ic1+Ic2+Ic3+Ic4+Ic5+(banco(1).("Ic T"));
    endif

    vza= zl*Ial;
    vzb= zl*Ibl;
    vzc= zl*Icl;

    Plta= 25*(abs(Ial)^2);
    Qlta= 21*(abs(Ial)^2);

    Pltb= 25*(abs(Ibl)^2);
    Qltb= 21*(abs(Ibl)^2);

    Pltc= 25*(abs(Icl)^2);
    Qltc= 21*(abs(Icl)^2);

    Plt= Plta+Pltb+Pltc;
    Qlt= Qlta+Qltb+Qltc;
    Slt= Plt+(Qlt*i);
    fpl= cos(angle(Slt));

    Ialf= sprintf("%.3f∠%.3f", abs(Ial), rad2deg(angle(Ial)));
    Iblf= sprintf("%.3f∠%.3f", abs(Ibl), rad2deg(angle(Ibl)));
    Iclf= sprintf("%.3f∠%.3f", abs(Icl), rad2deg(angle(Icl)));

    vzaf= sprintf("%.3f∠%.3f", abs(vza), rad2deg(angle(vza)));
    vzbf= sprintf("%.3f∠%.3f", abs(vzb), rad2deg(angle(vzb)));
    vzcf= sprintf("%.3f∠%.3f", abs(vzc), rad2deg(angle(vzc)));

    disp(["\nImpedancia de linha ", tipo]);
    disp(["S= ", num2str(abs(Slt)), " [VA]"]);
    disp(["P= ", num2str(Plt), " [W]"]);
    disp(["Q= ", num2str(Qlt), " [VAR]"]);
    disp(["F.P= ", num2str(fpl)]);
    disp("\n=====================================================================");


    linha(j)= struct("Conexao", tipo, "W", Plt, "Q", Qlt, "S", Slt, "FP", fpl, "vza", vza, "vzb", vzb, "vzc", vzc, "Ia", Ial, "Ib", Ibl, "Ic", Icl);
  endfor

  %% ---------------------------------------------------------------------------
