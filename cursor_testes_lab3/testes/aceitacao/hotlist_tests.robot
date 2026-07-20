*** Settings ***
Documentation    Testes de aceitacao para HotList do FilmNow.
Resource         resources/filmnow_keywords.resource

*** Test Cases ***
Hot List Deve Iniciar Vazia
    [Documentation]    Nenhuma posicao da HotList deve conter filme no inicio.
    [Setup]    Criar Fachada Limpa
    Hot List Deve Estar Vazia

Atribuir Hot Em Posicao Vazia
    [Documentation]    Deve adicionar filme a HotList e marcar como hot.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Atribuir Hot    1    1
    Filme Deve Estar Na Hot List    1    Anatomia de uma Queda    2023
    Detalhes Devem Ser    1    Anatomia de uma Queda    2023    Cinema    hot=${True}

Atribuir Hot Substituindo Posicao Ocupada
    [Documentation]    Filme anterior deixa de ser hot ao ser substituido na HotList.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Filme A    2020    Cinema
    Adicionar Filme Com Sucesso    2    Filme B    2021    Netflix
    Atribuir Hot    1    1
    Atribuir Hot    2    1
    Filme Deve Estar Na Hot List    1    Filme B    2021
    Detalhes Devem Ser    1    Filme A    2020    Cinema
    Detalhes Devem Ser    2    Filme B    2021    Netflix    hot=${True}

Filme Nao Pode Aparecer Duas Vezes Na Hot List
    [Documentation]    Deve impedir incluir o mesmo filme em outra posicao da HotList.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Atribuir Hot    1    1
    Atribuir Hot    1    2
    Filme Deve Estar Na Hot List    1    Anatomia de uma Queda    2023
    Posicao Hot List Deve Estar Vazia    2
    ${quantidade}=    Contar Filmes Na Hot List
    Should Be Equal As Integers    ${quantidade}    1

Atribuir Hot Em Posicao De Filme Inexistente Deve Falhar
    [Documentation]    Operacao com posicao sem filme cadastrado e invalida.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Atribuir Hot    5    1
    Hot List Deve Estar Vazia

Atribuir Hot Em Posicao De Filme Invalida Deve Falhar
    [Documentation]    Posicao de filme fora do limite e invalida.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Avatar    2009    Disney+
    Run Keyword And Expect Error    *    Atribuir Hot    101    1

Exibir Hot List Com Um Filme
    [Documentation]    Deve manter o filme hot na posicao informada.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Atribuir Hot    1    1
    Filme Deve Estar Na Hot List    1    Anatomia de uma Queda    2023
    Posicao Hot List Deve Estar Vazia    2

Exibir Hot List Com Multiplos Filmes
    [Documentation]    Deve permitir varios filmes hot em posicoes distintas.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Filme A    2020    Cinema
    Adicionar Filme Com Sucesso    2    Filme B    2021    Netflix
    Adicionar Filme Com Sucesso    3    Filme C    2022    Prime Video
    Atribuir Hot    1    1
    Atribuir Hot    2    3
    Atribuir Hot    3    10
    Filme Deve Estar Na Hot List    1    Filme A    2020
    Filme Deve Estar Na Hot List    3    Filme B    2021
    Filme Deve Estar Na Hot List    10    Filme C    2022
    ${quantidade}=    Contar Filmes Na Hot List
    Should Be Equal As Integers    ${quantidade}    3

Remover Hot De Posicao Ocupada
    [Documentation]    Deve remover filme da HotList e retirar status hot.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Atribuir Hot    1    1
    Remover Hot    1
    Posicao Hot List Deve Estar Vazia    1
    Detalhes Devem Ser    1    Anatomia de uma Queda    2023    Cinema

Remover Hot Em Posicao Vazia Deve Falhar
    [Documentation]    Remover hot de posicao vazia e invalido.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Remover Hot    1

Remover Hot Em Posicao Acima Do Limite Deve Falhar
    [Documentation]    HotList aceita no maximo 10 posicoes (1 a 10).
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Avatar    2009    Disney+
    Atribuir Hot    1    1
    Run Keyword And Expect Error    *    Remover Hot    11

Atribuir Hot Na Decima Posicao Da Hot List
    [Documentation]    Deve aceitar cadastro na ultima posicao valida da HotList.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    5    Filme Hot    2024    Cinema
    Atribuir Hot    5    10
    Filme Deve Estar Na Hot List    10    Filme Hot    2024

Atribuir Hot Em Posicao Acima De 10 Deve Falhar
    [Documentation]    Posicao 11 da HotList esta fora do limite.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Avatar    2009    Disney+
    Run Keyword And Expect Error    *    Atribuir Hot    1    11
