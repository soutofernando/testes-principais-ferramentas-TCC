*** Settings ***
Documentation    Testes de aceitacao para adicao de filmes no FilmNow.
Resource         resources/filmnow_keywords.resource

*** Test Cases ***
Adicionar Filme Em Posicao Vazia
    [Documentation]    Deve cadastrar um filme em posicao vazia e retornar sucesso.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Avatar    2009    Disney+

Adicionar Filme Substituindo Existente Na Mesma Posicao
    [Documentation]    Deve substituir o filme existente quando a posicao ja esta ocupada.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    5    Filme Antigo    2000    Cinema
    Adicionar Filme Com Sucesso    5    Filme Novo    2024    Netflix
    Nome Na Posicao Deve Ser    5    Filme Novo
    Detalhes Devem Ser    5    Filme Novo    2024    Netflix

Adicionar Filme Duplicado Mesmo Nome E Ano Em Posicao Diferente
    [Documentation]    Deve negar adicao quando nome e ano ja existem no sistema.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    10    Duplo    2000    Cinema
    Adicionar Filme Deve Falhar    20    Duplo    2000    Netflix
    Posicao Deve Estar Vazia    20

Adicionar Filme Mesmo Nome Com Ano Diferente
    [Documentation]    Filmes com mesmo nome e anos diferentes nao sao considerados iguais.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    3    Matrix    1999    HBO
    Adicionar Filme Com Sucesso    4    Matrix    2021    HBO Max

Adicionar Filme Com Nome Vazio
    [Documentation]    Deve negar adicao quando o nome do filme e vazio.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Deve Falhar    1    ${EMPTY}    2023    Cinema
    Posicao Deve Estar Vazia    1

Adicionar Filme Com Local Vazio
    [Documentation]    Deve negar adicao quando o local do filme e vazio.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Deve Falhar    2    Shrek 2    2004    ${EMPTY}
    Posicao Deve Estar Vazia    2

Adicionar Filme Na Primeira Posicao Valida
    [Documentation]    Deve aceitar cadastro na posicao 1.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema

Adicionar Filme Na Ultima Posicao Valida
    [Documentation]    Deve aceitar cadastro na posicao 100.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    100    Duna Parte 2    2024    Cinema

Adicionar Filme Em Posicao Zero Deve Falhar
    [Documentation]    Posicao 0 esta fora do limite permitido (1 a 100).
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Adicionar Filme    0    Erro    2020    Local

Adicionar Filme Em Posicao Acima De 100 Deve Falhar
    [Documentation]    Posicao 101 esta fora do limite permitido (1 a 100).
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Adicionar Filme    101    Erro    2020    Local

Adicionar Filme Em Posicao Negativa Deve Falhar
    [Documentation]    Posicoes negativas sao invalidas.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Adicionar Filme    -1    Erro    2020    Local

Adicionar Multiplos Filmes Em Posicoes Distintas
    [Documentation]    Deve permitir cadastrar varios filmes em posicoes nao consecutivas.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Adicionar Filme Com Sucesso    2    Pobres Criaturas    2024    Cinema
    Adicionar Filme Com Sucesso    11    Shrek 2    2004    Netflix
    Adicionar Filme Com Sucesso    60    Duna Parte 2    2024    Cinema
    Nome Na Posicao Deve Ser    1    Anatomia de uma Queda
    Nome Na Posicao Deve Ser    2    Pobres Criaturas
    Nome Na Posicao Deve Ser    11    Shrek 2
    Nome Na Posicao Deve Ser    60    Duna Parte 2
