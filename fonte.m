function consumo= fonte(linha,banco,S31,S32,S33,S34,S35,van,vbn,vcn)

  %% ---------------------------------------------------------------------------

  %% Fonte

  for j= 1:2
    P3f= real(S31+S32+S33+S34+S35+linha(j).("S"));
    Q3f= imag(S31+S32+S33+S34+S35+linha(j).("S"))-(banco(1).("VARc"));
    S3f= P3f+(Q3f*i);
    fpf= cos(angle(S3f));

    Ean= linha(j).("vza")+van;
    Ecn= linha(j).("vzb")+vcn;
    Ebn= linha(j).("vzc")+vbn;

    if j <= 1
      tipo= "estrela";
    else
      tipo= "delta";
    endif

    disp(["\nFonte ", tipo]);
    disp(["S= ", num2str(abs(S3f)), " [VA]"]);
    disp(["P= ", num2str(P3f), " [W]"]);
    disp(["Q= ", num2str(Q3f), " [VAR]"]);
    disp(["F.P= ", num2str(fpf)]);

    disp(["\nTensão fonte ", tipo]);
    disp(["Ean= ", num2str(abs(Ean)),"∠", num2str(rad2deg(angle(Ean))), " [V]"]);
    disp(["Ebn= ", num2str(abs(Ebn)),"∠", num2str(rad2deg(angle(Ebn))), " [V]"]);
    disp(["Ecn= ", num2str(abs(Ecn)),"∠", num2str(rad2deg(angle(Ecn))), " [V]"]);

    disp(["\nCorrente linha ", tipo]);
    disp(["Ia= ", num2str(abs(linha(j).("Ia"))),"∠", num2str(rad2deg(angle(linha(j).("Ia")))), " [A]"]);
    disp(["Ib= ", num2str(abs(linha(j).("Ib"))),"∠", num2str(rad2deg(angle(linha(j).("Ib")))), " [A]"]);
    disp(["Ic= ", num2str(abs(linha(j).("Ic"))),"∠", num2str(rad2deg(angle(linha(j).("Ic")))), " [A]"]);

    disp("\n=====================================================================");

    consumo(j)= struct("Conexão", tipo, "W", P3f, "Q", Q3f, "S", abs(S3f), "FP", fpf, "Ean", Ean, "Ebn", Ebn, "Ecn", Ecn);
  endfor
  %% ---------------------------------------------------------------------------

endfunction
