%% 初始化
clear
ComDef
S(1:2) = Define.Stream;
Setting = Define.Setting;
% 工作液体
S(1).Name = 'water';
S(1).T = 273.15+25;
S(1).P = 0.25e+6; % 0.239e+6;
S(1).VolFlow = 38.5*0.25/3600;
S(1).VFrac = 0;
S(1).rho = 1109;
% 引射气体
S(2).Name = 'air(O3)';
S(2).T = 273.15+170;
S(2).P = 1.03e+5;
S(2).VolFlow = 0.3106/60/1000;
S(2).VFrac = 1;
S(2).rho = 1.293;
% 设定参数
Setting.P2 = 0.684*1e5;
Setting.P3 = 0.20e+6; %0.103e+6;

%%
JetDesign2(S(1),S(2),Setting)