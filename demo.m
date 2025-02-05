warning off
dbstop if error
clear;
addpath(genpath('.'));
fprintf('\n');

%%参数设置
alpha =1e-5;beta=1e-3;subdim=80;anchor=6;
% alpha =1;beta=1e-4;subdim=80;anchor=3;
dataName = 'MSRCv1.mat';
fprintf('Start running %s...\n',dataName);
X_struct = load(dataName);
X = X_struct.X;
Y = X_struct.Y;

%% 从数据集中获得簇数和样本数
view_num = size(X,2);
cluster_num = length(unique(Y));
sample_num = length(Y);
%% 自动匹配数据（行、列向量）
if(size(Y,2)~=1)
    Y = Y';
end
if ~isempty(find(Y==0,1))
    Y = Y + 1;
end
for v = 1:view_num
    if size(X{v},2)~=sample_num
        X{v} = X{v}';
    end
    X{v} = NormalizeFea(X{v},0);
end

%% 构建F矩阵
anchor_num = cluster_num*anchor;
F = zeros(anchor_num,cluster_num);
for c = 1:cluster_num
    F((anchor*(c-1)+1):anchor*c,c) = 1;
end
F = F./anchor;
%% 终身学习
model = create_model(F,alpha,beta,cluster_num*anchor,cluster_num,subdim,sample_num);
fprintf('@ [dataset:%s alpha:%5.4f beta:%5.4f sub_dim:%5.4f anchor:%d] @ \n', dataName,alpha,beta,subdim,cluster_num*anchor);
for v = 1:view_num
    %[Z,model,obj_val] = LALMVC(X{v},model);
    if size(X{v},1)<subdim
        continue
    end
    [Z,model] = LALMVC(X{v},model);
    [result,~] = myNMIACC(Z',Y,cluster_num);
    ACC = result(1)*100;
    NMI = result(2)*100;
    Purity = result(3)*100;
    fprintf('@ ACC:%5.2f / NMI:%5.2f / Purity:%5.2f/ \n', ACC,NMI,Purity);
end
