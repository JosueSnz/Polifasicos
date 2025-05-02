function correntes= formatar(Ia1, Ib1, Ic1, Ia2, Ib2, Ic2, Ia3, Ib3, Ic3, Ia4, Ib4, Ic4, Ia5, Ib5, Ic5, banco, linha)

  vetor= [Ia1, Ib1, Ic1, Ia2, Ib2, Ic2, Ia3, Ib3, Ic3, Ia4, Ib4, Ic4, Ia5, Ib5, Ic5];
  for j= 1:5
    ia= sprintf("%.3f∠%.3f", abs(vetor(j)), rad2deg(angle(vetor(j))));
    ib= sprintf("%.3f∠%.3f", abs(vetor(j)), rad2deg(angle(vetor(j))));
    ic= sprintf("%.3f∠%.3f", abs(vetor(j)), rad2deg(angle(vetor(j))));

    correntes(j)= struct("Consumidor", j, "Ia", ia, "Ib", ib, "Ic", ic);
  endfor

  iaY= sprintf("%.3f∠%.3f", abs(banco(1).("Ia Y")), rad2deg(angle(banco(1).("Ia Y"))));
  ibY= sprintf("%.3f∠%.3f", abs(banco(1).("Ib Y")), rad2deg(angle(banco(1).("Ib Y"))));
  icY= sprintf("%.3f∠%.3f", abs(banco(1).("Ic Y")), rad2deg(angle(banco(1).("Ic Y"))));

  iaT= sprintf("%.3f∠%.3f", abs(banco(1).("Ia T")), rad2deg(angle(banco(1).("Ia T"))));
  ibT= sprintf("%.3f∠%.3f", abs(banco(1).("Ib T")), rad2deg(angle(banco(1).("Ib T"))));
  icT= sprintf("%.3f∠%.3f", abs(banco(1).("Ic T")), rad2deg(angle(banco(1).("Ic T"))));

  iaYl= sprintf("%.3f∠%.3f", abs(linha(1).("Ia")), rad2deg(angle(linha(1).("Ia"))));
  ibYl= sprintf("%.3f∠%.3f", abs(linha(1).("Ib")), rad2deg(angle(linha(1).("Ib"))));
  icYl= sprintf("%.3f∠%.3f", abs(linha(1).("Ic")), rad2deg(angle(linha(1).("Ic"))));

  iaTl= sprintf("%.3f∠%.3f", abs(linha(2).("Ia")), rad2deg(angle(linha(2).("Ia"))));
  ibTl= sprintf("%.3f∠%.3f", abs(linha(2).("Ib")), rad2deg(angle(linha(2).("Ib"))));
  icTl= sprintf("%.3f∠%.3f", abs(linha(2).("Ic")), rad2deg(angle(linha(2).("Ic"))));

  correntes(6)= struct("Consumidor", "Capacitor Y", "Ia", iaY, "Ib", ibY, "Ic", icY);
  correntes(7)= struct("Consumidor", "Capacitor T", "Ia", iaT, "Ib", ibT, "Ic", icT);
  correntes(8)= struct("Consumidor", "Total linha Y", "Ia", iaYl, "Ib", ibYl, "Ic", icYl);
  correntes(9)= struct("Consumidor", "Total linha T", "Ia", iaTl, "Ib", ibTl, "Ic", icTl);

endfunction
