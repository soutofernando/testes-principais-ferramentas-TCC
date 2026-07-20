*** Settings ***
Documentation     Testes de aceitação - experiências de desenvolvimento (Parte 2)
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Variables ***
${EMAIL_DEV}    dev@email.com

*** Test Cases ***
Cadastrar Experiencia Desenvolvimento Adiciona Experiencia Ao Candidato
    Cadastrar Candidato    Maria Dev    ${EMAIL_DEV}
    Cadastrar Experiencia Desenvolvimento    ${EMAIL_DEV}    Sistema web    https://github.com/maria/proj    50    10
    ${experiencias}=    Listar Experiencias Candidato    ${EMAIL_DEV}
    Length Should Be    ${experiencias}    1
    Should Contain    ${experiencias}[0]    Desenvolvimento#1
    Should Contain    ${experiencias}[0]    Sistema web
    Should Contain    ${experiencias}[0]    https://github.com/maria/proj

Codigo De Experiencia Desenvolvimento E Sequencial Iniciando Em Um
    Cadastrar Candidato    Pedro Dev    pedro@email.com
    Cadastrar Experiencia Desenvolvimento    pedro@email.com    App mobile    https://github.com/pedro/app    20    5
    Cadastrar Experiencia Desenvolvimento    pedro@email.com    API REST    https://github.com/pedro/api    30    8
    ${experiencias}=    Listar Experiencias Candidato    pedro@email.com
    Length Should Be    ${experiencias}    2
    Should Contain    ${experiencias}[0]    Desenvolvimento#1
    Should Contain    ${experiencias}[1]    Desenvolvimento#2

Calculo XP Experiencia Desenvolvimento Valor Base Vez NFiles Dividido Por Dez
    Cadastrar Candidato    Lucas Calc    lucas.calc@email.com
    Cadastrar Experiencia Desenvolvimento    lucas.calc@email.com    Projeto calc    https://github.com/lucas/calc    50    10
    ${pontos}=    Exibir Pontos Experiencias Candidato    lucas.calc@email.com
    Should Be Equal As Numbers    ${pontos}    50.0

Calculo XP Desenvolvimento Com NFiles Pequeno
    Cadastrar Candidato    Julia Calc    julia.calc@email.com
    Cadastrar Experiencia Desenvolvimento    julia.calc@email.com    Mini projeto    https://github.com/julia/mini    5    20
    ${pontos}=    Exibir Pontos Experiencias Candidato    julia.calc@email.com
    Should Be Equal As Numbers    ${pontos}    10.0

Representacao Desenvolvimento Contem Todas As Informacoes
    Cadastrar Candidato    Rafael Info    rafael@email.com
    Cadastrar Experiencia Desenvolvimento    rafael@email.com    Descricao completa    https://github.com/rafael/repo    100    15
    ${experiencias}=    Listar Experiencias Candidato    rafael@email.com
    Should Contain    ${experiencias}[0]    Desenvolvimento#1
    Should Contain    ${experiencias}[0]    Descricao completa
    Should Contain    ${experiencias}[0]    https://github.com/rafael/repo
    Should Contain    ${experiencias}[0]    100
    Should Contain    ${experiencias}[0]    15

Listar Experiencias Candidato Vazio Quando Nao Ha Experiencias
    Cadastrar Candidato    Sem Exp    sem.exp@email.com
    ${experiencias}=    Listar Experiencias Candidato    sem.exp@email.com
    Should Be Empty    ${experiencias}

Exibir Pontos Experiencias Candidato Zero Sem Experiencias
    Cadastrar Candidato    Zero Exp    zero.exp@email.com
    ${pontos}=    Exibir Pontos Experiencias Candidato    zero.exp@email.com
    Should Be Equal As Numbers    ${pontos}    0.0
