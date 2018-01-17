classdef qCloudPlatform < handle
    % Quantum Computing Cloud Platform:
    % http://quantumcomputer.ac.cn/index.html
    
% Copyright 2018 Yulin Wu, USTC
% mail4ywu@gmail.com/mail4ywu@icloud.com

    properties(SetAccess = private)
        started = false
        running = false
    end
    properties (SetAccess = private, GetAccess = private)
        qCloudSettingsPath
        connection
        logger
        
        user
        qosSettingsRoot
    end
    methods (Access = private)
        function obj = qCloudPlatform(qCloudSettingsPath)
            obj.qCloudSettingsPath = qCloudSettingsPath;
            logPath = qes.util.loadSettings(qCloudSettingsPath, 'logPath');
            pushoverAPIKey = qes.util.loadSettings(qCloudSettingsPath, {'pushover','key'});
            pushoverReceiver = qes.util.loadSettings(qCloudSettingsPath, {'pushover','receiver'});
            obj.user = qes.util.loadSettings(qCloudSettingsPath, 'user');
            obj.qosSettingsRoot = qes.util.loadSettings(qCloudSettingsPath, 'qosSettingsRoot');
            logfile = fullfile(logPath, [datestr(now,'yyyy-mm-dd_HH-MM-SS'),'_qos.log']);
            logger = qes.util.log4qCloud.getLogger(logfile);
            logger.setFilename(logfile);
            logger.setCommandWindowLevel(logger.INFO);
            logger.setLogLevel(logger.INFO);  
            logger.setNotifier(pushoverAPIKey,pushoverReceiver);
            obj.logger = logger;
        end
    end
    methods (Static = true)
        function obj = GetInstance(qCloudSettingsPath)
            persistent instance;
            if isempty(instance) || ~isvalid(instance)
                if nargin < 1 || ~isdir(qCloudSettingsPath)
                    throw(MException('QOS:qCloudPlatform:notEnoughArguments','qCloudSettingPath not given or not a valid path.'))
                else
                    instance = qcp.qCloudPlatform(qCloudSettingsPath);
                end
            end
            obj = instance;
        end
    end
    methods
        function Start(obj)
            obj.logger.info('qCloud.startup','initilizing QOS settings...');
            try
                QS = qes.qSettings.GetInstance(obj.qosSettingsRoot);
            catch ME
                if strcmp(ME.identifier,'QOS:qSettings:invalidRootPath')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            try
                QS.user = obj.user;
            catch ME
                if strcmp(ME.identifier,'QOS:qSettings:invalidUser')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            try
                selectedSession = qes.util.loadSettings(obj.qosSettingsRoot, {QS.user,'selected'});
            catch ME
                if strcmp(ME.identifier,'QOS:loadSettings:settingsNotFound')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            if isempty(selectedSession)
                obj.logger.fatal('qCloud.startup', sprintf('no selected session for %s in QOS settings.', QS.user));
                obj.logger.notify();
                throw(MException('QOS:qCloud:startup',sprintf('no selected session for %s in QOS settings.',QS.user)));
            end
            try
                sessionDate = datenum(selectedSession(2:end),'yymmdd');
                newSession = ['s',datestr(now,'yymmdd')];
                if sessionDate < floor(now)
                    qes.util.copySession(selectedSession,newSession);
                end
            catch ME
                if strfind(ME.identifier,'QOS:copySession:')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            try
                QS.SS(newSession);
            catch ME
                if strfind(ME.identifier,'QOS:qSettings:')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            try
                selectedHwSettings = qes.util.loadSettings(QS.root,{'hardware','selected'});
            catch ME
                if strcmp(ME.identifier,'QOS:loadSettings:settingsNotFound')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            if isempty(selectedHwSettings)
                obj.logger.fatal('qCloud.startup', 'no selected hardware settings.');
                obj.logger.notify();
                throw(MException('QOS:qCloud:startup','no selected hardware settings.'));
            end
            obj.logger.info('qCloud.startup','initilizing QOS settings done.');
        %%
            obj.logger.info('qCloud.startup','creating hardware objects...');
            try
                QS.CreateHw();
            catch ME
                if strfind(ME.identifier, 'QOS:loadSettings:')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                elseif strfind(ME.identifier, 'QOS:hwCreator:illegalHaredwareSettings')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            obj.logger.info('qCloud.startup','creating hardware objects done.');

        %%  just in case some dc source levels has changed
            obj.logger.info('qCloud.startup','setting qubit DC bias...');
            qNames = data_taking.public.util.allQNames();
            for ii = 1:numel(qNames)
                try
                    data_taking.public.util.setZDC(qNames{ii});
                catch ME
                    obj.logger.fatal('qCloud.startup', sprintf('error in set dz bias for qubit %s: %s', qNames{ii}, ME.message));
                    obj.logger.notify();
                    rethrow(ME);
                end
            end
            obj.logger.info('qCloud.startup','setting qubit DC bias done.');
            %%

        %% 
           obj.connection = qcp.qCloudPlatformConnection.GetInstance();
           obj.started = true;
           obj.logger.info('qCloud.startup','qCloud backend started up successfully.');
           obj.logger.notify();
        end
        function Restart(obj)
            obj.logger.info('qCloud.restart','restarting qCloud...');
            if obj.running % otherwise STANDBY
                obj.logger.info('qCloud.restart','qCloud running, stopping qCloud...');
                obj.Stop();
            end
            try
                QS = qes.qSettings.GetInstance();
                QS.delete();
            catch
            end
            obj.logger.info('qCloud.restart','deleting hardware objects...');
            hwObjs = qes.qHandle.FindByClass('qes.hwdriver.hardware');
            for ii = 1:numel(hwObjs)
                try
                    hwObjs{ii}.delete();
                catch ME
                    obj.logger.warn('qCloud.restart',['error at deleting hardware: ', ME.message]);
                end
            end
            obj.logger.info('qCloud.restart','hardware deleted.');
            obj.Start();
            obj.logger.info('qCloud.restart','qCloud restarted.');
        end
        function Run(obj)
			
        end
        function Stop(obj)
            
            
            obj.logger.info('qCloud.restart','qCloud stopped.');
        end
    end
end