%% 将手工导出的各管道数据合并生成综合材料表
%
% by Dr. Guan Guoqiang @ SCUT on 2021-11-12

%%
clear
dat = struct;

%% 将多个文件中数据分类后按规格汇总
% 选择多个csv文件
[fileNames,filePath] = uigetfile('*.csv','选择全部需要导入的csv数据文件','MultiSelect','on');
switch class(fileNames)
    case('cell')
        disp('选取了多个数据文件')
        fullPath = strcat(filePath,fileNames{1});
        raw = readcell(fullPath); % 导入数据文件
        for iFile = 1:length(fileNames)
            fullPath = strcat(filePath,fileNames{iFile});
            raw = readcell(fullPath);
            switch size(raw,2)
                case(28)
                    dat.headRows = raw(1:2,:);
                    % << 准备添加数据结构检查功能
                    raw(1:2,:) = [];
                    if ~exist('r0','var')
                        r0 = raw;
                    else
                        r0 = [r0;raw];
                    end
                case(6)
                    dat.headRows = raw(1,:);
                    raw(1,:) = [];
                    if ~exist('a0','var')
                        a0 = raw;
                    else
                        a0 = [a0;raw];
                    end
                otherwise
                    error('【错误】导入数据的结构有误！')
            end
        end
        % 获取管段号 << 准备输出管段表
        idx = ~ismissing(string(r0(:,1)));
        if any(idx)
            tag = r0(idx,1);
        end
        % 综合材料分类参照HG/T 20519-2006
        % 管子
        r1 = r0(:,4:9);
        r1(ismissing(string(r1(:,4))),:) = []; % 删除管道数据中的空缺行
        t1 = cell2table(r1,'VariableNames',{'Spec','PN','DN','Name','Material','Length'});
        dat = classifySum(t1,'Name','Length','pipe',dat);
        % 法兰
        r2 = r0(:,10:15);
        r2(ismissing(string(r2(:,5))),:) = [];
        Spec = strcat(r2(:,6),' 法兰 PL',string(r2(:,2)),'(B)-',string(r2(:,1)),r2(:,3)," ",r2(:,4));
        t2 = cell2table(r2,'VariableNames',{'PN','DN','Sealing','Material','Amount','Standard'});
        t2 = [t2,table(Spec)];
        dat = classifySum(t2,'Spec','Amount','flange',dat);
        % 垫片
        r3 = r0(:,[10,11,16:19]);
        r3(ismissing(string(r3(:,6))),:) = [];
        Spec = strcat("HG20606 垫片 ",r3(:,5)," ",string(r3(:,2)),"-",bar2MPa(r3(:,1))," ",r3(:,3));
        t3 = cell2table(r3,'VariableNames',{'PN','DN','Material','Thickness','Sealing','Amount'});
        t3 = [t3,table(Spec)];
        dat = classifySum(t3,'Spec','Amount','gasket',dat);
        % 紧固件
        r4 = r0(:,20:25);
        r4(ismissing(string(r4(:,5))),:) = [];
        Class = strcat(r4(:,1),"/",r4(:,2));
        Spec = strcat("HG206013 六角螺栓/螺母 M16x",string(r4(:,6))," ",Class);
        t4 = cell2table(r4,'VariableNames',{'BoltPerformance','NutPerformance','FlangePN','FlangeDN','Amount','Length'});
        t4 = [t4,table(Spec),table(Class)];
        dat = classifySum(t4,'Spec','Amount','boltNut',dat);
        % 清理空的数据
        a0(ismissing(string(a0(:,5))),:) = [];
        a0(strcmp(a0(:,2),'编号'),:) = [];
        % 填材料类型
        for iRow = 1:size(a0,1)
            if a0{iRow,2} == 1
                type = a0{iRow,1};
            else
                a0{iRow,1} = type;
            end
        end
        % 将缺失的数据用字符“无”表示
        for i = 1:size(a0,1)
            for j = 1:size(a0,2)
                if ismissing(a0{i,j})
                    a0{i,j} = '无';
                end
            end
        end
        % 阀门
        a1 = a0(strcmp(a0(:,1),'阀门'),:);
        Spec = strcat(a1(:,3)," ",a1(:,6));
        t5 = cell2table(a1,'VariableNames',{'Type','No','Name','Material','Amount','Standard'});
        t5 = [t5,table(Spec)];
        dat = classifySum(t5,'Spec','Amount','valve',dat);
        % 管件
        a2 = a0(strcmp(a0(:,1),'管件'),:);
        Spec = strcat(a2(:,3)," ",a2(:,6));
        t6 = cell2table(a2,'VariableNames',{'Type','No','Name','Material','Amount','Standard'});
        t6 = [t6,table(Spec)];
        dat = classifySum(t6,'Spec','Amount','fitting',dat);
        % 特殊件
        a3 = a0(strcmp(a0(:,1),'特殊件'),:);
        Spec = strcat(a3(:,3)," ",a3(:,6));
        t7 = cell2table(a3,'VariableNames',{'Type','No','Name','Material','Amount','Standard'});
        t7 = [t7,table(Spec)];
        dat = classifySum(t7,'Spec','Amount','special',dat);       
    case('char')
        disp('选取了单个数据文件')
    otherwise
        warning('取消文件选取！')
end

