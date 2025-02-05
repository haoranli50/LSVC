function [Z,model,obj_val,ACC] = LALMVC_DEBUG(X,Y,model,max_iter)
%function [Z,model,obj_val] = LALMVC(X,model,max_iter)
%LALMVC 此处显示有关此函数的摘要
%% 参数处理
if nargin<4
    max_iter = 40;
end
obj_val = zeros(max_iter,1);
%% 数据解析
anchor_num = model.anchor_num;
cluster_num = model.cluster_num;
subdim_num = model.subdim_num;
[dim_num,sample_num] = size(X);
if anchor_num~=size(model.F,1)||cluster_num~=size(model.F,2)
    error('The dimensions of F are incompatible');
end
if sample_num~=model.sample_num
    error('The number of task samples is inconsistent');
end
%% 获取任务排序
task_num = model.task_num;
task_id = task_num + 1;
%% 初始化数据
B = model.B;
F = model.F;
XtW = model.XtW;
beta = model.beta;
alpha = model.alpha;
%view_num = model.view_num;
Z = model.Z;
W = rand(dim_num,subdim_num);
sample_I = eye(sample_num);
anchor_I = eye(anchor_num);
%% 数据表示初始化
G = L2_distance_1(X,X);
%% 停止用条件
flag = 1;
iter = 0;
ACC = [];
tolerate = model.tolerate;
options = optimset('Algorithm','interior-point-convex','Display','off');
% options = optimset('Algorithm','interior-point-convex');
while flag
    iter = iter + 1;
    Z_old = Z;
    %% Z 子问题
    ZH = B'*B-beta*F*F'+1000*anchor_I;
    Q = TaskMerge(XtW,X'*W,task_id);
    ZF = alpha*G*Z'-2*Q*B;
    parfor n = 1:sample_num
        Z(:,n) = quadprog(2*ZH,ZF(n,:),[],[],ones(1,anchor_num),1,zeros(anchor_num,1),ones(anchor_num,1),[],options);
    end
    %% W 子问题
    WP = X*Z'*B';
    W = find_projection(WP);
    %% B 子问题
    B = TaskMerge(XtW,X'*W,task_id)'/Z;
    %% 停止条件
    obj = norm(Z-Z_old,'fro');
    obj_val(iter) = obj;
    [result,~] = myNMIACC(Z',Y,cluster_num);
    ACC = [ACC result(1)];
    if (iter == max_iter)||(obj<tolerate)
        flag = false;
    end
end

%% 保存数据
model.B = B;
model.XtW = TaskMerge(XtW,X'*W,task_id);
model.task_num = task_id;
model.Z = Z;
end

function para = TaskMerge(prv_para, this_para, task_id)
if task_id == 1
    para = this_para;
else
    para = prv_para*(task_id-1)/task_id+this_para/task_id;
end
end

function [Ap] = find_projection(A)
[U , ~, V] = svd(A,0);
Ap = U*V';
assert(norm(Ap'*Ap - eye(size(Ap,2)),'fro')<0.000000001,'wrong projection');
end