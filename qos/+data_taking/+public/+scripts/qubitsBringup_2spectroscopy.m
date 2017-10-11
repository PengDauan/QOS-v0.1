% bring up qubits - spectroscopy
% Yulin Wu, 2017/3/11
%%
setQSettings('r_avg',800);
q = 'q6';
f01 = getQSettings('f01',q);
freq = f01-15e6:0.2e6:f01+15e6;
spectroscopy1_zpa('qubit',q,'biasAmp',[0],'driveFreq',[freq],...
       'dataTyp','P','gui',true,'save',true);  % dataTyp: S21 or P
% spectroscopy1_zpa('qubit','q2'); % lazy mode
%%
spectroscopy1_power('qubit','q7',...
       'biasAmp',0,'driveFreq',[4.75e9:0.2e6:5.4e9],...
       'uSrcPower',[5:1:20],...
       'dataTyp','P','gui',true,'save',true); % dataTyp: S21 or P
%%
setQSettings('r_avg',800);
f01 = getQSettings('f01','q6');
freq = f01-10e6:0.3e6:f01+10e6;
spectroscopy111_zpa('biasQubit','q4','biasAmp',[-15000:5000:15000],...
       'driveQubit','q6','driveFreq',[freq],...
       'readoutQubit','q6','dataTyp','P',...
       'notes','q4->q6 zpls cross talk','gui',true,'save',true);
%%
setQSettings('r_avg',500);
q = 'q4';
% f01 = getQSettings('f01',q);
% freq = f01-120e6:0.5e6:f01-10e6;
freq = 4.1e9:0.5e6:4.4e9;
spectroscopy1_zdc('qubit',q,'biasAmp',[-19000:1000:-13000],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true); % dataTyp: S21 or P
%%
setQSettings('r_avg',500);
spectroscopy_zpa_withPi('qubit','q6','biasAmp',[2.4287e+04],...
'driveFreq',[4.04e9 - 80e6: 6e6: 4.04e9 + 80e6],...
'driveDelay',50,'zLength',200,...
'notes','','gui',true,'save','');
%%
temp.spectroscopy_zpa_withPi_driveDelay('qubit','q6','biasAmp',2.4287e+04,...
      'driveFreq',[4e9],...
      'driveDelay',[-200:100:600],'zLength',200,...
      'notes','','gui',true,'save',true);
%%
setQSettings('r_avg',500,'q9');
% pf01 = [-0.55133,188.64,5.175e9];
% q9zAmp2f01 = @(x) polyval(pf01,x);
pf01 = [-0.46619,0.35418,5.2286e9];
q7zAmp2f01 = @(x) polyval(pf01,x);
% pf01 = [-0.33858,-16646,4.566e+09];
% q6zAmp2f01 = @(x) polyval(pf01,x);
spectroscopy1_zpa_bndSwp('qubit',q,...
       'swpBandCenterFcn',q7zAmp2f01,'swpBandWdth',10e6,...
       'biasAmp',[-5000:2000:32000],'driveFreq',[4.5e9:0.5e6:5.3e9],...
       'gui',true,'save',true);
% spectroscopy1_zpa_bndSwp('qubit','q2',...
%        'swpBandCenterFcn',q2zAmp2f01,'swpBandWdth',120e6,...
%        'biasAmp',[6000:50:9750],'driveFreq',[5.56e9:0.2e6:5.77e9],...
%        'gui',false,'save',true);
%%
spectroscopy1_zpa_auto('qubit','q6','biasAmp',-3e4:500:3e4,...
    'swpBandWdth',40e6,'swpBandStep',1e6,...
    'r_avg',500,'gui',true);


