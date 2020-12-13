% CODEER FUNCTIE
% Deze functie codeert een gegeven codewoord,
% hiervoor is de generator matrix nodig
%
% De codeer functie neemt twee argumenten. 
%
% 1) G, dit is de generatormatrix
% 2) W, dit is het woord dat gecodeert moet worden

function C = codeer(G,W)
C = mod(W*G, 2);
end
