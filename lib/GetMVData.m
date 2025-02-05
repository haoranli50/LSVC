function [X,Y] = GetMVData(name,varargin)
if nargin>1
    save_file = varargin{1};
else
    save_file = [userpath '/dataset/multiView'];
end

% 创建文件夹
if ~exist(save_file,'dir')
    mkdir(save_file);
end

if ~exist([save_file '/' name],'file')
    ftpobj = GetFTPObj();
    ftpobj.cd('/dataset/multiView');
    file = ftpobj.dir(name);
    if isempty(file)
        disp('没有找到数据集');
        error('Error. Can not find %s.',name);
    else
        disp(['正在下载多视图数据集:' name]);
        mget(ftpobj,name,save_file);
        ftpobj.close();
        disp(['数据集' name '下载完成']);
    end
end
X_struct = load([save_file '/' name]);
X = X_struct.X;
Y = X_struct.Y;
end

