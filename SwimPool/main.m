%% 恒温泳池热平衡
%
% by Dr. Guan Guoqiang @ SCUT on 2020-12-15

%% 初始化
clear
% 泳池尺寸
SWPool.Length = 20;
SWPool.Width = 10;
SWPool.Depth = 1.4;
As = SWPool.Length*SWPool.Width; % 池水表面积（m2）
AW = As+(SWPool.Length+SWPool.Width)*2*SWPool.Depth; % 池壁面积（m2）
b = 0.01; % 池壁瓷砖厚度（m）
k = 0.69; % 池壁瓷砖导热系数（W/m-K） [张洪沅. 化工原理（上） P180表7-1]
T0 = 15+273.15; % 环境温度（K）
T1 = 30+273.15; % 进水温度（K）
T2 = 28+273.15; % 泳池设计水温、出水（K）
m1 = 10; % 换水量（kg/s）
h = 25; % 气液总传热系数（W/m2-K）
V = SWPool.Length*SWPool.Width*SWPool.Depth; % 水池容积（m3）

%% 4.2 设计负荷
% 人均池水面积为2.5m2/人
N = fix(As/2.5); % 泳池可容纳最大使用者数目

%% 4.3 循环方式
% 游泳池分类为专用类私人泳池，故采用逆流式的池水循环方式

%% 4.4 循环周期
T = 8; % 循环周期（h）

%% 4.5 循环流量
% 池水循环净化处理系统的循环水流量（m3/h）
qc = V*1.1/T;

%% 4.6 循环水泵
PumpNum = 2; % 两开一备
Pump.Q = qc*1.1/PumpNum;
Pump.H = 5; % 扬程5m

%% 4.7 循环管道
% 循环给水管流速1.5~2.5m/s
% 循环回水管流速1.0~1.5m/s
% 水泵吸水管流速0.7~1.2m/s

%% 4.8 均衡水池和平衡水池
% 均衡水池（适用于逆流式池水循环工艺）
Va = 0.06*N; % 游泳者入池厚的排水量（m3）
Vs = As*0.01; % 循环净化系统运行时所需水量（m3）
Vc = 0; % 净化系统管路充液量（m3）
Vd = 4.882; % 单个过滤器反冲需水量（m3），见后面的过滤设备计算
Vj = Va+Vd+Vc+Vs; % 均衡水池的有效容积（m3）
fprintf('均衡池体积：%.1f m3\n', Vj)
% 平衡水池（适用于顺流式池水循环工艺）
Vp = Vd+0.08*qc; % 平衡水池的有效容积（m3）

%% 4.9 给水口
Inlet.Num = round(As/8); % 给水口数目
Inlet.Velocity = 0.5; % 给水口流速

%% 4.10 回水口和泄水口
% 溢流回水槽中的回水口
qd = pi/4*0.025^2*1.0; % 单个回水口流量（m3/h）
Outlet.Num = round(1.5*qc/qd);
% 泄水口（逆流式池水循环系统应独立设置池底泄水口）
TD = 6; % 卸空时间为6小时

%% 5.4 压力颗粒过滤设备
Filter.Area = 1.13; % 过滤面积（m2）
Filter.ID = 1.2; % 沙缸内径（m）
Filter.Filler.Name = '0.4mm均值石英沙';
Filter.Filler.Weight = pi/4*Filter.ID^2*1*1500; % 填料高度为1米、堆密度为1500t/m3
Filter.Backwash.Intensity = 12; % 水反冲强度（L/s-m2）
Filter.Backwash.Duration = 6*60; % 反冲时间（s）
Vd = Filter.Backwash.Intensity*Filter.Backwash.Duration*Filter.Area/1000; % 单个过滤器反冲需水量（m3）
% 按过滤速度20m/h计算沙缸数目
FilterNum = ceil(qc/(Filter.Area*20));
if FilterNum > 2
    Filter(2:FilterNum) = Filter(1);
end

%% 5.8 有机物降解器
% 设于过滤器后加热器前，出水回流至过滤器前
% 设计旁路流量为池水容积的2%~10%
Degradation.Flowrate = 0.05*qc;
Degradation.Velocity = 8/3600; % 活性炭滤层流速（m/s）

