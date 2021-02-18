%% 初始化
ComDef
S(1:2) = Define.Stream;
Setting = Define.Setting;
% 工作液体
S(1).Name = 'water';
S(1).T = T2;
S(1).P = 0.355e+6;
S(1).VFrac = 0;
S(1).rho = 1000;
% 引射气体
S(2).Name = 'Air w/ Ozone';
S(2).T = T0;
S(2).P = 0.1e+6;
S(2).VolFlow = Ozone.Generator.qa/3600;
S(2).VFrac = 1;
S(2).rho = 1.293;
% 设定参数
Setting.P2 = 0.02e+6; % 绝压（Pa）
Setting.P3 = 0.103e+6; % 绝压（Pa）

%%
[S(3),S(1),GeomSpec] = JetDesign(S(1),S(2),Setting);