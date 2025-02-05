function [model] = create_model(F,alpha,beta,anchor_num,cluster_num,subdim_num,sample_num)
%CREATE_MODEL 此处显示有关此函数的摘要
%   此处显示详细说明
model = struct;
%% 初始化先验指示
model.F = F;
%% 初始化超参数
model.alpha = alpha;model.beta = beta;
%% 初始化维度数据
model.anchor_num = anchor_num;model.cluster_num = cluster_num;model.subdim_num = subdim_num;model.sample_num = sample_num;
%% 初始化保存函数
model.XtW = zeros(sample_num,subdim_num);
model.B = rand(subdim_num,anchor_num);
model.Z = zeros(anchor_num,sample_num);
%% 初始化次数
model.task_num = 0;
%% 初始化容忍
model.tolerate = 1e-4;
end