%% 6.2 臭氧消毒
% 采用分流量全程式臭氧消毒工艺
Ozone.Flowrate = 0.25*qc; % 分流量为循环量的25%（m3/h）
Ozone.C_O3 = 0.4; % 臭氧投加浓度（mg/L，g/m3）
Ozone.q_O3 = qc*Ozone.C_O3; % 按总循环量计算臭氧需要量（g/h）
% 臭氧发生器
Ozone.Generator.C_O3 = 50; % 臭氧浓度（mg/L，g/m3）按3S-OA-20Y臭氧机性能，http://www.tonglinkeji.cn/pro/special/28.html
% Ozone.Generator.qa = Ozone.q_O3/0.5/Ozone.Generator.C_O3; % 按50%溶于水计算产气量（Nm3/h）
Ozone.Generator.qa = 0.308; % 按“臭氧发生量.bkp”结果计算臭氧发生器的产气量（m3/h，15C、1bar）
fprintf('臭氧发生器的产气量为%.1fNm3/h\n',Ozone.Generator.qa)
% 臭氧混合器（文丘里液气混合器）
% CalcJet 
% main_Jet % 按25%循环水量计算抽吸气量
% 臭氧反应罐设计
Ozone.Reactor.ResidentTime = 1.6/Ozone.C_O3; % 臭氧与水的接触反应时间（min）
if Ozone.Reactor.ResidentTime < 2
    Ozone.Reactor.ResidentTime = 2;
end
Ozone.Reactor.Volume = Ozone.Flowrate/60*Ozone.Reactor.ResidentTime; % 臭氧消毒反应器容积（m3）
Ozone.Reactor.Spec = VolDesign(Ozone.Reactor.Volume, 3, Ozone.Flowrate);


%% 6.3 氯消毒
Chloride.q_Cl = 0.3*qc; % 氯消毒剂投药量g/h

%% 7.2 耗热量
% 池水表面蒸发损失热量（kJ/h）
gamma = 2434.6; % 水温下的气化潜热（kJ/kg）
vw = 2; % 水面风速（m/s）
Pb = 0.0171e+5; Pq = 0.5*Pb; % 288.15K，相对湿度50%
Qs = 1/133.32*1*gamma*(0.0174*vw+0.0229)*(Pb-Pq)*As;
% 壁面、管道等热损失
Qs = 1.2*Qs;
% 补水加热所需热量（kJ/h）
qb = 1/133.32*1*(0.0174*vw+0.0229)*(Pb-Pq)*As; % 补水量 = 蒸发水量（kg/h）
Qb = qb*4.18*(T2-T0); 
fprintf('补水量为：%.1fkg/h；热负荷为%.1fkW\n',qb,(Qs+Qb)/3600)

%% 7.3 加热设备
% ====== 以下为为研究结果，用于校核Qs ========
% 池水与空气对流散热量（W）
Qc = h*As*(T2-T0);
% 池壁导热损失量（W）
Ql = k/b*AW*(T2-T0);
% =========================================
% 泳池回水温度（K）
T2 = (Qs+Qb)/qc/4180+T1;
if T2>40+273.15
    fprintf('【注意】回水温度过高！\n')
end
% 输出
fprintf('环境温度为%.1fC时，循环水量为%.2fm3/h，恒温热负荷为%.1fkW，泳池给水温度%.1fC\n', ...
    T0-273.15,qc,(Qs+Qb)/3600,T2-273.15)
% 采用分流量加热
qr = 0.25*qc;
dTh = (Qs+Qb)/qr/4180;
fprintf('加热设备需将%.2fm3/h水升温%.1fC\n', qr, dTh)

function Spec = VolDesign(Vol, HDR, QIn)
    % 计算罐体尺寸
    syms D H   
    VIn = 1; % 进料口流速设为1m/s
    sol = solve([Vol == pi/4*D^2*H, H/D == HDR], [D,H], 'real', true);
    DN = getDN(vpa(sol.D)*1000);
    HN = ceil((Vol-(DN/1000*pi/24+pi/4*(DN/1000)^2*0.002)*2)*1e+9/(pi/4*DN^2));
    % 计算接管公称尺寸
    d = sqrt(QIn/(pi/4)/VIn)*1000; % 进料管直径（mm）
    dn = getDN(d);
    % 输出
    Spec = sprintf('Vert. Vessel w/ std. elipse head: DN%d (body H = %dmm)', DN, HN);
end

function dn = getDN(d)
    if d < 300
        dn = round(d/50)*50;
    else
        dn = round(d/100)*100;
    end
end
