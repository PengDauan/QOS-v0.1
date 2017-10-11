function SendWave(obj,chnl,DASequence,isI)
    % send waveform to awg. this method is intended to be called within
    % the method SendWave of class waveform only.

% Copyright 2015 Yulin Wu, Institute of Physics, Chinese  Academy of Sciences
% mail4ywu@gmail.com/mail4ywu@icloud.com

	DASequence.xfrFunc = obj.xfrFunc{chnl};
    DASequence.padLength = obj.padLength(chnl);
    TYP = lower(obj.drivertype);

    switch TYP % now we only support our DAC boards
        case {'ustc_da_v1'} % for ustc_da_v1, waveform vpp is -32768, 32768
			if isI
				outputDelay = DASequence.outputDelay(1);
			else
				outputDelay = DASequence.outputDelay(2);
			end
            if DASequence.outputDelayByHardware
                outputDelayStep = obj.interfaceobj.outputDelayStep;
                output_delay_count = min(floor(outputDelay/outputDelayStep));
                hardware_delay = output_delay_count*outputDelayStep;
                software_delay = outputDelay - hardware_delay;
            else
                output_delay_count = 0;
                software_delay = outputDelay;
            end
			samples = DASequence.samples();
			if isI
				samples = samples(1,:);
			else
				samples = samples(2,:);
            end
            WaveformData = uint16([zeros(1,software_delay),samples]+32768);
            
             % version specific
            WaveformData(32e3:end) = [];
            
%             % to plot the waveform data
%             global OPERATOR_SHOW_WAVEDATA;
%             OPERATOR_SHOW_WAVEDATA = true;
%             persistent ax;
%             try
%                 if OPERATOR_SHOW_WAVEDATA
%                     if isempty(ax) || ~isvalid(ax)
%                         h = figure();
%                         ax = axes('parent',h);
%                     end
% 
%                     hold(ax,'on');
%                     plot(ax,WaveformData(1:end));
%                 end
%             catch
%             end
            
            % setChnlOutputDelay before SendWave, otherwise output delay
            % will not take effect till next next Run:
            % SendWave(...); setChnlOutputDelay(...,100);
            % Run(...); % oops, delay not 100*4 ns
            % SendWave(...); setChnlOutputDelay(...,200);
            % Run(..); % now delay is 100*4 ns, not 200*4 ns,
            % 200*4 ns will be the delay amount of next Run.
            % this is a da driver bug, might be corrected in a future version. 
            obj.interfaceobj.setChnlOutputDelay(chnl,output_delay_count);
            obj.interfaceobj.SendWave(chnl,WaveformData);
        otherwise
            throw(MException('QOS_awg:unsupportedAWG','Unsupported awg.'));
    end
    
end