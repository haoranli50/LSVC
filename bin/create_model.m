function [model] = create_model(F,alpha,beta,anchor_num,cluster_num,subdim_num,sample_num)
%CREATE_MODEL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
model = struct;
%% ��ʼ������ָʾ
model.F = F;
%% ��ʼ��������
model.alpha = alpha;model.beta = beta;
%% ��ʼ��ά������
model.anchor_num = anchor_num;model.cluster_num = cluster_num;model.subdim_num = subdim_num;model.sample_num = sample_num;
%% ��ʼ�����溯��
model.XtW = zeros(sample_num,subdim_num);
model.B = rand(subdim_num,anchor_num);
model.Z = zeros(anchor_num,sample_num);
%% ��ʼ������
model.task_num = 0;
%% ��ʼ������
model.tolerate = 1e-4;
end

