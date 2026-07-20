*** Settings ***
Documentation     Testes de aceitação - seleção de candidatos em oportunidades (Parte 1)
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Variables ***
${EMAIL_ALICE}      alice@email.com
${EMAIL_BOB}        bob@email.com
${EMAIL_CAROL}      carol@email.com
${PROJETO_VAGAS}    Projeto Selecao

*** Test Cases ***
Adicionar Candidato Com Pontos Suficientes Retorna True
    Preparar Candidato Com Pontos    ${EMAIL_ALICE}    Ana Alice    20.0
    Cadastrar Oportunidade    ${PROJETO_VAGAS}    2    10.0
    ${resultado}=    Adicionar Candidato Oportunidade    ${EMAIL_ALICE}    ${PROJETO_VAGAS}
    Should Be True    ${resultado}

Adicionar Candidato Com Pontos Insuficientes Retorna False
    Preparar Candidato Com Pontos    ${EMAIL_BOB}    Bob Silva    5.0
    Cadastrar Oportunidade    Projeto Exigente    1    10.0
    ${resultado}=    Adicionar Candidato Oportunidade    ${EMAIL_BOB}    Projeto Exigente
    Should Not Be True    ${resultado}

Adicionar Candidato Com Pontos Iguais Ao Minimo Retorna True
    Preparar Candidato Com Pontos    ${EMAIL_CAROL}    Carol Dias    10.0
    Cadastrar Oportunidade    Projeto Minimo    1    10.0
    ${resultado}=    Adicionar Candidato Oportunidade    ${EMAIL_CAROL}    Projeto Minimo
    Should Be True    ${resultado}

Listar Selecionados Por Oportunidade Vazio Quando Ninguem Foi Selecionado
    Cadastrar Oportunidade    Projeto Vazio    2    1.0
    ${selecionados}=    Listar Selecionados Por Oportunidade    Projeto Vazio
    Should Be Empty    ${selecionados}

Listar Selecionados Contem Representacao Do Candidato Selecionado
    Preparar Candidato Com Pontos    ${EMAIL_ALICE}    Diana Lima    15.0
    Cadastrar Oportunidade    Projeto Lista    1    5.0
    Adicionar Candidato Oportunidade    ${EMAIL_ALICE}    Projeto Lista
    ${selecionados}=    Listar Selecionados Por Oportunidade    Projeto Lista
    Length Should Be    ${selecionados}    1
    Should Contain    ${selecionados}[0]    Diana Lima
    Should Contain    ${selecionados}[0]    ${EMAIL_ALICE}

Oportunidade Fecha Apos Atingir Quantidade De Selecionados
    Preparar Candidato Com Pontos    alice.fechar@email.com    Alice Fechar    20.0
    Preparar Candidato Com Pontos    bob.fechar@email.com    Bob Fechar    20.0
    Cadastrar Oportunidade    Projeto Fechar    2    5.0
    Adicionar Candidato Oportunidade    alice.fechar@email.com    Projeto Fechar
    Adicionar Candidato Oportunidade    bob.fechar@email.com    Projeto Fechar
    ${oportunidades}=    Listar Oportunidades
    Should Contain    ${oportunidades}[0]    fechada
    Should Not Contain    ${oportunidades}[0]    Ainda estamos contratando!

Nao Adicionar Candidato Em Oportunidade Fechada Retorna False
    Preparar Candidato Com Pontos    carol.fechar@email.com    Carol Fechar    20.0
    Preparar Candidato Com Pontos    dave.fechar@email.com    Dave Fechar    20.0
    Preparar Candidato Com Pontos    eve.fechar@email.com    Eve Fechar    20.0
    Cadastrar Oportunidade    Projeto Lotado    2    5.0
    Adicionar Candidato Oportunidade    carol.fechar@email.com    Projeto Lotado
    Adicionar Candidato Oportunidade    dave.fechar@email.com    Projeto Lotado
    ${resultado}=    Adicionar Candidato Oportunidade    eve.fechar@email.com    Projeto Lotado
    Should Not Be True    ${resultado}

Listar Selecionados Retorna Todos Os Candidatos Selecionados
    Preparar Candidato Com Pontos    um@email.com    Candidato Um    30.0
    Preparar Candidato Com Pontos    dois@email.com    Candidato Dois    30.0
    Cadastrar Oportunidade    Projeto Multi    3    10.0
    Adicionar Candidato Oportunidade    um@email.com    Projeto Multi
    Adicionar Candidato Oportunidade    dois@email.com    Projeto Multi
    ${selecionados}=    Listar Selecionados Por Oportunidade    Projeto Multi
    Length Should Be    ${selecionados}    2

Oportunidade Aberta Com Vagas Disponiveis Exibe Mensagem Contratando
    Preparar Candidato Com Pontos    parcial@email.com    Candidato Parcial    25.0
    Cadastrar Oportunidade    Projeto Parcial    3    5.0
    Adicionar Candidato Oportunidade    parcial@email.com    Projeto Parcial
    ${oportunidades}=    Listar Oportunidades
    Should Contain    ${oportunidades}[0]    aberta
    Should Contain    ${oportunidades}[0]    Ainda estamos contratando!

*** Keywords ***
Preparar Candidato Com Pontos
    [Arguments]    ${email}    ${nome}    ${pontos_necessarios}
    Cadastrar Candidato    ${nome}    ${email}
    ${valor_base}=    Evaluate    int(${pontos_necessarios}) - 1
    Cadastrar Experiencia Recomendacao    ${email}    Prof Teste    Carta teste    1    ${valor_base}
