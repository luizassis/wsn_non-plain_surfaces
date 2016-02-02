function Simulacao
% Cabeçalho
% Nome: Luiz Fernando Ferreira Gomes de Assis RA: 823261
% Curso: Bacharelado em Ciência da Computação
% Prof. Dr. João E. M. Perea Martins
% Não possui variáveis de entrada e de saída

 %% Inicialização das variáveis
 % mudando para o formato com apenas quatro casas decimais
 format short;
 % esta função altera a semente (valor inicial da geração dos
 % números randômicos) dos valores aleatórios gerados pela função
 % rand, usando o vetor clock
 rand('twister',1000*sum(clock));

 % rede_simulacao é o vetor que contém a quantidade de nós analisados
 % durante um determinado experimento
 rede_simulacao = [20 50 100 200 500];

 % quant_rede_simulacao é a quantidade de experimentos realizados para
 % valores distintos de rede_simulação
 quant_rede_simulacao = length(rede_simulacao);

 % R é o alcance do rádio de transmissão dos sensores analisados durante um
 % determinado experimento
 R = [0.0004 0.002 0.004 0.02 0.04 0.2 0.4 0.8 1.2 1.6 2.0];

 % quant_R é a quantidade de experimentos realizados para valores
 % diferentes de R
 quant_R = length(R);

 % quantidade máxima de simulações
 quant_simulacao = 10;

 % fid é uma variável inteira que associa o arquivo criado a seu endereço lógico
 % a função fopen possui dois parâmetros, o primeiro é o arquivo
 % criado, escrito ou lido. O segundo parâmetro declara o que vamos
 % fazer no arquivo, ler ou escrever, neste caso iremos escrever
 % (w - write(escrever em inglês). Lembrando que a extensão do
 % arquivo criado é txt.
 fid = fopen('Simulacao.txt','w');

 %% Início das simulações
 % Simulações feitas para diversas quantidade de nós
 for iter_rede_simulacao = 1:quant_rede_simulacao
 % Escreve no arquivo a quantidade de nos testados
 fprintf(fid,'%s %d','A quantidade de sensores testados é :
',rede_simulacao(iter_rede_simulacao));
 fprintf(fid,'\r\n\r\n');

 % Simulações realizadas para diversos valores de rádio de
 % transmissão
 for iter_R = 1:quant_R
 % Escreve no arquivo o alcance do rádio de transmissão
 fprintf(fid,'%s %5.4f','O alcance do rádio de transmissão e : ',R(iter_R));
 fprintf(fid,'\r\n\r\n');

 % Controle das iterações nas simulações realizadas
 for iteracao = 1:quant_simulacao

 % ponto_x é o vetor de coordenadas x dos sensores no plano, tal valor é
 % conseguido através da geração aleatória de valores
 ponto_x = - 2 + 4*rand([1 rede_simulacao(iter_rede_simulacao)]);
 % ponto_y é o vetor de coordenadas y dos sensores no plano, tal valor é
 % conseguido através da geração aleatória de valores
 ponto_y = - 2 + 4*rand([1 rede_simulacao(iter_rede_simulacao)]);
 % o nó com indíce 1 é considerado o sink (nó servidor que
 % recebe as informações), ele terá posicionamento fixo e
 % estará posicionado na posição 0 em x e 0.5 em y
 ponto_x(1) = 0;
 ponto_y(1) = 0.5;

 % ponto_z é o vetor de coordenadas z dos sensores no plano, a equação
 % das coordenadas é a mesma
 % *********** A fórmula deve ser alterada
 ponto_z = ponto_x.* exp(-ponto_x.^2 - ponto_y.^2);

 % inicializa a matriz de posições pos
 pos = zeros(rede_simulacao(iter_rede_simulacao),3);

 % O for é para estabelecer uma matriz de 2 colunas e quant linhas, ou seja,
 % uma matriz que possui a posição dos quant nós, a primeira coluna possui
 % a coordenada x(horizontal) de cada nó e a segunda coluna possui a coordenada
 % y(vertical).
 for sensor=1:rede_simulacao(iter_rede_simulacao)
 pos(sensor,1) = ponto_x(sensor);
 pos(sensor,2) = ponto_y(sensor);
 pos(sensor,3) = ponto_z(sensor);
 end
 % A função fprintf escreve no arquivo o que queremos, o primeiro
 % parâmetro possui a variável associada ao arquivo que iremos
 % utilizar, o segundo parâmetro é o tipo associado ao que
 % iremos escrever no arquivo. E o terceiro é o que iremos
 % escrever.
 fprintf(fid, '%s', 'Matriz de posicionamento dos sensores:');
 fprintf(fid,'\r\n');
 % Escreve no arquivo a matriz de posicionamento dos nós
 for sensor = 1:rede_simulacao(iter_rede_simulacao)
 fprintf(fid,'%d) x = %5.4f || y = %5.4f || z = %5.4f\r\n',sensor,
pos(sensor,1),pos(sensor,2),pos(sensor,3));
 end
 %% Atribuição dos valores das distâncias entre os nós

 % Curvas é o conjunto de vetores que incluem o intervalo de
 % valores traçados entre dois nós, o tamanho da variável
 % Curvas
 Curvas = cell(rede_simulacao(iter_rede_simulacao), rede_simulacao(iter_rede_simulacao));

 % Inicialização da matriz de distâncias
 dis = zeros(rede_simulacao(iter_rede_simulacao));

 % analisa os sensores, traçando curvas que acompanham as curvas do
 % relevo, somente se as mesmas tiverem comprimento inferior ao valor de
 % R
 for analisado=1:1:rede_simulacao(iter_rede_simulacao)

 for comparado=analisado+1:1:rede_simulacao(iter_rede_simulacao)

 % Chama a função distancia, com as coordenadas dos
 % pontos analisados como parâmetro de entrada. A função
 % retorna os vetores x, y e z, que designam o
 % intervalo de pontos traçados entre os dois
 % sensores e formarão a curva traçada entre eles.
 [Curvas{analisado, comparado, 1}, Curvas{analisado, comparado, 2},
Curvas{analisado, comparado, 3},dis(analisado, comparado)] =
distancia(ponto_x(analisado),ponto_y(analisado), ponto_z(analisado),
ponto_x(comparado),ponto_y(comparado), ponto_z(comparado));
 % a distância entre o sensor analisado e o
 % comparado é a mesma do sensor comparado para o
 % analisado, já que se trata dos mesmos nós de
 % análise
 dis(comparado, analisado) = dis(analisado, comparado);
 Curvas{comparado, analisado, 1} = Curvas{analisado, comparado, 1};
 Curvas{comparado, analisado, 2} = Curvas{analisado, comparado, 2};
 Curvas{comparado, analisado, 3} = Curvas{analisado, comparado, 3};

 end

 end

 % Escreve no arquivo a matriz de distâncias entre os
 % sensores
 fprintf(fid,'\r\n');
 fprintf(fid,'%s','Matriz de distâncias entre os sensores :');
 fprintf(fid,'\r\n');
 for sensor_1 = 1:rede_simulacao(iter_rede_simulacao)
 fprintf(fid,'%d) ',sensor_1);
 for sensor_2 = 1:rede_simulacao(iter_rede_simulacao)
 fprintf(fid,' %5.4f ',dis(sensor_1, sensor_2));
 end
 fprintf(fid,'\r\n');
 end

 %% Atribuição dos valores de conectividade entre os nós
 % Inicialização da matriz MC
 MC = zeros(rede_simulacao(iter_rede_simulacao), rede_simulacao(iter_rede_simulacao));
 % O primeiro for percorre as linhas e o segundo for percorre a 

 % as colunas da matriz conectividade. Lembrando que a conectividade
 % é estabelecida através de uma constante, esta constante assume valores
 % entre zero e um. Se a distância entre dois nós for menor que a constante
 % então os nós possuem uma conectividade, caso contrário, não possuem.
 for sensor_1 = 1:rede_simulacao(iter_rede_simulacao)
 for sensor_2 = sensor_1:rede_simulacao(iter_rede_simulacao)
 if(dis(sensor_1, sensor_2) < R(iter_R))
 MC(sensor_1, sensor_2) = 1;
 MC(sensor_2, sensor_1) = MC(sensor_1, sensor_2);
 end
 end
 end
 % Escreve no arquivo a matriz de conectividade entre os nós
 fprintf(fid,'\r\n');
 fprintf(fid,'%s', 'Matriz de conectividade entre os sensores :');
 fprintf(fid,'\r\n');
 for sensor_1 = 1:rede_simulacao(iter_rede_simulacao)
 fprintf(fid,'%d) ',sensor_1);
 for sensor_2 = 1:rede_simulacao(iter_rede_simulacao)
 fprintf(fid,'%d ',MC(sensor_1, sensor_2));
 end
 fprintf(fid,'\r\n');
 end

 %% Busca em Largura
 % Inicialização das variáveis
 proximo = 1;
 ler = 1;
 VR = zeros(1,rede_simulacao(iter_rede_simulacao));
 VS = zeros(1,rede_simulacao(iter_rede_simulacao));
 VS(ler) = ler;
 % quantidade de nós conectados
 conectado = 1;

 % Se a variável ler for maior que a quantidade de nós então ocorreu a
 % leitura de todos os nós, ou se VS(ler) for igual zero, quer dizer que
 % não foi adicionado nenhum novo elemento no vetor, logo todos os
 % elementos que possuem ligação com o nó raiz já foram inseridos
 while(ler <= rede_simulacao(iter_rede_simulacao) && VS(ler) ~= 0)
 % Entra se no VS conter algum nó
 if (VS(ler) ~= 0)
 % Este for é para percorrer toda as colunas (nós)
 % da matriz de conectividade, para saber com qual
 % nó cada nó possui ligação.
 for j = 1:rede_simulacao(iter_rede_simulacao)
 
 % Se MC(VS(ler),j) for igual a um sigfica que o nó que
 % está sendo lido possui ligação com o nó j, logo ele deve
 % ser armazenado no VS, caso ele ainda não foi.
 if (MC(VS(ler),j) == 1)
 
 % pressupõe-se que o elemento não está contido no vetor
 % através da variável ok recebendo um
 ok = 1;

 for i = 1:proximo
 % Caso ele esteja contido no vetor é armazenado
% valor zero na variável ok
 if (VS(i) == j)
 ok = 0;
break;
 end
 end
 % se ok for igual um significa que o elemento não está
 % contido no vetor, ele é então adicionado
 if (ok == 1)
 proximo = proximo + 1;
 VS(proximo) = j;

% incrementa-se a variável conectado
conectado = conectado + 1;

 % Quando for adicionado guarda-se no vetor de
 % roteamento o seu primeiro antecessor.
if (VR(j) == 0)
 VR(j) = VS(ler);
 end
 end
 end
 end
 end
 ler = ler + 1;
 end
 % Escreve no arquivo os vetores conectados
 fprintf(fid,'\r\n');
 fprintf(fid,'%s', 'Vetor de sensores conectados :');
 fprintf(fid,'\r\n');
 for sensor = 1:conectado
 fprintf(fid,'%d ',VS(sensor));
 end

 fprintf(fid,'\r\n');

 % Escreve no arquivo o vetor de roteamento
 fprintf(fid,'\r\n');
 fprintf(fid,'%s', 'Vetor de roteamento entre os sensores :');
 fprintf(fid,'\r\n');
 for sensor = 1:rede_simulacao(iter_rede_simulacao)
 fprintf(fid,'%d ',VR(sensor));
 end

 fprintf(fid,'\r\n');

 % função que permite a disposição de mais de um gráfico na tela de
 % figuras do matlab
 %hold off;

 %% Geração de Pacotes 
 
 % caso tenha apenas um nó conectado na rede, seria
 % apenas o nó sink
 if (conectado ~= 1)
 % Quantidade de blocos de simulação
 quant_bloco_simulacao = 30;
 % quantidade de ciclos de simulação
 quant_ciclo_simulacao = 10000;

 % Inicialização da variável LqA
 % LqA é o vetor que contém a quantidade máxima de elementos
 % encontrados na Fila durante cada bloco de simulação
 LqA = cell(1,conectado);

 for bloco_simulacao = 1:quant_bloco_simulacao

 % Inicializa-se a variável de pacotes gerados com o valor 0
 % para cada produtor
 gerado(1:rede_simulacao(iter_rede_simulacao)) = 0;

 % Inicialização do vetor de comprimento da fila em uma determinada
 % iteração
 Lq = cell(1, rede_simulacao(iter_rede_simulacao));
 % Inicialização da fila de pacotes
 Fila = cell(1, rede_simulacao(iter_rede_simulacao));
 % valor de lambida para uso na distribuição de
 % Poisson
 lambida = 1;
 % pacote é definido com 1 como valor simbólico
 pacote = 1;

 % produtor é o nó que gera pacotes em um determinado
 % momento, ele poderá ser qualquer nó conectado direta
 % ou indiretamente ao nó sink
 produtor = conectado;
 for ciclo_simulacao = 1:quant_ciclo_simulacao
 % Insere na Fila poissrnd(lambida) pacotes
 % poissrnd(lambida) é uma função que dado uma
 % distribuição de Poisson com lambida como
 % parâmetro retorna um valor a partir de zero com
 % base nas probabilidades da distribuição
 quant_pacote = poissrnd(lambida);
 for i = 1:quant_pacote
 % Insere tal pacote no fim da Fila
 Fila{1, VS(produtor)}(length(Fila{1, VS(produtor)})+1) = pacote;

 end


 % Caso o tamanho da Fila do produtor analisado seja maior do que zero, existe
 % pacotes na Fila, logo o pacote na primeira posição é
 % processado
 if (length(Fila{1,VS(produtor)}) > 0)
 % o nó antecessor recebe processando um pacote da Fila do produtor
 % analisado
 Fila{1, VR(VS(produtor))}(length(Fila{1, VR(VS(produtor))})+1) = Fila{1,
VS(produtor)}(1);
 % Retira o primeiro pacote da Fila do produtor
 % analisado
 Fila{1,VS(produtor)} = Fila{1,VS(produtor)}(2:length(Fila{1,VS(produtor)}));
 end

 % analisa o tamanho da fila do produtor ao final
 % do ciclo de simulação
 Lq{1, VS(produtor)}(ciclo_simulacao) = length(Fila{1,VS(produtor)});

 %% Tratamento para o nó sink

 if produtor == 2
 produtor = 1;

 % se a fila do nó sink for maior do que zero ele
 % deve processar algum pacote
 if (length(Fila{1,VS(produtor)}) > 0)
 % Retira o primeiro pacote da Fila do produtor
 % analisado
 Fila{1,VS(produtor)} = Fila{1,VS(produtor)}(2:length(Fila{1,VS(produtor)}));
 % analisa o tamanho da fila do produtor
 % ao final
 % dos ciclos de simulação
 Lq{1, VS(produtor)}(ciclo_simulacao) = length(Fila{1,VS(produtor)});

 end

 produtor = conectado;

 else
 produtor = produtor - 1;
 end
 end

 % A posição bloco_simulação do vetor LqA e NC de todos os produtores corresponde
ao
 % bloco_simulação analisado
 % A posição em LqA analisado recebe a quantidade máxima de pacotes encontrados
 % no vetor Lq
 % A posição em NC analisado recebe a quantidade passos de
 % simulação do bloco de simulação analisado
 for i = 1:conectado
 LqA{1,VS(i)}(bloco_simulacao) = max(Lq{1,VS(i)});

103
 end

 end

 for j = 1:conectado

 % Media dos valores encontrados em LqA
 media = mean(LqA{1,VS(j)});
 % Desvio-Padrão dos Valores encontrados em LqA
 desvio_padrao = std(LqA{1,VS(j)});
 % Valor Absoluto dos valores encontrados em LqA
 valor_absoluto = max(LqA{1,VS(j)});
 % Escreve no arquivo o produtor analisado
 fprintf(fid,'\r\n\r\n');
 fprintf(fid,'%s %d','Nó : ',VS(j));
 % Escreve no arquivo a media de LqA
 fprintf(fid,'\r\n');
 fprintf(fid,'%s %5.2f',' Media LqA : ',media);
 % Escreve no arquivo o desvio padrão
 fprintf(fid,'\r\n');
 fprintf(fid,'%s %5.2f',' Desvio-Padrao LqA : ',desvio_padrao);
 % Escreve no arquivo o valor máximo de pacotes na fila em uma
 % simulacao ao fim das iteracoes
 fprintf(fid,'\r\n');
 fprintf(fid,'%s %5.2f',' Valor Absoluto LqA : ',valor_absoluto);
 end

 end
 end

 % pula duas linhas no arquivo
 fprintf(fid,'\r\n\r\n');

 end
 end
 % fecha o arquivo que utiliza o id fid
 fclose(fid);

end
