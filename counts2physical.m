function segments = counts2physical(segments, assume)
%COUNTS2PHYSICAL Scales segment data to physical units
%
%   COUNTS2PHYSICAL(segments)
%
%   Adds fields of dataScaled and dataScaledUnits to each segment.
%
%   COUNTS2PHYSICAL(segments, 1) If segment sensitivityUnits not given,
%   makes assumption about units based on prior communication with data
%   provider.
%
%

if nargin == 1
    assume = 0;
end

for s = 1:length(segments)
    units = getUnits_(segments(s), s, assume);
    if ~isempty(units)
        segments(s).dataScaled  = segments(s).data/segments(s).sensitivity;
        segments(s).dataScaledUnits = units;            
    end
end

function units = getUnits_(segment, s, assume) 

    units = segment.sensitivityUnits;
    if isempty(units)
        if assume == 0
            warning(['Segment units not provided for %s and assume = 0. '...
                     'Can not convert to physical units.'],...
                     segment.channel);
            return;
        end        
        % Andy Frasseto to Bob Weigel on March 8, 2023: "Units for EM
        % network code data from the U.S. should be V/M for the LQ 
        % channels and T for the LF channels".
        cha = segment.channel;
        net = segment.network;
        if startsWith(cha,'LQ') && strcmp(net,'EM')
            warning('Segment units not provided for segment %d of %s. Assuming V/m.',s, cha);
            units = 'V/m';
        elseif startsWith(cha,'LF') && strcmp(net,'EM')
            warning('Segment units not provided for segment %d of %s. Assuming T.',s, cha);
            units = 'T';
        else
            warning('Not enough information to make assumption about units.');
            return;
        end
    end
end
end