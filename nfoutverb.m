% HOEVEEL-FOUTEN-VERBETEREND FUNCTIE
% Deze functie geeft aan hoeveel fouten-verbeterend een gegeven
% generator matrix is
%
% Deze functie neemt 1 argument. 
%
% 1) G, dit is de generatormatrix die getest moet worden

function N = nfoutverb(G)
    [n,k] = size(G);
    P = unique(nchoosek(repmat([1 0], 1,n), n), 'rows');% Maak alle
                                                      % mogelijke woorden
    CW = zeros(size(P,1),k);
    for c=1:size(P,1)
        CW(c,:) = mod(P(c,:)*G, 2);% Genereer alle codewoorden
    end
    CW(find(ismember(CW, zeros(1,k),'rows')),:) = [];
    G = sum(CW,2);% Bereken het gewicht van alle codewoorden
    [N,I]=min(G);% Vind het laagste gewicht
    if rem(N, 2) == 0
        disp('Deze generator matrix laat ruimte voor dubbelzinnigheid.')
    end
    N = floor(N/2);% Bereken de hoeveelheid fouten die verbeterd kunnen
                   % worden
    disp(['De generator matrix is ', int2str(N), ...
        '-fouten-verbeterend'])
end
