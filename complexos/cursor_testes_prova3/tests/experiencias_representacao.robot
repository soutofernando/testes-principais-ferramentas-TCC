*** Settings ***
Documentation     Testes de aceitação - experiências de representação (Parte 2)
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Test Cases ***
Cadastrar Experiencia Representacao Adiciona Experiencia Ao Candidato
    Cadastrar Candidato    Sofia Rep    sofia.rep@email.com
    Cadastrar Experiencia Representacao    sofia.rep@email.com    Diretora CA    4    ${True}    ${True}    1
    ${experiencias}=    Listar Experiencias Candidato    sofia.rep@email.com
    Length Should Be    ${experiencias}    1
    Should Contain    ${experiencias}[0]    Representação#1
    Should Contain    ${experiencias}[0]    Diretora CA

Codigo Experiencia Representacao E Sequencial Entre Tipos
    Cadastrar Candidato    Tiago Mix    tiago.mix@email.com
    Cadastrar Experiencia Desenvolvimento    tiago.mix@email.com    Repo    https://github.com/tiago/r    10    5
    Cadastrar Experiencia Representacao    tiago.mix@email.com    Membro colegiado    2    ${False}    ${True}    1
    ${experiencias}=    Listar Experiencias Candidato    tiago.mix@email.com
    Should Contain    ${experiencias}[0]    Desenvolvimento#1
    Should Contain    ${experiencias}[1]    Representação#2

Calculo XP Representacao Sem Bonus
    Cadastrar Candidato    Uma Rep    uma.rep@email.com
    Cadastrar Experiencia Representacao    uma.rep@email.com    Voluntaria    3    ${False}    ${False}    5
    ${pontos}=    Exibir Pontos Experiencias Candidato    uma.rep@email.com
    Should Be Equal As Numbers    ${pontos}    3.0

Calculo XP Representacao Com Bonus Eleito
    Cadastrar Candidato    Dois Rep    dois.rep@email.com
    Cadastrar Experiencia Representacao    dois.rep@email.com    Representante eleito    2    ${True}    ${False}    1
    ${pontos}=    Exibir Pontos Experiencias Candidato    dois.rep@email.com
    Should Be Equal As Numbers    ${pontos}    4.0

Calculo XP Representacao Com Bonus Institucional
    Cadastrar Candidato    Tres Rep    tres.rep@email.com
    Cadastrar Experiencia Representacao    tres.rep@email.com    Comissao    3    ${False}    ${True}    1
    ${pontos}=    Exibir Pontos Experiencias Candidato    tres.rep@email.com
    Should Be Equal As Numbers    ${pontos}    6.0

Calculo XP Representacao Com Ambos Bonus
    Cadastrar Candidato    Quatro Rep    quatro.rep@email.com
    Cadastrar Experiencia Representacao    quatro.rep@email.com    Presidente CA    4    ${True}    ${True}    1
    ${pontos}=    Exibir Pontos Experiencias Candidato    quatro.rep@email.com
    Should Be Equal As Numbers    ${pontos}    16.0

Representacao Representacao Contem Todas As Informacoes
    Cadastrar Candidato    Info Rep    info.rep@email.com
    Cadastrar Experiencia Representacao    info.rep@email.com    Cargo teste    5    ${True}    ${False}    10
    ${experiencias}=    Listar Experiencias Candidato    info.rep@email.com
    Should Contain    ${experiencias}[0]    Representação#1
    Should Contain    ${experiencias}[0]    Cargo teste
    Should Contain    ${experiencias}[0]    5
