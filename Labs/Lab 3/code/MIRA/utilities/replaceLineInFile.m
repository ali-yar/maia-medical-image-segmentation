function replaceLineInFile(file,oldLine,newLine)
    % read content of file
    fid = fopen(file, 'r');
    s = textscan(fid, '%s', 'delimiter', '\n');
    fclose(fid);
    % find line and replace it with new line
    idx = find(strcmp(s{1}, oldLine), 1, 'first');
    s{1}{idx} = newLine;
    % overwrite the file with new content
    fid = fopen(file, 'w+');
    fprintf(fid,'%s\n',s{1}{:});
    fclose(fid);
end