*** Settings ***
Documentation    Testes de aceitacao do sistema FilmNow via FachadaFilmNow.
Library          BuiltIn
Library          Collections

*** Keywords ***
Criar Fachada Limpa
    [Documentation]    Instancia uma nova FachadaFilmNow para isolar cada teste.
    ${fachada}=    Evaluate    filmnow.FachadaFilmNow()    modules=filmnow.FachadaFilmNow
    Set Test Variable    ${fachada}

Adicionar Filme
    [Arguments]    ${posicao}    ${nome}    ${ano}    ${local}
    [Documentation]    Cadastra um filme e retorna o resultado booleano da operacao.
    ${resultado}=    Call Method    ${fachada}    adicionarFilme    ${posicao}    ${nome}    ${ano}    ${local}
    RETURN    ${resultado}

Listar Filmes
    [Documentation]    Retorna o array de nomes de filmes cadastrados.
    ${filmes}=    Call Method    ${fachada}    listarFilmes
    RETURN    ${filmes}

Detalhar Filme
    [Arguments]    ${posicao}
    [Documentation]    Retorna a representacao textual do filme ou None se vazio.
    ${detalhes}=    Call Method    ${fachada}    detalharFilme    ${posicao}
    RETURN    ${detalhes}

Obter Hot List
    [Documentation]    Retorna o array de filmes da HotList.
    ${hotlist}=    Call Method    ${fachada}    obterHotList
    RETURN    ${hotlist}

Atribuir Hot
    [Arguments]    ${posicao_filme}    ${posicao_hotlist}
    [Documentation]    Atribui status hot a um filme cadastrado.
    Call Method    ${fachada}    atribuirHot    ${posicao_filme}    ${posicao_hotlist}

Remover Hot
    [Arguments]    ${posicao_hotlist}
    [Documentation]    Remove um filme da HotList na posicao informada.
    Call Method    ${fachada}    removerHot    ${posicao_hotlist}

Formatar Filme
    [Arguments]    ${posicao}    ${nome}
    [Documentation]    Formata a linha de listagem de um filme.
    ${formatado}=    Call Method    ${fachada}    formatarFilme    ${posicao}    ${nome}
    RETURN    ${formatado}

Carregar Filmes
    [Arguments]    ${arquivo}
    [Documentation]    Carrega filmes de um arquivo CSV para o sistema.
    ${quantidade}=    Call Method    ${fachada}    carregarFilmes    ${arquivo}
    RETURN    ${quantidade}

Nome Na Posicao Deve Ser
    [Arguments]    ${posicao}    ${nome_esperado}
    ${filmes}=    Listar Filmes
    ${nome}=    Get From List    ${filmes}    ${posicao}
    Should Be Equal    ${nome}    ${nome_esperado}

Posicao Deve Estar Vazia
    [Arguments]    ${posicao}
    ${filmes}=    Listar Filmes
    ${nome}=    Get From List    ${filmes}    ${posicao}
    Should Be Equal    ${nome}    ${None}

Detalhes Devem Ser
    [Arguments]    ${posicao}    ${nome}    ${ano}    ${local}    ${hot}=${False}
    [Documentation]    Valida o formato de detalhamento conforme a especificacao.
    ${detalhes}=    Detalhar Filme    ${posicao}
    ${esperado}=    Set Variable If    ${hot}    🔥 ${nome}, ${ano}\n${local}    ${nome}, ${ano}\n${local}
    Should Be Equal    ${detalhes}    ${esperado}

Detalhar Deve Retornar Vazio
    [Arguments]    ${posicao}
    ${detalhes}=    Detalhar Filme    ${posicao}
    Should Be Equal    ${detalhes}    ${None}

Adicionar Filme Com Sucesso
    [Arguments]    ${posicao}    ${nome}    ${ano}    ${local}
    ${resultado}=    Adicionar Filme    ${posicao}    ${nome}    ${ano}    ${local}
    Should Be True    ${resultado}
    Nome Na Posicao Deve Ser    ${posicao}    ${nome}

