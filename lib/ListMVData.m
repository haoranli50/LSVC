function file = ListMVData()
ftpobj = GetFTPObj();
file = ftpobj.dir('/dataset/multiView');
struct2table(file)
ftpobj.close();
end

