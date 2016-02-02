function [x,y,z,dis] = distancia(x1,y1,z1,x2,y2,z2)
% Nome: Luiz Fernando Ferreira Gomes de Assis RA: 823261
% dis é a variável que retorna o valor da distância entre os dois pontos
% x1, y1 e z1 são as coordenadas do ponto 1
% x2, y2 e z2 são as coordenadas do ponto 2

 % divide a distância entre os dois pontos em numero_partes vezes
 numero_partes = 10;

 % intervalo em x responsável pela determinação dos pontos em x
 intervalox = abs(x2 - x1)/numero_partes;

 % determinação dos pontos em x, iniciando em x1, terminando em x2,
 % incrementado por intervalox entre dois pontos
 if x1 < x2
 x = x1:intervalox:x2;
 else
 x = x1:-intervalox:x2;
 end

 % intervalo em y responsável pela determinação dos pontos em y
 intervaloy = abs(y2 - y1)/numero_partes;

 % efetua a alocação dos valores dependendo dos valores das coordenadas
 % y
 % determinação dos pontos em y, iniciando em y1, terminando em y2,
 % incrementado por intervalox entre dois pontos
 if y1 < y2
 y = y1:intervaloy:y2;
 else
 y = y1:-intervaloy:y2;
 end

 % intervalo em z responsável pela determinação dos pontos em z
 intervaloz = abs(z2 - z1)/numero_partes;

 % efetua a alocação dos valores dependendo dos valores das coordenadas
 % z
 % determinação dos pontos em , iniciando em x1, terminando em x2,
 % incrementado por intervalox entre dois pontos
 if z1 < z2
 z = z1:intervaloz:z2;
 else
 z = z1:-intervaloz:z2;
 end

 % função responsável
 plano_z = x.* exp(-x.^2 - y.^2);

 % atribui 0 a variável dis, valor inicial da distância entre os nós
 dis = 0;

 % efetua o cálculo da distância de acordo com a quantidade de partes
 % definida
 for iter = 1:1:numero_partes - 1

 % distancia entre dois pontos no plano tridimensional
 if plano_z(iter) >= z(iter)
 dis = dis + sqrt( (x(iter)-x(iter+1)).^2 + (y(iter)-y(iter+1)).^2 + (plano_z(iter)-plano_z(iter+1)).^2 );
 z(iter) = plano_z(iter);
 else
 dis = dis + sqrt( (x(iter)-x(iter+1)).^2 + (y(iter)-y(iter+1)).^2 + (z(iter)-z(iter+1)).^2 );
 end

 end

end
 
