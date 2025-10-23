# Banco_de_Dados

<img src="[https://portaladama.com/wp-content/uploads/2022/05/051122_imagem_batata_adobeStock_66913132-1-scaled.jpeg](https://thumbs.dreamstime.com/b/%C3%ADcone-do-centro-de-dados-projeto-monocrom%C3%A1tico-estilo-da-cole%C3%A7%C3%A3o-grande-dos-ui-simples-perfeito-pictograma-pixel-web-126724763.jpg)">

## Descrição do Banco de Dados

Criamos o Banco de Dados para armazenar os dados do Cliente. Para fazer isso, nós criamos um Diagrama de Negócio, onde adicionamos 6 tabelas, sendo elas: "usuario","empresa","hectare","subArea","sensor" e "medicao".<br>
Cada uma dessas tabelas tabelas tem a sua função de armazenar os dados, como por exemplo:<br<br>

Tabela "usuario": Inserção dos dados do funcionário da empresa contratante, que ira monitorar os hectares e suas Subáreas, de onde vem as medições do Sensor De umidade.<br><br>
Tabela "empresa": Onde vão ficar os dados da Empresa.<br><br>
Tabela "hectare": Vai ficar os dados do hectare, sendo a identificação dos hectares e da quantidade em Kilos de batatas coletadas de cada Subáreas.<br><br>
Tabela "SubArea": Cada Subárea vai ter seu sensor, que são no total de 25 Subáreas por cada Hectare, e em cada Subárea, vai ter seu Sensor.<br><br>
Tabela "sensor": Essa tabela se refere ao próprio sensor, o diferencial é a lição fraca com a tabela "SubArea", que vai ligar o sensor com cada Subárea que faz parte do Hectare.<br><br>
Tabela "medicao": Nessa tabela vai ser inserido os dados capturados pelo sensor de umidade do solo que vai para o arduino que é capturado e processado pela API (dat-acqu-ino),
que envia para o Banco de Dados e é armazenado.<br><br>

## Sobre a Empresa

A AgroSense é uma empresa focada em soluções tecnológicas para agricultura de precisão. Nosso objetivo é apoiar agricultores com sistemas inteligentes de monitoramento, análise de dados e automação, promovendo maior produtividade, sustentabilidade e eficiência na gestão das plantações de batata inglesa.

## Contexto

A batata inglesa é uma cultura sensível a variações de umidade do solo. Excesso ou falta de água, podem prejudicar o crescimento das raízes, reduzir o rendimento e afetar a qualidade do tubérculo.

Com a crescente demanda por produtividade, sustentabilidade e qualidade agrícola, surge a necessidade de ferramentas modernas que possibilitem monitoramento contínuo e decisões estratégicas baseadas em dados.

## Objetivo

•	**Monitoramento:** Coletar dados de umidade do solo.<br>
•	**Alertas:** Notificar produtores sobre condições fora do ideal.<br>
•	**Análises:** Gerar relatórios históricos para planejamento da irrigação e colheita.<br>
•	**Prevenção:** Reduzir perdas e proteger a qualidade da produção.<br>
•	**Eficiência:** Garantir crescimento saudável e maior produtividade.<br>

## Trello
- **Plataforma de administração:** utilizamos a plataforma Trello para organizar tarefas e acompanhar o progresso do projeto, no link:(`https://trello.com/b/fyvdA3Ct/agrosense`)

## Contribuição

Para contribuir com este projeto:
1. Primeiro clone o repositório: (`git clone https://github.com/GBAlvesM/AgroSense.git`)
2. Todos os dias execute o comando para atualizar o repositório com: (`git pull`)
3. Faça as alterações necessárias e empacote com: (`git add .`)
4. Coloque uma mensagem no commit com: (`git commit -m "nome_da_alteração"`)
5. Envie suas alterações com: (`git push`)


