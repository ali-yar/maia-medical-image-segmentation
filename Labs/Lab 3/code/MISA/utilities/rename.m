function rename(dir_, id) 
    data = dir(fullfile(dir_,'*.0.*'));
    for i = 1:numel(data)
        newName = replace(data(i).name,".0.",sprintf(".%s.init.",id));
        
        movefile(fullfile(data(i).folder,data(i).name),...
            fullfile(data(i).folder,newName));
    end
    data = dir(fullfile(dir_,'*.1.*'));
    for i = 1:numel(data)
        newName = replace(data(i).name,".1.",sprintf(".%s.",id));
        
        movefile(fullfile(data(i).folder,data(i).name),...
            fullfile(data(i).folder,newName));
    end
end