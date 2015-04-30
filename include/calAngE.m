function ang_e = calAngE(gtNormal, testNormal, idd)
    [m, n, c] = size(gtNormal);
    gt = reshape(gtNormal, [], c);
    test = reshape(testNormal, [], c); 
    ang_e =zeros(m*n, 1);
    for l = 1:length(idd)
        ang_e(idd(l)) = acos(gt(idd(l), :)*test(idd(l), :)')*180/pi;
    end
    ang_e = reshape(ang_e, m, n);
end