%% ����Ӿ����ƽ��
%
% by Dr. Guan Guoqiang @ SCUT on 2020-12-15

%% ��ʼ��
clear
% Ӿ�سߴ�
SWPool.Length = 20;
SWPool.Width = 10;
SWPool.Depth = 1.4;
As = SWPool.Length*SWPool.Width; % ��ˮ�������m2��
AW = As+(SWPool.Length+SWPool.Width)*2*SWPool.Depth; % �ر������m2��
b = 0.01; % �رڴ�ש��ȣ�m��
k = 0.69; % �رڴ�ש����ϵ����W/m-K�� [�ź���. ����ԭ���ϣ� P180��7-1]
T0 = 15+273.15; % �����¶ȣ�K��
T1 = 30+273.15; % ��ˮ�¶ȣ�K��
T2 = 28+273.15; % Ӿ�����ˮ�¡���ˮ��K��
m1 = 10; % ��ˮ����kg/s��
h = 25; % ��Һ�ܴ���ϵ����W/m2-K��
V = SWPool.Length*SWPool.Width*SWPool.Depth; % ˮ���ݻ���m3��

%% 4.2 ��Ƹ���
% �˾���ˮ���Ϊ2.5m2/��
N = fix(As/2.5); % Ӿ�ؿ��������ʹ������Ŀ

%% 4.3 ѭ����ʽ
% ��Ӿ�ط���Ϊר����˽��Ӿ�أ��ʲ�������ʽ�ĳ�ˮѭ����ʽ

%% 4.4 ѭ������
T = 8; % ѭ�����ڣ�h��

%% 4.5 ѭ������
% ��ˮѭ����������ϵͳ��ѭ��ˮ������m3/h��
qc = V*1.1/T;

%% 4.6 ѭ��ˮ��
PumpNum = 2; % ����һ��
Pump.Q = qc*1.1/PumpNum;
Pump.H = 5; % ���5m

%% 4.7 ѭ���ܵ�
% ѭ����ˮ������1.5~2.5m/s
% ѭ����ˮ������1.0~1.5m/s
% ˮ����ˮ������0.7~1.2m/s

%% 4.8 ����ˮ�غ�ƽ��ˮ��
% ����ˮ�أ�����������ʽ��ˮѭ�����գ�
Va = 0.06*N; % ��Ӿ����غ����ˮ����m3��
Vs = As*0.01; % ѭ������ϵͳ����ʱ����ˮ����m3��
Vc = 0; % ����ϵͳ��·��Һ����m3��
Vd = 4.882; % ����������������ˮ����m3����������Ĺ����豸����
Vj = Va+Vd+Vc+Vs; % ����ˮ�ص���Ч�ݻ���m3��
fprintf('����������%.1f m3\n', Vj)
% ƽ��ˮ�أ�������˳��ʽ��ˮѭ�����գ�
Vp = Vd+0.08*qc; % ƽ��ˮ�ص���Ч�ݻ���m3��

%% 4.9 ��ˮ��
Inlet.Num = round(As/8); % ��ˮ����Ŀ
Inlet.Velocity = 0.5; % ��ˮ������

%% 4.10 ��ˮ�ں�йˮ��
% ������ˮ���еĻ�ˮ��
qd = pi/4*0.025^2*1.0; % ������ˮ��������m3/h��
Outlet.Num = round(1.5*qc/qd);
% йˮ�ڣ�����ʽ��ˮѭ��ϵͳӦ�������óص�йˮ�ڣ�
TD = 6; % ж��ʱ��Ϊ6Сʱ

%% 5.4 ѹ�����������豸
Filter.Area = 1.13; % ���������m2��
Filter.ID = 1.2; % ɳ���ھ���m��
Filter.Filler.Name = '0.4mm��ֵʯӢɳ';
Filter.Filler.Weight = pi/4*Filter.ID^2*1*1500; % ���ϸ߶�Ϊ1�ס����ܶ�Ϊ1500t/m3
Filter.Backwash.Intensity = 12; % ˮ����ǿ�ȣ�L/s-m2��
Filter.Backwash.Duration = 6*60; % ����ʱ�䣨s��
Vd = Filter.Backwash.Intensity*Filter.Backwash.Duration*Filter.Area/1000; % ����������������ˮ����m3��
% �������ٶ�20m/h����ɳ����Ŀ
FilterNum = ceil(qc/(Filter.Area*20));
if FilterNum > 2
    Filter(2:FilterNum) = Filter(1);
end

%% 5.8 �л��ｵ����
% ���ڹ������������ǰ����ˮ������������ǰ
% �����·����Ϊ��ˮ�ݻ���2%~10%
Degradation.Flowrate = 0.05*qc;
Degradation.Velocity = 8/3600; % ����̿�˲����٣�m/s��

