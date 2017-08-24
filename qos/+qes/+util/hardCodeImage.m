function hardCodeImage(imagefile,codefilename,codefilepath,icnsize)
    % HardCodeImage hard code a image(png, other formats not tested) into a matlab code file
    % imagefile: full path of image file
    % example:
    % HardCodeImage('..\qes\doc\all_icons_png\square\image200.png','QOS_sqrbig','E:..\qes\+icons');

% Copyright 2015 Yulin Wu, Institute of Physics, Chinese  Academy of Sciences
% mail4ywu@gmail.com/mail4ywu@icloud.com

    if ~ischar(codefilename)
        error('codefilename is not a character string.');
    end
    if length(codefilename) < 2 || ~strcmpi(codefilename(end-1:end),'.m')
        codefilename = [codefilename,'.m'];
    end
    if ~isvarname(codefilename(1:end-2))
        error([codefilename,' is not acceptable matlab code file name.']);
    end
    if ~exist(codefilepath,'dir')
        error([codefilepath,' not exist.']);
    end
    codefilefullname = fullfile(codefilepath,codefilename);
    [im,~,alpha] = imread(imagefile);
    im  = double(im);
    if ~isempty(alpha)
        alpha(alpha>0) = 1;
        alpha = ~logical(alpha);
        for ii = 1:3
            temp = im(:,:,ii);
            temp(alpha) = NaN;
            im(:,:,ii) = temp;
        end
    end
    if nargin > 4 % scale to size specified by icnsize
        im = imresize(im,icnsize,'nearest');
    end
    im  =  im/255;
    fid = fopen(codefilefullname,'w');
    if fid < 0
        error('unable to create the code file on disk.');
    end
    fprintf(fid,['function CData = ',codefilename(1:end-2),'()\n']);
    fprintf(fid,['\t%%',codefilename(1:end-2),'\n']);
    fprintf(fid,['\t%%Image CData code generated by hardCodeImage\n\n']);
    fprintf(fid,'\n');
    sz = size(im);
    for ii = 1:3
        fprintf(fid,['\tCData(:,:,',num2str(ii,'%0.0f'),')=[...\n']);
        for jj = 1:sz(1)
            str = '\t\t';
            for kk = 1:sz(2)
                if isnan(im(jj,kk,ii))
                    str = [str,'NaN'];
                elseif im(jj,kk,ii) && round(im(jj,kk,ii)) ~= im(jj,kk,ii)
                    str = [str,num2str(im(jj,kk,ii),'%0.3f')];
                else
                    str = [str,num2str(im(jj,kk,ii),'%0.0f')];
                end
                if kk ~= sz(2)
                    str = [str,'\t'];
                end
            end
            fprintf(fid,str);
            fprintf(fid,';...\n');
        end
        fprintf(fid,'\t];\n');
    end
    fprintf(fid,'end');
    fclose(fid);
end