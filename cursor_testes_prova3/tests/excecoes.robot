*** Settings ***
Documentation     Testes de aceitação - exceções para entidades inexistentes (Parte 3)
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Test Cases ***
Cadastrar Experiencia Desenvolvimento Candidato Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Cadastrar Experiencia Desenvolvimento
    ...    inexistente@email.com    Desc    https://github.com/x    10    5

Cadastrar Experiencia Representacao Candidato Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Cadastrar Experiencia Representacao
    ...    inexistente@email.com    Cargo    2    ${False}    ${False}    1

Cadastrar Experiencia Recomendacao Candidato Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Cadastrar Experiencia Recomendacao
    ...    inexistente@email.com    Prof    Carta    2    5

Listar Experiencias Candidato Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Listar Experiencias Candidato    inexistente@email.com

Exibir Pontos Experiencias Candidato Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Exibir Pontos Experiencias Candidato    inexistente@email.com

Adicionar Candidato Oportunidade Candidato Inexistente Lanca Excecao
    Cadastrar Oportunidade    Projeto Excecao    1    1.0
    Run Keyword And Expect Error    *IllegalArgumentException*    Adicionar Candidato Oportunidade
    ...    inexistente@email.com    Projeto Excecao

Adicionar Candidato Oportunidade Oportunidade Inexistente Lanca Excecao
    Cadastrar Candidato    Candidato Valido    valido@email.com
    Run Keyword And Expect Error    *IllegalArgumentException*    Adicionar Candidato Oportunidade
    ...    valido@email.com    Projeto Inexistente

Listar Selecionados Por Oportunidade Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Listar Selecionados Por Oportunidade    Projeto Fantasma

Adicionar Candidato Oportunidade Ambos Inexistentes Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Adicionar Candidato Oportunidade
    ...    fantasma@email.com    Projeto Fantasma

Cadastrar Experiencia Desenvolvimento Excecao Possui Mensagem Adequada
    ${erro}=    Run Keyword And Expect Error    *    Cadastrar Experiencia Desenvolvimento
    ...    nao.existe@email.com    Desc    https://github.com/x    1    1
    Should Contain    ${erro}    IllegalArgumentException

Adicionar Candidato Oportunidade Excecao Possui Mensagem Adequada
    ${erro}=    Run Keyword And Expect Error    *    Adicionar Candidato Oportunidade
    ...    nao.existe@email.com    Projeto Qualquer
    Should Contain    ${erro}    IllegalArgumentException
