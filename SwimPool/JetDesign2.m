function [S3,S1,GeomSpec] = JetDesign2(S1,S2,Setting)
%JetDesign2() 文丘里液气混合器设计
%   输入参数：S1 - 工作液体（温度、压力、气含量=0）；
%            S2 - 引射气体状态（流量、温度、压力和气含量=1）;
%            Settings - 设定条件（喉部压力P2、背压P3）
%   输出参数：S3 - 混合流体（流量、温度、压力和气含量）；
%            GeomSpec - 混合器几何尺寸（工作液体进口尺寸d1、收缩段长度Lc、喉部尺寸d2、扩张段长度LD、出口管尺寸d3）
%
% ref. to 上海医药设计院，吴无恙. 水喷射泵设计及应用[M], 北京：化工部设备设计中心站, 1983.

S3 = S1;

S3.P = Setting.P3;

dPP = (S1.P-Setting.P2)/1e+5; 
dPC = (S2.P-Setting.P2)/1e+5;
if dPP/dPC < 2.5
    C = 0.85;
    m = 1;
else 
    C = 1.5;
    m = 0.7;
end
K = C*sqrt(dPP/dPC)-1;
GeomSpec.K = K;
fprintf('体积喷射系数（流量比）为：%.2f\n',K)

Psat = XSteam('Psat_T',(S2.T-273.15))*1e+3;
wgs = 0.91*sqrt(2*9.81*dPP); % 速度系数为0.91

Vgs = S1.VolFlow;
VK = Vgs*K; % 抽气量（m3/s）
S2.VolFlow = VK;
fprintf('抽气量：%.3e m3/h\n', S2.VolFlow*3600)
% VK = S2.VolFlow;
% Vgs = VK/K; % 工作水的体积流率（m3/s）
% S1.VolFlow = Vgs;
% fprintf('喷射水量：%.3e m3/h\n',S1.VolFlow*3600)

d0 = sqrt(Vgs/(pi/4*wgs));
fprintf('喷咀直径d0：%.0fmm\n', d0*1000)

D2 = m*d0*sqrt(dPP/dPC);
fprintf('混合喉管直径D2：%.0fmm\n', D2*1000)
L2 = 3*D2;
fprintf('混合喉管长度L2：%.0fmm\n', L2*1000)

D = sqrt(Vgs/(pi/4*3)); % 流速设为3m/s
fprintf('工作水在喷嘴前的接管直径D：%.0fmm\n', D*1000)

alpha = 20; % 喷咀收缩全角
l1 = (D-d0)/(2*tan(alpha/180*pi)); % 喷咀收缩段长度
fprintf('喷咀收缩段长度l1：%.0fmm\n', l1*1000)

D4 = sqrt(VK/(pi/4*1.5)); % 假定流速为1.5m/s
fprintf('吸入气进口直径D4：%.0fmm\n', D4*1000)

D1 = 1.78*D2;
fprintf('混合管收缩段直径D1：%.0fmm\n', D1*1000)
L1 = 5.15*(D1-D2);
fprintf('混合管收缩段长度L1：%.0fmm\n', L1*1000)

f = 1.38*pi/4*D1^2;
D0 = sqrt(2)*D1; % 该式需查核
fprintf('吸气室直径D0：%.0fmm\n', D0*1000)

fprintf('混合管进口收缩段全角为：15度\n')

D3 = 1.78*D2;
fprintf('扩压管直径D3：%.0fmm\n', D3*1000)
L3 = 15.5*((D3-D2)/2+D2);
fprintf('扩压管长度L3：%.0fmm\n', L3*1000)

fprintf('扩压管扩大段全角为：8度\n')

l = 1.2*d0;
fprintf('喷咀出口离混合管进口处的距离l：%.0fmm\n', l*1000)

end

