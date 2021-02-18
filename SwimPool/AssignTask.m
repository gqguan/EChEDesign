%% �����������
% ��ʼ��
clear
% ����ѧ������
load('data.mat','List')
% ��ȡѧ�ź�4Ϊ
StudentN = height(List.Students);
SN_L4D = cellfun(@(x) x(end-3:end), cellstr(List.Students.SN), 'UniformOutput', false);
Students = List.Students;
Students = [Students,table(SN_L4D)];
% ��Ƶ�Ԫ���
HeadDef = ['A','B','C','D','E','F'];
SNDef = 0:9;
UnitSN = cell(60,1);
j = 0;
for iHead = 1:6
    for iSN = 1:10
        j = j+1;
        UnitSN{j} = sprintf('%s-%d',HeadDef(iHead),SNDef(iSN));
    end
end
% ��Ƶ�Ԫ��
AssignUnit = cell(StudentN,1);
Descript = cell(StudentN,1);
UnitSN_Pool = UnitSN(2:StudentN+1);
for iStudent = 1:StudentN
    PoolSize = length(UnitSN_Pool);
    idx = randi(PoolSize);
    if idx == 0
        idx = 1;
    end
    if isempty(UnitSN_Pool{idx})
        pause
    end
    AssignUnit(iStudent) = UnitSN_Pool(idx);
    UnitSN_Pool(idx) = [];
    % ����˵��
    switch AssignUnit{iStudent}(1)
        case('A')
            ReqArea = 200+round(str2double(SN_L4D{iStudent})/100);
        case('B')
            ReqArea = 200+round(str2double(SN_L4D{iStudent})/100);
        case('C')
            ReqArea = 150+round(str2double(SN_L4D{iStudent})/100);
        case('D')
            ReqArea = 120+round(str2double(SN_L4D{iStudent})/100);
        case('E')
            ReqArea = 120+round(str2double(SN_L4D{iStudent})/100);
        case('F')
            ReqArea = 120+round(str2double(SN_L4D{iStudent})/100);
    end
    Descript{iStudent} = sprintf('Ӿ�����Ϊ��%.0fm2', ReqArea);
end
Students = [Students,table(AssignUnit, Descript)];
