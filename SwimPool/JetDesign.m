function [S3,S1,GeomSpec] = JetDesign(S1,S2,Setting)
%JetDesign() 文丘里液气混合器设计
%   输入参数：S1 - 工作液体（温度、压力、气含量=0）；
%            S2 - 引射气体状态（流量、温度、压力和气含量=1）;
%            Settings - 设定条件（喉部压力P2、背压P3）
%   输出参数：S3 - 混合流体（流量、温度、压力和气含量）；
%            GeomSpec - 混合器几何尺寸（工作液体进口尺寸d1、收缩段长度Lc、喉部尺寸d2、扩张段长度LD、出口管尺寸d3）
%
% ref. 魏同成. 喷射管与文丘里管的设计[J], 化工设计, 1993, (6): 21-27.

S3 = S1;

S3.P = Setting.P3;

% 1. 最大体积抽射系数
dPP = S1.P-Setting.P2; 
dPC = S2.P-Setting.P2;
u0 = 0.85*sqrt(dPP/dPC)-1;
GeomSpec.u0 = u0;
fprintf('体积抽射系数为：%.2f\n',u0)
f21 = dPP/dPC;

% 2. 湿空气体积流量及工作液体积流量
Psat = XSteam('Psat_T',(S2.T-273.15))*1e+3;
VB = S2.rho*S2.VolFlow*286.7*S1.T/(S2.P-Psat);
VP = VB/u0;
S1.VolFlow = VP;
S3.Name = 'water w/ a&o';
S3.VFrac = 1/(1+S2.rho*S2.VolFlow/(S1.rho*S1.VolFlow));
fprintf('喷射水量：%.3e m3/h\n',VP*3600)

% 3. 喷嘴尺寸
% 按伯努利方程计算
dH = (Setting.P2-Setting.P3)/1.03e+5*10; % 压力单位为水柱（m）
V2 = 0.95*sqrt(2*9.81*dH); % 射流液在喷嘴处速度（m/s）
% 按式(22)计算
f1 = VP/(0.95*sqrt(2*9.81*dPP/1e+5*10)); % 喷嘴截面积（m2）
d1 = sqrt(f1/pi*4);
GeomSpec.d1 = d1;
fprintf('喷嘴出口直径：%.1f mm\n',d1*1000)

% 4. 收缩管直径和长度
d2 = d1*sqrt(f21); 
Lc = 10*d2;
GeomSpec.d2 = d2;
GeomSpec.Lc = Lc;
fprintf('收缩管直径和长度分别为：%.0f mm 和 %.0f mm\n',d2*1000, Lc*1000)

% 5. 进气管尺寸
fk = 20*f1;
dk = sqrt(fk/pi*4);
GeomSpec.dk = dk;
fprintf('进气管直径为：%.0f mm\n',dk*1000)

% 6. 吸气室尺寸
ra = d1+0.002; % 喷嘴平均外径 
r = 4*ra; % 吸气室初值（m）
tryAgain = true;
while tryAgain
    alpha = 2*acos(ra/r); % 弧度（rad）
    fB = (alpha-sin(alpha))/2*r*r;
    if fB > fk
        r = 0.9*r;
    else
        tryAgain = false;
    end
end
GeomSpec.r = r;
fprintf('吸气室直径为：%.0f mm\n',2*r*1000)

% 7. 扩散管长度
d3 = d2;
syms d4 LD
sol = solve([d4/2/LD == 0.07, LD == 10*(d4-d3)], [d4,LD]);
d4 = eval(sol.d4); LD = eval(sol.LD);
GeomSpec.d4 = d4;
GeomSpec.LD = LD;
fprintf('扩散管出口直径为：%.0f mm，长度为%.0f mm\n', d4*1000, LD*1000)

% 8. 喷嘴与喉管间距
dh = (d2-d1)/2;
GeomSpec.dh = dh;
fprintf('喷嘴与喉管间距为：%.0f mm\n',dh*1000)

end

