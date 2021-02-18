%% 分配设计任务
% 初始化
clear
% 载入学生名单
load('data.mat','List')
% 获取学号后4为
StudentN = height(List.Students);
SN_L4D = cellfun(@(x) x(end-3:end), cellstr(List.Students.SN), 'UniformOutput', false);
Students = List.Students;
Students = [Students,table(SN_L4D)];
% 设计单元编号
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
% 设计单元池
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
    % 任务说明
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
    Descript{iStudent} = sprintf('泳池面积为：%.0fm2', ReqArea);
end
Students = [Students,table(AssignUnit, Descript)];
