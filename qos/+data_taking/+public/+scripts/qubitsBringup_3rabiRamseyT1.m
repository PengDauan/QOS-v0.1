% bring up qubits - spectroscopy
% Yulin Wu, 2017/3/11
amp = [0:500:3e4];
rabi_amp1('qubit','q7','biasAmp',[0],'biasLonger',20,...
      'xyDriveAmp',amp,'detuning',[0],'driveTyp','X/2',...
      'dataTyp','S21','gui',true,'save',true);
% rabi_amp1('qubit','q2','xyDriveAmp',[0:500:3e4]);  % lazy mode
%%
rabi_long1_amp('qubit','q9','biasAmp',0,'biasLonger',5,...
      'xyDriveAmp',[2000],'xyDriveLength',[1:1:32],...
      'dataTyp','P','gui',true,'save',true);
%%
rabi_long1_freq('qubit','q6','biasAmp',0,'biasLonger',5,...
      'xyDriveAmp',8000,'xyDriveLength',[1:4:2000],...
      'detuning',[-10:1:10]*1e6,...
      'dataTyp','P','gui',true,'save',true);
%%
setQSettings('r_avg',3000);
data=ramsey('qubit','q1','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:50:20000],'detuning',[1]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
%%
setQSettings('r_avg',3000);
ramsey('qubit','q1','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:100:20e3],'detuning',[1]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true); % P or Phase
%%
ramsey_dz('qubit','q8',...
       'time',[40],'detuning',[0],'phaseOffset',0,...
       'dataTyp','P',...   % S21 or P
       'gui','true','save','true');
%%
spin_echo('qubit','q8','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:15000],'detuning',[2]*1e6,...
      'notes','','gui',true,'save',true);
%%
setQSettings('r_avg',3000);
T1_1('qubit','q1','biasAmp',[0],'biasDelay',20,'time',[20:1000:2.8e4],... % [20:200:2.8e4]
      'gui',true,'save',true);
%%
resonatorT1('qubit','q2',...
      'swpPiAmp',1.8e3,'biasDelay',16,'swpPiLn',28,'time',[0:10:2000],...
      'gui',true,'save',true)
%%
qqSwap('qubit1','q7','qubit2','q8',...
       'biasQubit',1,'biasAmp',[-1.7e4:-100:-2.5e4],'biasDelay',10,...
       'q1XYGate','X','q2XYGate','X',...
       'swapTime',[0:10:100],'readoutQubit',2,...
       'notes','','gui',true,'save',true);