*** Settings ***
Documentation    Testes de aceitacao para listagem de filmes no FilmNow.
Resource         resources/filmnow_keywords.resource

*** Test Cases ***
Listar Filmes Com Sistema Vazio
    [Documentation]    Sistema sem filmes deve manter posicoes vazias.
    [Setup]    Criar Fachada Limpa
    Posicao Deve Estar Vazia    1
    Posicao Deve Estar Vazia    50
    Posicao Deve Estar Vazia    100

Listar Filmes Com Um Filme Cadastrado
    [Documentation]    Deve retornar o nome do filme na posicao cadastrada.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    7    Interestelar    2014    Prime Video
    Nome Na Posicao Deve Ser    7    Interestelar
    Posicao Deve Estar Vazia    6
    Posicao Deve Estar Vazia    8

Listar Filmes Com Multiplas Posicoes Ocupadas
    [Documentation]    Deve listar corretamente filmes em posicoes nao consecutivas.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Adicionar Filme Com Sucesso    2    Pobres Criaturas    2024    Cinema
    Adicionar Filme Com Sucesso    11    Shrek 2    2004    Netflix
    Adicionar Filme Com Sucesso    60    Duna Parte 2    2024    Cinema
    Nome Na Posicao Deve Ser    1    Anatomia de uma Queda
    Nome Na Posicao Deve Ser    2    Pobres Criaturas
    Nome Na Posicao Deve Ser    11    Shrek 2
    Nome Na Posicao Deve Ser    60    Duna Parte 2
    Posicao Deve Estar Vazia    3

Listar Filmes Apos Substituicao
    [Documentation]    A listagem deve refletir o filme mais recente da posicao.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    4    Filme A    2010    Cinema
    Adicionar Filme Com Sucesso    4    Filme B    2020    Netflix
    Nome Na Posicao Deve Ser    4    Filme B

Formatar Filme Para Exibicao Na Listagem
    [Documentation]    Deve formatar a linha no padrao posicao - nome.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    ${formatado}=    Formatar Filme    1    Anatomia de uma Queda
    Should Be Equal    ${formatado}    1 - Anatomia de uma Queda

Formatar Filmes Em Posicoes Distintas
    [Documentation]    Deve formatar corretamente cada posicao ocupada.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    11    Shrek 2    2004    Netflix
    Adicionar Filme Com Sucesso    60    Duna Parte 2    2024    Cinema
    ${linha_11}=    Formatar Filme    11    Shrek 2
    ${linha_60}=    Formatar Filme    60    Duna Parte 2
    Should Be Equal    ${linha_11}    11 - Shrek 2
    Should Be Equal    ${linha_60}    60 - Duna Parte 2
