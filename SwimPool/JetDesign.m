function [S3,S1,GeomSpec] = JetDesign(S1,S2,Setting)
%JetDesign() ������Һ����������
%   ���������S1 - ����Һ�壨�¶ȡ�ѹ����������=0����
%            S2 - ��������״̬���������¶ȡ�ѹ����������=1��;
%            Settings - �趨��������ѹ��P2����ѹP3��
%   ���������S3 - ������壨�������¶ȡ�ѹ��������������
%            GeomSpec - ��������γߴ磨����Һ����ڳߴ�d1�������γ���Lc�����ߴ�d2�����Ŷγ���LD�����ڹܳߴ�d3��
%
% ref. κͬ��. �������������ܵ����[J], �������, 1993, (6): 21-27.

S3 = S1;

S3.P = Setting.P3;

% 1. ����������ϵ��
dPP = S1.P-Setting.P2; 
dPC = S2.P-Setting.P2;
u0 = 0.85*sqrt(dPP/dPC)-1;
GeomSpec.u0 = u0;
fprintf('�������ϵ��Ϊ��%.2f\n',u0)
f21 = dPP/dPC;

% 2. ʪ�����������������Һ�������
Psat = XSteam('Psat_T',(S2.T-273.15))*1e+3;
VB = S2.rho*S2.VolFlow*286.7*S1.T/(S2.P-Psat);
VP = VB/u0;
S1.VolFlow = VP;
S3.Name = 'water w/ a&o';
S3.VFrac = 1/(1+S2.rho*S2.VolFlow/(S1.rho*S1.VolFlow));
fprintf('����ˮ����%.3e m3/h\n',VP*3600)

% 3. ����ߴ�
% ����Ŭ�����̼���
dH = (Setting.P2-Setting.P3)/1.03e+5*10; % ѹ����λΪˮ����m��
V2 = 0.95*sqrt(2*9.81*dH); % ����Һ�����촦�ٶȣ�m/s��
% ��ʽ(22)����
f1 = VP/(0.95*sqrt(2*9.81*dPP/1e+5*10)); % ����������m2��
d1 = sqrt(f1/pi*4);
GeomSpec.d1 = d1;
fprintf('�������ֱ����%.1f mm\n',d1*1000)

% 4. ������ֱ���ͳ���
d2 = d1*sqrt(f21); 
Lc = 10*d2;
GeomSpec.d2 = d2;
GeomSpec.Lc = Lc;
fprintf('������ֱ���ͳ��ȷֱ�Ϊ��%.0f mm �� %.0f mm\n',d2*1000, Lc*1000)

% 5. �����ܳߴ�
fk = 20*f1;
dk = sqrt(fk/pi*4);
GeomSpec.dk = dk;
fprintf('������ֱ��Ϊ��%.0f mm\n',dk*1000)

% 6. �����ҳߴ�
ra = d1+0.002; % ����ƽ���⾶ 
r = 4*ra; % �����ҳ�ֵ��m��
tryAgain = true;
while tryAgain
    alpha = 2*acos(ra/r); % ���ȣ�rad��
    fB = (alpha-sin(alpha))/2*r*r;
    if fB > fk
        r = 0.9*r;
    else
        tryAgain = false;
    end
end
GeomSpec.r = r;
fprintf('������ֱ��Ϊ��%.0f mm\n',2*r*1000)

% 7. ��ɢ�ܳ���
d3 = d2;
syms d4 LD
sol = solve([d4/2/LD == 0.07, LD == 10*(d4-d3)], [d4,LD]);
d4 = eval(sol.d4); LD = eval(sol.LD);
GeomSpec.d4 = d4;
GeomSpec.LD = LD;
fprintf('��ɢ�ܳ���ֱ��Ϊ��%.0f mm������Ϊ%.0f mm\n', d4*1000, LD*1000)

% 8. �������ܼ��
dh = (d2-d1)/2;
GeomSpec.dh = dh;
fprintf('�������ܼ��Ϊ��%.0f mm\n',dh*1000)

end

