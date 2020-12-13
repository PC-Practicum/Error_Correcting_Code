% DECODEER FUNCTIE
% Deze functie decodeerd een gegeven codewoord en corrigeert voor
% eventuele fouten, hiervoor is de generator matrix nodig
%
% De decodeer functie neemt vier argumenten. 
%
% 1) G, dit is de generatormatrix
% 2) C, dit is het codewoord dat gedecodeerd moet worden
% 3) T, dit is de naam van het syndroom-foutvector tabel bestand. 
%    (Optioneel: voor snelheid) Voorbeeld: 'tabel.txt'
% 4) E, dit is een bolean, waarde 1 als je een tabel met naam T wil maken
%    waarde 0 als je een tabel met naam T wil importeren

function W = decodeer(G, C, T, E)
tic
[n,k] = size(G);
if E
    M = unique(nchoosek(repmat([1 0], 1,k), k), 'rows');
    % Dit zijn alle mogelijke codewoord combinaties
    
    R = unique(nchoosek(repmat([1 0], 1,k-n), k-n), 'rows');
    % Dit zijn alle mogelijke syndromen
    
    U = ones(2^(k-n),k);% Dit zijn de foutvectoren per syndrom 
                        %(rij komt overeen met syndroom op zelfde rij in R)
    Z = zeros(size(R,1),1);% Dit zijn de syndromen waarvoor er
                       % verschillende opties waren voor de foutvector
                       % (rij komt overeen met syndroom op zelfde rij in R)
                        
    for g=1:2^k% Ga over alle mogelijke codewoorden
        W=M(g,:);% Neem get codewoord uit de matrix
        idx = find(ismember(R, syndrom(W,G),'rows'));
        % Genereer syndroom van codewoord
        % En kijk met welk syndroom dit overeen komt en neem de rij index
        
        if sum(U(idx,:)) > sum(W)
            U(idx,:) = W;% Plaats deze vector op de rij wanneer zijn 
                         % gewicht lager is dan degene die er al staat
            Z(idx,:) = 0;% Er is een nieuwe optie gevonden! RESET
        elseif sum(U(idx,:)) == sum(W)
            Z(idx,:) = sum(W);% Hou bij voor welke foutvector er
                              % verschillende opties waren
        end
    end
    
    % Maak matrix voor syndroom-foutvector tabel
    L = [R, U, Z];

    % Slaag de tabel-matrix op
    writematrix(L,T);
else
    % Importeer de nodige data aan de hand van een tabel-matrix
    L = readmatrix(T);% en splits in de juiste stukken
    R = L(:,1:k-n);
    U = L(:,k-n+1:2*k-n);
    Z = L(:,2*k-n+1:size(L,2));
end

idx = find(ismember(R, syndrom(C,G),'rows'));% Berekend de index voor de
                                   % foutvector, gebaseerd op het syndroom
                                   % van het codewoord
if Z(idx,:) ~= 0% Check of er verchillende mogelijkheden voor de foutvector
                % zijn
    disp([newline, ...
        'Het codewoord kan op verschillende manieren gedecodeerd worden'])
end

FV = U(idx,:);% Neem de foutvector uit de FV-matrix

if FV == zeros(1,k)% Check ofdat er een fout verbeterd zal worden
    disp([newline, 'Er moest geen fout verbeterd worden'])
else
    disp([newline,'Er zat een fout in het codewoord, deze werd verbeterd'])
end

W=mod(C-FV,2);% Trek de foutvector af van het codewoord en neem modulo 2

W=W(1:n);% Snijd het stuk codewoord af dat overeen komt met de woordlengte

time=toc;
disp([newline, 'Berekening duurde ',num2str(time),' seconden', newline, ...
    'Het gedecodeerde woord is: ', mat2str(W)]);
% Toon de uitkomst en de tijd die de functie nodig had

end

% Bereken syndroom van gegeven code met G en zijn afmetingen
function S = syndrom(W,G)
    [n,k] = size(G);
    P = G(1:n,n+1:k);
    H = [P', eye(size(P',1))];
    S = mod(W*H',2);
end