Adicionar Filme Deve Falhar
    [Arguments]    ${posicao}    ${nome}    ${ano}    ${local}
    ${resultado}=    Adicionar Filme    ${posicao}    ${nome}    ${ano}    ${local}
    Should Not Be True    ${resultado}

Hot List Deve Estar Vazia
    ${hotlist}=    Obter Hot List
    FOR    ${indice}    IN RANGE    11
        ${filme}=    Get From List    ${hotlist}    ${indice}
        Should Be Equal    ${filme}    ${None}
    END

Filme Deve Estar Na Hot List
    [Arguments]    ${posicao_hotlist}    ${nome}    ${ano}
    ${hotlist}=    Obter Hot List
    ${filme}=    Get From List    ${hotlist}    ${posicao_hotlist}
    Should Not Be Equal    ${filme}    ${None}
    ${nome_obtido}=    Call Method    ${filme}    getNome
    ${ano_obtido}=    Call Method    ${filme}    getAno
    Should Be Equal    ${nome_obtido}    ${nome}
    Should Be Equal    ${ano_obtido}    ${ano}

Posicao Hot List Deve Estar Vazia
    [Arguments]    ${posicao_hotlist}
    ${hotlist}=    Obter Hot List
    ${filme}=    Get From List    ${hotlist}    ${posicao_hotlist}
    Should Be Equal    ${filme}    ${None}

Contar Filmes Na Hot List
    ${hotlist}=    Obter Hot List
    ${quantidade}=    Evaluate    sum(1 for filme in $hotlist if filme is not None)
    RETURN    ${quantidade}

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

Detalhar Filme Em Posicao Vazia
    [Documentation]    Deve retornar vazio quando nao ha filme na posicao.
    [Setup]    Criar Fachada Limpa
    Detalhar Deve Retornar Vazio    10

Detalhar Filme Existente
    [Documentation]    Deve exibir nome, ano e local conforme especificacao.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Detalhes Devem Ser    1    Anatomia de uma Queda    2023    Cinema

Detalhar Filme Em Posicao Intermediaria
    [Documentation]    Deve detalhar corretamente filmes fora da primeira posicao.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    11    Shrek 2    2004    Netflix
    Detalhes Devem Ser    11    Shrek 2    2004    Netflix

Detalhar Filme Apos Substituicao
    [Documentation]    Deve exibir os dados do filme atualmente cadastrado na posicao.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    5    Filme Antigo    2000    Cinema
    Adicionar Filme Com Sucesso    5    Filme Novo    2024    Prime Video
    Detalhes Devem Ser    5    Filme Novo    2024    Prime Video

Detalhar Filme Hot Com Indicador
    [Documentation]    Deve exibir o emoji de hot quando o filme esta na HotList.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Atribuir Hot    1    1
    Detalhes Devem Ser    1    Anatomia de uma Queda    2023    Cinema    hot=${True}

Detalhar Filme Apos Remover Hot
    [Documentation]    Deve voltar a exibir detalhes sem indicador hot.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Atribuir Hot    1    1
    Remover Hot    1
    Detalhes Devem Ser    1    Anatomia de uma Queda    2023    Cinema

Detalhar Filme Na Ultima Posicao Valida
    [Documentation]    Deve detalhar filme cadastrado na posicao 100.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    100    Duna Parte 2    2024    Cinema
    Detalhes Devem Ser    100    Duna Parte 2    2024    Cinema

Detalhar Filme Em Posicao Zero Deve Falhar
    [Documentation]    Posicao 0 esta fora do limite permitido (1 a 100).
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Detalhar Filme    0

Detalhar Filme Em Posicao Acima De 100 Deve Falhar
    [Documentation]    Posicao 101 esta fora do limite permitido (1 a 100).
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Detalhar Filme    101

Detalhar Filme Em Posicao Negativa Deve Falhar
    [Documentation]    Posicoes negativas sao invalidas.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Detalhar Filme    -1

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
