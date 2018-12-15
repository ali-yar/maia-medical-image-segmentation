function [id] = getFileId(filename)

expression = '\d{4}[._]';
id = regexp(filename,expression,'match');
id = id{end};
id = strip(id,"_");
id = strip(id,".");

end

