function [S3,S1,GeomSpec] = JetDesign2(S1,S2,Setting)
%JetDesign2() ������Һ����������
%   ���������S1 - ����Һ�壨�¶ȡ�ѹ����������=0����
%            S2 - ��������״̬���������¶ȡ�ѹ����������=1��;
%            Settings - �趨��������ѹ��P2����ѹP3��
%   ���������S3 - ������壨�������¶ȡ�ѹ��������������
%            GeomSpec - ��������γߴ磨����Һ����ڳߴ�d1�������γ���Lc�����ߴ�d2�����Ŷγ���LD�����ڹܳߴ�d3��
%
% ref. to �Ϻ�ҽҩ���Ժ�������. ˮ�������Ƽ�Ӧ��[M], �������������豸�������վ, 1983.

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
fprintf('�������ϵ���������ȣ�Ϊ��%.2f\n',K)

Psat = XSteam('Psat_T',(S2.T-273.15))*1e+3;
wgs = 0.91*sqrt(2*9.81*dPP); % �ٶ�ϵ��Ϊ0.91

Vgs = S1.VolFlow;
VK = Vgs*K; % ��������m3/s��
S2.VolFlow = VK;
fprintf('��������%.3e m3/h\n', S2.VolFlow*3600)
% VK = S2.VolFlow;
% Vgs = VK/K; % ����ˮ��������ʣ�m3/s��
% S1.VolFlow = Vgs;
% fprintf('����ˮ����%.3e m3/h\n',S1.VolFlow*3600)

d0 = sqrt(Vgs/(pi/4*wgs));
fprintf('���ֱ��d0��%.0fmm\n', d0*1000)

D2 = m*d0*sqrt(dPP/dPC);
fprintf('��Ϻ��ֱ��D2��%.0fmm\n', D2*1000)
L2 = 3*D2;
fprintf('��Ϻ�ܳ���L2��%.0fmm\n', L2*1000)

D = sqrt(Vgs/(pi/4*3)); % ������Ϊ3m/s
fprintf('����ˮ������ǰ�Ľӹ�ֱ��D��%.0fmm\n', D*1000)

alpha = 20; % �������ȫ��
l1 = (D-d0)/(2*tan(alpha/180*pi)); % ��������γ���
fprintf('��������γ���l1��%.0fmm\n', l1*1000)

D4 = sqrt(VK/(pi/4*1.5)); % �ٶ�����Ϊ1.5m/s
fprintf('����������ֱ��D4��%.0fmm\n', D4*1000)

D1 = 1.78*D2;
fprintf('��Ϲ�������ֱ��D1��%.0fmm\n', D1*1000)
L1 = 5.15*(D1-D2);
fprintf('��Ϲ������γ���L1��%.0fmm\n', L1*1000)

f = 1.38*pi/4*D1^2;
D0 = sqrt(2)*D1; % ��ʽ����
fprintf('������ֱ��D0��%.0fmm\n', D0*1000)

fprintf('��Ϲܽ���������ȫ��Ϊ��15��\n')

D3 = 1.78*D2;
fprintf('��ѹ��ֱ��D3��%.0fmm\n', D3*1000)
L3 = 15.5*((D3-D2)/2+D2);
fprintf('��ѹ�ܳ���L3��%.0fmm\n', L3*1000)

fprintf('��ѹ�������ȫ��Ϊ��8��\n')

l = 1.2*d0;
fprintf('��׳������Ϲܽ��ڴ��ľ���l��%.0fmm\n', l*1000)

end

