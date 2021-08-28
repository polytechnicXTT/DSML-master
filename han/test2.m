% ʹ����������������ں�
clc
clear
close all

% model_dir = 'D:\train\xlsx\OVARY\model10\';
model = "model8";
model_dir = 'D:\PyCharm\Pycharm_Projects\DSML\model\COAD\'+model+"\";
epoch = 20;
C = 3;
save_num = 21  ;
K =              30  ;        %number of neighbors, usually (10~30)
alpha = 0.3;  %hyperparameter, usually (0.3~0.8)

%s_c = [];

surv=importdata('D:\PyCharm\Pycharm_Projects\DSML\data\COAD\COLON_Survival.xlsx');
STR_surv = surv.textdata(2:size(surv.textdata,1),1);
case_surv=arrayfun(@(k) STR_surv{k}(1:12),1:length(STR_surv),'UniformOutput',0)';
surv.data = surv.data();
data_surv=surv.data;

for i = 0:epoch-1
    Data = xlsread(model_dir + "W"+ i + "_3.xlsx", "B2:XA625");
    Data = Standard_Normalization(Data);
    Dist = dist2(Data,Data);
    W = affinityMatrix(Dist, K, alpha);

    group = SpectralClustering(W,C);
%     silhouette1=New_silhouette(W,group);
%     s_value = "epoch "+ i + " : "+silhouette1;
%     s_c(i+1) = silhouette1;
%     disp(s_value);
    outpart1="D:/PyCharm/Pycharm_Projects/DSML/cluster_result/COAD/"+model+"/"+model+"_param_comb/"+save_num+"/txt/colon_test"+i;
    outpart2=".txt";
    r_name=sprintf('%s%s',outpart1,outpart2);
    fid=fopen(r_name,'w');
    fprintf(fid,'patient_id     survival     death       Labels');
    fprintf(fid,'\n');
    
    %size = size(case_surv, 1)-1;
    for i=1:1:size(case_surv, 1)
        fprintf(fid,'%s	%d	%d	%d',case_surv{i,1},data_surv(i,1),data_surv(i,2),group(i));
        fprintf(fid,'\n');
    end
    
%     for i=1:1:size(case_surv,1)
%       fprintf(fid,'%s	%d	%d	%d',case_surv{i,1},data_surv(i,1),data_surv(i,2),group(i));
%       fprintf(fid,'\n');
%     end
    fclose(fid);
    disp(outpart1+outpart2+" saved")
end
%max_silhouette = max(s_c);
% disp(max_silhouette)
disp("done!");

