*** Settings ***
Documentation    Keywords reutilizaveis para testes de aceitacao do FilmNow via FachadaFilmNow.
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
