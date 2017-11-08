hrc = heartRateCalculator(10);
testValues1 = (sin(0:0.1:5/2*pi) + 1)';
testValues2 = (sin(5/2*pi:0.1:3*pi) + 1)';
tg = threshGuard(hrc);
tg.detectPeaks(testValues1, 1.3);
tg.detectPeaks(testValues2, 1.3);