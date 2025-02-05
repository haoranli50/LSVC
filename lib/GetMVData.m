function [X,Y] = GetMVData(name,varargin)
if nargin>1
    save_file = varargin{1};
else
    save_file = [userpath '/dataset/multiView'];
end

% �����ļ���
if ~exist(save_file,'dir')
    mkdir(save_file);
end

if ~exist([save_file '/' name],'file')
    ftpobj = GetFTPObj();
    ftpobj.cd('/dataset/multiView');
    file = ftpobj.dir(name);
    if isempty(file)
        disp('û���ҵ����ݼ�');
        error('Error. Can not find %s.',name);
    else
        disp(['�������ض���ͼ���ݼ�:' name]);
        mget(ftpobj,name,save_file);
        ftpobj.close();
        disp(['���ݼ�' name '�������']);
    end
end
X_struct = load([save_file '/' name]);
X = X_struct.X;
Y = X_struct.Y;
end

