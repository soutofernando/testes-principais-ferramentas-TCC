*** Settings ***
Documentation    Testes de aceitacao para carga inicial de filmes via CSV.
Resource         resources/filmnow_keywords.resource

*** Test Cases ***
Carregar Filmes De Arquivo CSV
    [Documentation]    Deve carregar filmes do arquivo inicial e popular o sistema.
    [Setup]    Criar Fachada Limpa
    ${quantidade}=    Carregar Filmes    filmes_inicial.csv
    Should Be True    ${quantidade} > 0
    Nome Na Posicao Deve Ser    1    Anatomia de uma Queda
    Nome Na Posicao Deve Ser    2    Pobres Criaturas
    Nome Na Posicao Deve Ser    3    Shrek 2

Carregar Filmes E Detalhar Filme Carregado
    [Documentation]    Filmes carregados devem permitir detalhamento completo.
    [Setup]    Criar Fachada Limpa
    Carregar Filmes    filmes_inicial.csv
    ${detalhes}=    Detalhar Filme    1
    Should Contain    ${detalhes}    Anatomia de uma Queda
    Should Contain    ${detalhes}    2024

Carregar Filmes E Listar Posicoes Ocupadas
    [Documentation]    A listagem deve refletir os filmes carregados do CSV.
    [Setup]    Criar Fachada Limpa
    Carregar Filmes    filmes_inicial.csv
    ${formatado}=    Formatar Filme    3    Shrek 2
    Should Be Equal    ${formatado}    3 - Shrek 2

Carregar Filmes E Adicionar Novo Filme
    [Documentation]    Deve permitir adicionar novos filmes apos carga inicial.
    [Setup]    Criar Fachada Limpa
    Carregar Filmes    filmes_inicial.csv
    Adicionar Filme Com Sucesso    10    Novo Filme    2025    Netflix
    Nome Na Posicao Deve Ser    10    Novo Filme

Carregar Filmes E Impedir Duplicidade
    [Documentation]    Filmes carregados devem respeitar regra de duplicidade por nome e ano.
    [Setup]    Criar Fachada Limpa
    Carregar Filmes    filmes_inicial.csv
    Adicionar Filme Deve Falhar    20    Shrek 2    2004    Prime Video
