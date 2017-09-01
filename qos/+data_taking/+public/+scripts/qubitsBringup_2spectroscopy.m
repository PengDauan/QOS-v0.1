% bring up qubits - spectroscopy
% Yulin Wu, 2017/3/11
%% 
f01 = getQSettings('f01',q);
freq = f01-5e6:0.2e6:f01+5e6;
spectroscopy1_zpa('qubit',q,'biasAmp',[0:2000:2e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);  % dataTyp: S21 or P
% spectroscopy1_zpa('qubit','q2'); % lazy mode
%%
spectroscopy1_power('qubit','q6',...
       'biasAmp',0,'driveFreq',[4.75e9:0.2e6:5.4e9],...
       'uSrcPower',[5:1:20],...
       'dataTyp','P','gui',true,'save',true); % dataTyp: S21 or P
%%
spectroscopy111_zpa('biasQubit','q9','biasAmp',[-5000:1000:5000],...
       'driveQubit','q8','driveFreq',[],...
       'readoutQubit','q8''dataTyp','P',...
       'notes','q9->q8 zpls cross talk','gui',true,'save',true);
%%
f01 = getQSettings('f01',q);
freq = f01-10e6:0.5e6:f01+3e6;
spectroscopy1_zdc('qubit',q,'biasAmp',[-0e4:200:0.4e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true); % dataTyp: S21 or P
%%
% q7zAmp2f01 =@(x) - 0.46539*x.^2 + 2709.5*x + 5.222e+09;
% q8zAmp2f01 =@(x) - 0.2994*x.^2 + 1890.6*x + 4.7344e+09;
% q9_1zAmp2f01 = @(x) - 0.727*x.^2 - 1.83e+04*x + 5.02e+09;
q9_zpa2f01 = @(x) - 0.55133*x.^2 + 188.64*x + 5.175e+09;
q9_zpa2f02 = @(x) - 0.55133*x.^2 + 188.64*x + 5.175e+09 - 119e6;
q8_zpa2f01 = @(x) - 0.401*x.^2 + 31.43*x + 4.736e+09;
q6_zpa2f01_s = @(x) (- 1.6e-05*x + 4.5747)*1e9;
spectroscopy1_zpa_bndSwp('qubit','q9',...
       'swpBandCenterFcn',q6_zpa2f01_s,'swpBandWdth',20e6,...
       'biasAmp',[-5000:500:32000],'driveFreq',[4.65e9:0.2e6:5.2e9],...
       'gui',true,'save',true);
% spectroscopy1_zpa_bndSwp('qubit','q2',...
%        'swpBandCenterFcn',q2zAmp2f01,'swpBandWdth',120e6,...
%        'biasAmp',[6000:50:9750],'driveFreq',[5.56e9:0.2e6:5.77e9],...
%        'gui',false,'save',true);