%% 输出BOM
ctab11 = table2cell(dat.pipe(:,4:6));
ctab11 = addCTabHead(ctab11,{'管子'});
% ctab11 = addCTabHead(ctab11,{'管子'},{'名称及规格','材料','长度'});
ctab12 = table2cell(dat.flange(:,[7,4,5]));
ctab12 = addCTabHead(ctab12,{'法兰'});
% ctab12 = addCTabHead(ctab12,{'法兰'},{'规格','数量'});
ctab13 = table2cell(dat.gasket(:,[7,3,6]));
ctab13 = addCTabHead(ctab13,{'垫片'});
% ctab13 = addCTabHead(ctab13,{'垫片'},{'规格','数量'});
ctab14 = table2cell(dat.boltNut(:,[7,8,5]));
ctab14 = addCTabHead(ctab14,{'螺栓（柱）及螺母'});
% ctab14 = addCTabHead(ctab14,{'螺栓（柱）及螺母'},{'规格','数量'});
ctab21 = table2cell(dat.valve(:,3:6));
ctab21 = addCTabHead(ctab21,{'阀门'});
% ctab21 = addCTabHead(ctab21,{'阀门'},{'规格及型号','材料','数量','标准'});
ctab22 = table2cell(dat.fitting(:,3:6));
ctab22 = addCTabHead(ctab22,{'管件'});
% ctab22 = addCTabHead(ctab22,{'管件'},{'规格及型号','材料','数量','标准'});
ctab23 = table2cell(dat.special(:,3:6));
ctab23 = addCTabHead(ctab23,{'特殊件'});
% ctab23 = addCTabHead(ctab23,{'特殊件'},{'名称','材料','数量','规格及型号'});
% ctabRow1 = fillCells({ctab11,ctab12,ctab13,ctab14});
% ctabRow2 = fillCells({ctab21,ctab22,ctab23});
% ctab = fillCells({ctabRow1;ctabRow2});
ctab = fillCells({ctab11;ctab12;ctab13;ctab14;ctab21;ctab22;ctab23});
% 将生成的数据写人Excel文件
writecell(ctab,'bom1.xlsx')

function oCells = fillCells(embeddedCell)
    % 检查输入参数
    if ~iscell(embeddedCell)
        error('【错误】函数fillCells()的输入参数数据类型应为cell')
    end
    if size(embeddedCell,1) == 1 % 行向量
        % 输入胞向量为行向量时
        rowNum = max(cellfun(@(x)size(x,1),embeddedCell));
        colNum = sum(cellfun(@(x)size(x,2),embeddedCell));
        oCells = cell(rowNum,colNum);
        posRow = 1; posCol = 1;
        for iCell = 1:length(embeddedCell)
            cSize = size(embeddedCell{iCell});
            oCells(posRow:posRow+cSize(1)-1,posCol:cSize(2)+posCol-1) = embeddedCell{iCell};
            posRow = 1; % 由于嵌套单元是行向量，输入单元的行位置固定为1
            posCol = posCol+cSize(2); % 下个嵌套单元输入的列位置
        end
    elseif size(embeddedCell,2) == 1 % 列向量
        rowNum = sum(cellfun(@(x)size(x,1),embeddedCell));
        colNum = max(cellfun(@(x)size(x,2),embeddedCell));
        oCells = cell(rowNum,colNum);
        posRow = 1; posCol = 1;
        for iCell = 1:length(embeddedCell)
            cSize = size(embeddedCell{iCell});
            oCells(posRow:posRow+cSize(1)-1,posCol:cSize(2)+posCol-1) = embeddedCell{iCell};
            posRow = posRow+cSize(1); % 下个嵌套单元输入的行位置
            posCol = 1; % 由于嵌套单元是列向量，输入单元的列位置固定为1
        end
    else
        error('【错误】函数fillCells()的输入参数应为胞向量')
    end
end


function out = bar2MPa(cArray)
    if iscell(cArray)
        out = cellfun(@(x)sprintf('%.1f',x/10),cArray,'UniformOutput',false);
    else
        warning('函数bar2MPa()输入参数应为胞向量！')
        out = missing;
    end
end

function oStruct = classifySum(tab,catStr,sumStr,structName,iStruct)
    if ~isa(tab,'table')
        error('【错误】函数classifySum()输入参数数据类型有误！')
    end
    listCatStr = categories(categorical(tab.(catStr)));
    for iList = 1:length(listCatStr) % 分类求和
        idx = strcmp(listCatStr{iList},tab.(catStr));
        tab.(sumStr)(find(idx,1)) = sum(tab.(sumStr)(idx));
        idx(find(idx,1)) = false;
        tab(idx,:) = [];
    end
    oStruct = iStruct;
    oStruct.(structName) = tab;
end

function octab = addCTabHead(ctab,head1,head2)
    % 检查输入参数
    if exist('head2','var')
        if ~all([iscell(ctab),iscell(head1),iscell(head2)])
            error('【错误】函数addCTabHead()输入参数数据类型有误！')
        end
        if size(ctab,2) == size(head2,2)
            ctabHead = cell(2,size(ctab,2));
            ctabHead(1,1) = head1;
            ctabHead(2,:) = head2;
            octab = [ctabHead;ctab];        
        else
            error('【错误】函数addCTabHead()输入参数head2的尺寸%d有误！',size(head2,2))
        end
    else
        ctabHead = cell(size(ctab,1),1);
        ctabHead(1,1) = head1;
        octab = [ctabHead,ctab];
    end

end