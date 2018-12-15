function saveAtlasLabels(Volms, labels, filename_tmplt, Volm_ref, compressed)

metadata = rmfield(niftiinfo(Volm_ref), ...
    {'Filename','Filemoddate','Filesize'});

for i = 1:numel(Volms)
    filename = strcat(filename_tmplt,num2str(labels(i)));
    niftiwriteWrapper(Volms{i}, filename, metadata, compressed);
end

end