%% 6.2 ��������
% ���÷�����ȫ��ʽ������������
Ozone.Flowrate = 0.25*qc; % ������Ϊѭ������25%��m3/h��
Ozone.C_O3 = 0.4; % ����Ͷ��Ũ�ȣ�mg/L��g/m3��
Ozone.q_O3 = qc*Ozone.C_O3; % ����ѭ�������������Ҫ����g/h��
% ����������
Ozone.Generator.C_O3 = 50; % ����Ũ�ȣ�mg/L��g/m3����3S-OA-20Y���������ܣ�http://www.tonglinkeji.cn/pro/special/28.html
% Ozone.Generator.qa = Ozone.q_O3/0.5/Ozone.Generator.C_O3; % ��50%����ˮ�����������Nm3/h��
Ozone.Generator.qa = 0.308; % ��������������.bkp�������������������Ĳ�������m3/h��15C��1bar��
fprintf('�����������Ĳ�����Ϊ%.1fNm3/h\n',Ozone.Generator.qa)
% �����������������Һ���������
% CalcJet 
% main_Jet % ��25%ѭ��ˮ�������������
% ������Ӧ�����
Ozone.Reactor.ResidentTime = 1.6/Ozone.C_O3; % ������ˮ�ĽӴ���Ӧʱ�䣨min��
if Ozone.Reactor.ResidentTime < 2
    Ozone.Reactor.ResidentTime = 2;
end
Ozone.Reactor.Volume = Ozone.Flowrate/60*Ozone.Reactor.ResidentTime; % ����������Ӧ���ݻ���m3��
Ozone.Reactor.Spec = VolDesign(Ozone.Reactor.Volume, 3, Ozone.Flowrate);


%% 6.3 ������
Chloride.q_Cl = 0.3*qc; % ��������Ͷҩ��g/h

%% 7.2 ������
% ��ˮ����������ʧ������kJ/h��
gamma = 2434.6; % ˮ���µ�����Ǳ�ȣ�kJ/kg��
vw = 2; % ˮ����٣�m/s��
Pb = 0.0171e+5; Pq = 0.5*Pb; % 288.15K�����ʪ��50%
Qs = 1/133.32*1*gamma*(0.0174*vw+0.0229)*(Pb-Pq)*As;
% ���桢�ܵ�������ʧ
Qs = 1.2*Qs;
% ��ˮ��������������kJ/h��
qb = 1/133.32*1*(0.0174*vw+0.0229)*(Pb-Pq)*As; % ��ˮ�� = ����ˮ����kg/h��
Qb = qb*4.18*(T2-T0); 
fprintf('��ˮ��Ϊ��%.1fkg/h���ȸ���Ϊ%.1fkW\n',qb,(Qs+Qb)/3600)

%% 7.3 �����豸
% ====== ����ΪΪ�о����������У��Qs ========
% ��ˮ���������ɢ������W��
Qc = h*As*(T2-T0);
% �رڵ�����ʧ����W��
Ql = k/b*AW*(T2-T0);
% =========================================
% Ӿ�ػ�ˮ�¶ȣ�K��
T2 = (Qs+Qb)/qc/4180+T1;
if T2>40+273.15
    fprintf('��ע�⡿��ˮ�¶ȹ��ߣ�\n')
end
% ���
fprintf('�����¶�Ϊ%.1fCʱ��ѭ��ˮ��Ϊ%.2fm3/h�������ȸ���Ϊ%.1fkW��Ӿ�ظ�ˮ�¶�%.1fC\n', ...
    T0-273.15,qc,(Qs+Qb)/3600,T2-273.15)
% ���÷���������
qr = 0.25*qc;
dTh = (Qs+Qb)/qr/4180;
fprintf('�����豸�轫%.2fm3/hˮ����%.1fC\n', qr, dTh)

function Spec = VolDesign(Vol, HDR, QIn)
    % �������ߴ�
    syms D H   
    VIn = 1; % ���Ͽ�������Ϊ1m/s
    sol = solve([Vol == pi/4*D^2*H, H/D == HDR], [D,H], 'real', true);
    DN = getDN(vpa(sol.D)*1000);
    HN = ceil((Vol-(DN/1000*pi/24+pi/4*(DN/1000)^2*0.002)*2)*1e+9/(pi/4*DN^2));
    % ����ӹܹ��Ƴߴ�
    d = sqrt(QIn/(pi/4)/VIn)*1000; % ���Ϲ�ֱ����mm��
    dn = getDN(d);
    % ���
    Spec = sprintf('Vert. Vessel w/ std. elipse head: DN%d (body H = %dmm)', DN, HN);
end

function dn = getDN(d)
    if d < 300
        dn = round(d/50)*50;
    else
        dn = round(d/100)*100;
    end
end
