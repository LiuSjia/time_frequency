% 采样频率100MHz，幅度1V
% 本脚本文件包含所有【时变滤波理论章节】相关图像生成的语句，
% 某些功能由于太占空间封装到函数里面了，详情查看大注释。

%% 不同信号TVF下算法的RMSE性能对比：多类信号
% 2LFM+1SFM
clear all; clc; close all;
testN = 20; SNR = -20:5:20;% 仿真参数
N=128;  t = 1:N;
[s1, sif1] = fmlin(N,0.03,0.09);
[s2, sif2] = fmlin(N,0.31,0.5);
[s3, sif3] = fmsin(N,0.15,0.28,N);
s_org = s1+s2+s3;%tfr = tfrstft(s_org);imagesc(abs(tfr));axis xy
% figure('Name','sigmix-time');plot(t,real(s_org),'k-'); xlabel('时间/\mus'),ylabel('幅度/V');set_gca_style([12,4]);
% figure('Name','tfrwv');tfr = tfrstft(s_org);imagesc(abs(tfr));set_gca_style([4,4],'img');%imagesc(abs(tfrADTFD(s_org,2,14,82)));

rmse = TVF_component_rmse_Monte_Carlo(s_org,[s1,s2,s3],[sif1,sif2,sif3],SNR,testN,10,6,50);
rmseSum = mean(rmse,2);
figure('Name','蒙特卡洛仿真分离性能2LFM1SFM');label={'ko-','ksquare-','kdiamond-','kx-','rv-','r^-','r<-','r>-','m.-','bhexagram-','m+-','m*-','mx-'};%标注所用，支持最多13种线型
% for k=1:9; plot(SNR,20*log(rmseSum(:,1,k)),label{k});hold on; end%考虑全部分量性能并不好
for k=1:9; plot(SNR,20*log(rmse(:,3,k)),label{k});hold on;   end  %只考虑第三个非线性分量其性能才能更好
legend('STFT-F','STFT-FM','STFT-A','STFT-AM','STFRFT-F','STFRFT-FM','STFRFT-A','STFRFT-AM','SWT');
xlabel('SNR/dB');ylabel('RMSE/dB');set_gca_style([16,8]);

Results_File = ['TVF_component_rmse_Monte_Carlo_2LFM1SFM',datestr(clock,'_yyyy_mm_dd_hh_MM')];
save(Results_File,'SNR','rmse');pause(0.1)



% 3LFM相交
clear all; clc; %close all;
testN = 20; SNR = -20:5:20;% 仿真参数
N=128;  t = 1:N;
[s1, sif1] = fmlin(N,0,0.4,29);
[s2, sif2] = fmlin(N,0.4,0,90);
[s3, sif3] = fmlin(N,0.2,0.2,14);
s_org = s1+s2+s3;%tfr = tfrstft(s_org);imagesc(abs(tfr))
% figure('Name','sigmix-time');plot(t,real(s_org),'k-'); xlabel('时间/\mus'),ylabel('幅度/V');set_gca_style([12,4]);
% figure('Name','tfrwv');tfr = tfrstft(s_org);imagesc(abs(tfr));set_gca_style([4,4],'img');%imagesc(abs(tfrADTFD(s_org,2,14,82)));


rmse = TVF_component_rmse_Monte_Carlo(s_org,[s1,s2,s3],[sif1,sif2,sif3],SNR,testN,10,6,3);
rmseSum = mean(rmse,2);
figure('Name','蒙特卡洛仿真分离性能3LFM');label={'ko-','ksquare-','kdiamond-','kx-','rv-','r^-','r<-','r>-','m.-','bv-','b^-','b<-','b>-'};%标注所用，支持最多13种线型
for k=1:9; plot(SNR,20*log(rmseSum(:,1,k)),label{k});hold on;   end
for k=4:8; plot(SNR,20*log((rmse(:,1,k)+rmse(:,2,k))/2),label{k+4});hold on;   end% 只考虑倾斜分量
legend('STFT-F','STFT-FM','STFT-A','STFT-AM','STFRFT-F','STFRFT-FM','STFRFT-A','STFRFT-AM','SWT');
xlabel('SNR/dB');ylabel('RMSE/dB');set_gca_style([16,8]);

Results_File = ['TVF_component_rmse_Monte_Carlo_3LFM',datestr(clock,'_yyyy_mm_dd_hh_MM')];
save(Results_File,'SNR','rmse');pause(0.1)


% 3LFM+1SFM
clear all; clc; %close all;
testN = 20; SNR = -20:5:20;% 仿真参数
N=128;  t = 1:N;
[s1, sif1] = fmlin(N,0.05,0.11,30);
[s2, sif2] = fmlin(N,0.1,0.2,1);
[s3, sif3] = fmsin(N,0.22,0.42,128);
[s4, sif4] = fmlin(N,0.4,0.16,1);
s_org = s1+s2+s3+s4;%tfr = tfrstft(s_org);imagesc(abs(tfr))
% figure('Name','sigmix-time');plot(t,real(s_org),'k-'); xlabel('时间/\mus'),ylabel('幅度/V');set_gca_style([12,4]);
% figure('Name','tfrwv');tfr = tfrstft(s_org);imagesc(abs(tfr));set_gca_style([4,4],'img');%imagesc(abs(tfrADTFD(s_org,2,14,82)));

rmse = TVF_component_rmse_Monte_Carlo(s_org,[s1,s2,s3,s4],[sif1,sif2,sif3,sif4],SNR,testN,10,6,50);
rmseSum = mean(rmse,2);
figure('Name','蒙特卡洛仿真分离性能3LFM+1SFM');label={'ko-','ksquare-','kdiamond-','kx-','rv-','r^-','r<-','r>-','m.-','bhexagram-','m+-','m*-','mx-'};%标注所用，支持最多13种线型
for k=1:9; plot(SNR,20*log(rmseSum(:,1,k)),label{k});hold on;   end
% for k=1:9; plot(SNR,20*log(rmse(:,1,k)),label{k});hold on;   end
legend('STFT-F','STFT-FM','STFT-A','STFT-AM','STFRFT-F','STFRFT-FM','STFRFT-A','STFRFT-AM','SWT');
xlabel('SNR/dB');ylabel('RMSE/dB');set_gca_style([16,8]);

Results_File = ['TVF_component_rmse_Monte_Carlo_3LFM1SFM',datestr(clock,'_yyyy_mm_dd_hh_MM')];
save(Results_File,'SNR','rmse');pause(0.1)






