% bring up qubits - spectroscopy
% Yulin Wu, 2017/3/11
%%

setQSettings('r_avg',700);
q = 'q1';
f01 = getQSettings('f01',q);
freq = f01 - 3e6:0.1e6:f01 + 2e6;
spectroscopy1_zpa('qubit',q,'biasAmp',700*ones(1,40),'driveFreq',[freq],...
       'dataTyp','P','gui',true,'save',true);
%%
setQSettings('r_avg',700);
for qc = {'q1','q2','q3','q4','q5','q6','q7','q8','q9','q10','q11'}
    q = qc{1};
    for ii = 1:numel(qNames)
        setZDC(qNames{ii});
    end
    f01 = getQSettings('f01',q);
    freq = f01-2e6:0.02e6:f01+2e6;
    zdcamp = getQSettings('zdc_amp',q);
    biasamp = zdcamp-500:100:zdcamp+500;
    spectroscopy1_zdc('qubit',q,'biasAmp',biasamp,'driveFreq',[freq],...
           'dataTyp','S21','gui',true,'save',true); % dataTyp: S21 or P
    % spectroscopy1_zpa('qubit','q2'); % lazy mode
end
%%
spectroscopy1_power('qubit','q7',...
       'biasAmp',0,'driveFreq',[4.75e9:0.2e6:5.4e9],...
       'uSrcPower',[5:1:20],...
       'dataTyp','P','gui',true,'save',true); % dataTyp: S21 or P
%%
biasQ = 'q2';
targetQ = 'q3';
f01 = getQSettings('f01',targetQ);
freq = f01-10e6:0.3e6:f01+3e6;
spectroscopy111_zpa('biasQubit',biasQ,'biasAmp',[0:10000:30000],... 
       'driveQubit',targetQ,'driveFreq',[freq],...
       'readoutQubit',targetQ,'dataTyp','P',...
       'notes',[biasQ,'->',targetQ,' zpls cross talk'],'gui',true,'save',true);
%%
setQSettings('r_avg',500);
q = 'q2';
f01 = getQSettings('f01',q);
freq = f01-2e6:0.05e6:f01+2e6;
biasAmp = 1.462e4;
spectroscopy1_zdc('qubit',q,'biasAmp',biasAmp,'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true); % dataTyp: S21 or P
%%
setQSettings('r_avg',500);
spectroscopy_zpa_withPi('qubit','q2','biasAmp',[2.4287e+04],...
'driveFreq',[4.04e9 - 80e6: 6e6: 4.04e9 + 80e6],...
'driveDelay',50,'zLength',200,...
'notes','','gui',true,'save','');
%%
temp.spectroscopy_zpa_withPi_driveDelay('qubit','q6','biasAmp',2.4287e+04,...
      'driveFreq',[4e9],...
      'driveDelay',[-200:100:600],'zLength',200,...
      'notes','','gui',true,'save',true);
%%
setQSettings('r_avg',500);
% pf01 = [-0.55133,188.64,5.175e9];
% q9zAmp2f01 = @(x) polyval(pf01,x);
pf01 = [-0.46619,0.35418,5.2286e9];
q7zAmp2f01 = @(x) polyval(pf01,x);
% pf01 = [-0.33858,-16646,4.566e+09];
% q6zAmp2f01 = @(x) polyval(pf01,x);
spectroscopy1_zpa_bndSwp('qubit',q,...
       'swpBandCenterFcn',q7zAmp2f01,'swpBandWdth',10e6,...
       'biasAmp',[-5000:500:32000],'driveFreq',[4.5e9:0.5e6:5.3e9],...
       'gui',true,'save',true);
% spectroscopy1_zpa_bndSwp('qubit','q2',...
%        'swpBandCenterFcn',q2zAmp2f01,'swpBandWdth',120e6,...
%        'biasAmp',[6000:50:9750],'driveFreq',[5.56e9:0.2e6:5.77e9],...
%        'gui',false,'save',true);
%%
setQSettings('r_avg',700);
spectroscopy1_zpa_auto('qubit','q9','biasAmp',-1e4:200:1e4,...
    'swpInitf01',[],'swpInitBias',0,...
    'swpBandWdth',10e6,'swpBandStep',0.1e6,...
    'dataTyp','P','r_avg',700,'gui',true);


