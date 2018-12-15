function niftiwriteWrapper(V, filename, V_ref, compressed, endian)

if ~exist('compressed', 'var')
   compressed = false;
end
if ~exist('endian', 'var')
   endian = 'little';
end

if isa(V_ref,'struct')
    metadata = V_ref;
else
    metadata = rmfield(niftiinfo(V_ref),{'Filename','Filemoddate','Filesize'});
end

V = convertToDataype(V,metadata.Datatype);

niftiwrite(V,filename,metadata,'Compressed',compressed,'Endian',endian);

    function V = convertToDataype(V,datatype)
        switch datatype
            case 'single'
                if ~isa(V,'single'), V = single(V); end
            case 'double'
                if ~isa(V,'double'), V = double(V); end
            case 'uint8'
                if ~isa(V,'uint8'), V = uint8(V); end
            case 'uint16'
                if ~isa(V,'uint16'), V = uint16(V); end
            case 'uint32'
                if ~isa(V,'uint32'), V = uint32(V); end
            case 'uint64'
                if ~isa(V,'uint64'), V = uint64(V); end
            case 'int8'
               if ~isa(V,'int8'), V = int8(V); end
            case 'int16'
                if ~isa(V,'int16'), V = int16(V); end
            case 'int32'
                if ~isa(V,'int32'), V = int32(V); end
            case 'int64'
                if ~isa(V,'int64'), V = int64(V); end
        end
    end

end