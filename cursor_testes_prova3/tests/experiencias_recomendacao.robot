*** Settings ***
Documentation     Testes de aceitação - experiências de recomendação (Parte 2)
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Test Cases ***
Cadastrar Experiencia Recomendacao Adiciona Experiencia Ao Candidato
    Cadastrar Candidato    Vera Rec    vera.rec@email.com
    Cadastrar Experiencia Recomendacao    vera.rec@email.com    Prof. Silva    Carta de recomendacao    2    10
    ${experiencias}=    Listar Experiencias Candidato    vera.rec@email.com
    Length Should Be    ${experiencias}    1
    Should Contain    ${experiencias}[0]    Recomendação#1
    Should Contain    ${experiencias}[0]    Prof. Silva
    Should Contain    ${experiencias}[0]    Carta de recomendacao

Codigo Experiencia Recomendacao E Sequencial
    Cadastrar Candidato    Will Rec    will.rec@email.com
    Cadastrar Experiencia Recomendacao    will.rec@email.com    Prof. A    Carta A    1    5
    Cadastrar Experiencia Recomendacao    will.rec@email.com    Prof. B    Carta B    3    8
    ${experiencias}=    Listar Experiencias Candidato    will.rec@email.com
    Should Contain    ${experiencias}[0]    Recomendação#1
    Should Contain    ${experiencias}[1]    Recomendação#2

Calculo XP Recomendacao Avaliacao Mais Valor Base
    Cadastrar Candidato    XP Rec Um    xp.rec1@email.com
    Cadastrar Experiencia Recomendacao    xp.rec1@email.com    Prof. X    Carta X    3    10
    ${pontos}=    Exibir Pontos Experiencias Candidato    xp.rec1@email.com
    Should Be Equal As Numbers    ${pontos}    13.0

Calculo XP Recomendacao Com Avaliacao Minima
    Cadastrar Candidato    XP Rec Dois    xp.rec2@email.com
    Cadastrar Experiencia Recomendacao    xp.rec2@email.com    Prof. Y    Carta Y    1    5
    ${pontos}=    Exibir Pontos Experiencias Candidato    xp.rec2@email.com
    Should Be Equal As Numbers    ${pontos}    6.0

Calculo XP Recomendacao Com Avaliacao Maxima
    Cadastrar Candidato    XP Rec Tres    xp.rec3@email.com
    Cadastrar Experiencia Recomendacao    xp.rec3@email.com    Prof. Z    Carta Z    3    7
    ${pontos}=    Exibir Pontos Experiencias Candidato    xp.rec3@email.com
    Should Be Equal As Numbers    ${pontos}    10.0

Representacao Recomendacao Contem Todas As Informacoes
    Cadastrar Candidato    Info Rec    info.rec@email.com
    Cadastrar Experiencia Recomendacao    info.rec@email.com    Prof. Completo    Texto da carta    2    15
    ${experiencias}=    Listar Experiencias Candidato    info.rec@email.com
    Should Contain    ${experiencias}[0]    Recomendação#1
    Should Contain    ${experiencias}[0]    Prof. Completo
    Should Contain    ${experiencias}[0]    Texto da carta
    Should Contain    ${experiencias}[0]    2
    Should Contain    ${experiencias}[0]    15
