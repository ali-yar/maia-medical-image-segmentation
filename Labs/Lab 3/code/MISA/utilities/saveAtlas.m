function [] = saveAtlas(V, labels, out_dir, compressed)
%saveAtlas

if ~exist(out_dir, 'dir')
   mkdir(out_dir);
end

if labels == -1
    filename = fullfile(out_dir,"atlas_template.nii");
    niftiwrite(V,filename,'Compressed',compressed);
else
    for i = 1:numel(V)
        filename = fullfile(out_dir,sprintf("atlas_label_%d.nii",labels(i)));
        niftiwrite(V{i},filename,'Compressed',compressed);
    end
end



% if labels == -1
%     filename = fullfile(out_dir,"atlas_template.nii");
% 	info = niftiinfo(filename);
%     info.Qfactor = -1;
%     info.SpatialDimension = 0;
%     info.TransformName = 'Sform';
%     niftiwrite(V,filename,info,'Compressed',compressed);
% else
%     for i = 1:numel(V)
%         filename = fullfile(out_dir,sprintf("atlas_label_%d.nii",labels(i)));
%         info = niftiinfo(filename);
%         info.Qfactor = -1;
%         info.TransformName = 'Sform';
%         niftiwrite(V{i},filename,info,'Compressed',compressed);
%     end
% end


end

