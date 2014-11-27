%% =======================================================================%
% fill_holes.m                                                            %
%=========================================================================%
% Function:     fill_holes                                                %
% Author(s):    Alexander Jenkins (JEN11214787)                           %
% Description:  Fills holes within connected components of a logical image%
% Returns:      Filled logical image                                      %
%                                                                         %
% Limits:                                                                 %
%               - Importing from Java seems to be really slow             %
%=========================================================================%

%% =======================================================================%
% fill_holes                                                              %
%                                                                         %
% Arguments:                                                              %
% IN(I)         The logical image to fill holes in                        %
%=========================================================================%

function LogicalFilledImage = fill_holes(I)
% we assume we have a sensible image etc...

% spuds never touch the edge so we only need this
% threshold on our fill value
LogicalFilledImage = fill_holes_impl(uint8(I), 1, 1, 0, 3) < 3;

% otherwise we'd floodfill from every edge pixel
% then combine the returned matrices

end

% flood fill implementation using a Queue from Java
%% =======================================================================%
% fill_holes_impl                                                         %
%                                                                         %
% Arguments:                                                              %
% IN(I)         The logical image to fill holes in                        %
% IN(M)         Y location of the start of the flood fill                 %
% IN(N)         X location of the start of the flood fill                 %
% IN(T)         Target value                                              %
% IN(R)         Replacement value                                         %
%=========================================================================%
function LogicalFilledImage = fill_holes_impl(I, M, N, T, R)

MX = size(I, 1); % Height
NX = size(I, 2); % Width

% to keep track of which pixels we've visited so far
ProcessedMap = uint8(zeros(MX, NX));

% sanity checks
if(M <= 0 || M > MX)
    return
end
if(N <= 0 || N > NX)
    return
end
if(I(M, N) ~= T)
    return
end

% Really slooow
import java.util.LinkedList
Q = LinkedList();

Node = [M N];
Q.add(Node);

% can't recurse because Matlab runs out of stack space.. grumble
% put the next pixels (node) to visit in a queue and use ProcessedMap to
% determine if we've already encountered a node before
while Q.size() > 0
    Node = Q.removeLast();
    if(I(Node(1), Node(2)) == T)
        I(Node(1), Node(2)) = R;
        ProcessedMap(Node(1), Node(2)) = 1;
        
        % connectivity of four flood filling
        if(Node(1) + 1 <= MX)
            if(ProcessedMap(Node(1) + 1, Node(2)) == 0)
                Q.add([Node(1) + 1, Node(2)]);
            end
        end
        
        if(Node(1) - 1 > 0)
            if(ProcessedMap(Node(1) - 1, Node(2)) == 0)
                Q.add([Node(1) - 1, Node(2)]);
            end
        end
        
        if(Node(2) + 1 <= NX)
            if(ProcessedMap(Node(1), Node(2) + 1) == 0)
                Q.add([Node(1), Node(2) + 1]);
            end
        end
        
        if(Node(2) - 1 > 0)
            if(ProcessedMap(Node(1), Node(2) - 1) == 0)
                Q.add([Node(1), Node(2) - 1]);
            end
        end
    end
end

LogicalFilledImage = I;

end