Opção selecionada: otimização
Otimização selecionada: inline functions

# Exemplo 1
Contém poucas chamadas de função, o programa gerado pelo código otimizado possuí 349 linhas enquanto o programa comum
possui 346 linhas. Como esperado devido a repetição das funções em diferentes trechos do código.
Ao executar os testes de performance, usando o comando `make example1`, obtivemos os seguintes resultados:
```
Tempo de execução médio sem otimização: 0.40238 seconds
Desvio padrão sem otimização: 0.02467 seconds
Tempo de execução médio com otimização: 0.40636 seconds
Desvio padrão com otimização: 0.02436 seconds
```
É possível notar que praticamente não houve melhoria de performance, o que era esperado devido a baixa quantidade 
de funções utilizadas.

# Exemplo 2
O exemplo 2 possuí uma quantidade maior de chamadas de funções para estressar positivamente ou negativamente a otimização.
O programa gerado com a otimização possui 228 linhas enquanto o programa comum possui 233 linhas. Embora a diferença de 
linhas aponte uma pequena vantagem para a otimização, isto se dá pela utilização de funções curtas. Para caso de funções 
maiores a repetição de código causada pela otimização irá gerar uma quantidade maior de linhas.
Ao executar os testes de performance, usando o comando `make example2`, obtivemos os seguintes resultados:
```
Tempo de execução médio sem otimização: 1.00485 segundos
Desvio padrão sem otimização: 0.01945 segundos
Tempo de execução médio com otimização: 0.94178 segundos
Desvio padrão com otimização: 0.01216 segundos
```
É possível notar uma maior melhora de performance devido a utilização mais intensiva de funções.

# Considerações
Embora está simples otimização já tenha causado melhorias ela ainda é bem simples, sendo possível ainda adicionais mais melhorias 
para reduzir a quantidade de linhas do código gerado. 
Existe um balanço entre a otimização causada e o número de linhas gerado. Nos exemplos dados foram utilizados programas com complexidade 
quadrática que estressem as funções utilizadas, em um caso real o inline functions se torna mais efetivo para funções com baixo número de 
chamadas. Destaco aqui, que nos ambientes de projetos reais aos quais já trabalhei são comuns funções que são utilizadas apenas uma ou duas 
vezes. Muitas vezes utilizamos funções para melhorar a legibilidade do código, e está otimização consegue reverter essa melhoria de legibilidade 
para devolver a performance. 
