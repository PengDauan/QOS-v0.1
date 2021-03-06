# _QOS_ v0.1
QOS(Quantum Operating System) is a softwave package for operating supperconducting quantum computers. 
*This version of QOS is obsolete, a complete new version will soon be available: [THE ALL NEW QOS](https://github.com/YulinWu/QOS)*
## Code snippets
#### These are not pseudo code, not simulations, they perform real quantum computing experiments:
necessary imports are ignored
```
P = X2m(q)*I(q)*X2p(q);             % produces a process(a Ramsey experiment)
R = resonatorReadout(q);            % produces a state probability measurement
R.delay = P.length;
P.Run();                            % Runs the Ramsey process
result = R();                       % gets the measured state probability as 'result'
%%
P = X2m(q)*I(q)*X(q)*I(q)*X2p(q);   % Spin echo
P = (X(q1).*X(q2))*CZ(q1,q2);       % CZ leakage
%%
R = stateTomography({q1,q2});		   
data = R();                         % measures state tomo
R = processTomography({q1,q2},P);		
data = R();                         % measrues process tomo for process P
R = randBenchMarking(q,P,m,k);			
data = R();                         % measrues RB for gate P(one of the Clifford group)
```
code snippet that runs a Ramsey experiment on a real quantum processor
<a href="url"><img src="https://github.com/YulinWu/QOS-v0.1/blob/master/qos/img/RamseyCodeSnippet.png" align="left"  width="500" ></a>
<img src="https://github.com/YulinWu/QOS-v0.1/blob/master/qos/img/400dpiLogoCropped.png" align="left"  width="600" />
<a href="url"><img src="https://github.com/YulinWu/QOS-v0.1/blob/master/qos/img/RegistryEditor.PNG" align="left"  width="500" ></a>
<a href="url"><img src="https://github.com/YulinWu/QOS-v0.1/blob/master/qos/img/DataViewer.PNG" align="left"  width="500" ></a>
<a href="url"><img src="https://github.com/YulinWu/QOS-v0.1/blob/master/qos/img/sequence_demo.png?raw=true" align="left"  width="1000" ></a>






