function [id] = getFileId(filename)

expression = '\d+[.]';
id = regexp(filename,expression,'match');
id = extractBefore(id{end}, ".");

end

