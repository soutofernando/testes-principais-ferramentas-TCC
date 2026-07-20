*** Settings ***
Documentation     Testes de aceitação - acúmulo de pontos e experiências mistas (Parte 2)
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Test Cases ***
Pontos Totais Somam Experiencias De Tipos Diferentes
    Cadastrar Candidato    Mix Total    mix.total@email.com
    Cadastrar Experiencia Desenvolvimento    mix.total@email.com    Repo    https://github.com/mix/r    50    10
    Cadastrar Experiencia Representacao    mix.total@email.com    Cargo    2    ${True}    ${False}    1
    Cadastrar Experiencia Recomendacao    mix.total@email.com    Prof    Carta    2    8
    ${pontos}=    Exibir Pontos Experiencias Candidato    mix.total@email.com
    Should Be Equal As Numbers    ${pontos}    64.0

Listar Experiencias Retorna Todas Na Ordem De Cadastro
    Cadastrar Candidato    Ordem Exp    ordem.exp@email.com
    Cadastrar Experiencia Desenvolvimento    ordem.exp@email.com    Dev    https://github.com/o/d    10    5
    Cadastrar Experiencia Representacao    ordem.exp@email.com    Rep    1    ${False}    ${False}    1
    Cadastrar Experiencia Recomendacao    ordem.exp@email.com    Prof    Carta    1    3
    ${experiencias}=    Listar Experiencias Candidato    ordem.exp@email.com
    Length Should Be    ${experiencias}    3
    Should Contain    ${experiencias}[0]    Desenvolvimento#1
    Should Contain    ${experiencias}[1]    Representação#2
    Should Contain    ${experiencias}[2]    Recomendação#3

Multiplas Experiencias Do Mesmo Tipo Acumulam Pontos
    Cadastrar Candidato    Multi Dev    multi.dev@email.com
    Cadastrar Experiencia Desenvolvimento    multi.dev@email.com    Proj A    https://github.com/m/a    20    10
    Cadastrar Experiencia Desenvolvimento    multi.dev@email.com    Proj B    https://github.com/m/b    30    10
    ${pontos}=    Exibir Pontos Experiencias Candidato    multi.dev@email.com
    Should Be Equal As Numbers    ${pontos}    50.0

Pontos De Experiencia Aparecem Na Representacao Do Candidato
    Cadastrar Candidato    XP Rep    xp.rep@email.com
    Cadastrar Experiencia Recomendacao    xp.rep@email.com    Prof    Carta    2    18
    ${candidatos}=    Listar Candidatos
    Should Contain    ${candidatos}[0]    xp.rep@email.com
    Should Contain    ${candidatos}[0]    20

Experiencias Acumuladas Permitem Selecao Em Oportunidade
    Cadastrar Candidato    Selecionavel    selecionavel@email.com
    Cadastrar Experiencia Desenvolvimento    selecionavel@email.com    Grande repo    https://github.com/s/g    100    10
    Cadastrar Oportunidade    Projeto XP    1    50.0
    ${adicionado}=    Adicionar Candidato Oportunidade    selecionavel@email.com    Projeto XP
    Should Be True    ${adicionado}
    ${selecionados}=    Listar Selecionados Por Oportunidade    Projeto XP
    Length Should Be    ${selecionados}    1

Calculo XP Desenvolvimento Resultado Fracionario
    Cadastrar Candidato    Frac XP    frac.xp@email.com
    Cadastrar Experiencia Desenvolvimento    frac.xp@email.com    Repo pequeno    https://github.com/f/r    7    10
    ${pontos}=    Exibir Pontos Experiencias Candidato    frac.xp@email.com
    Should Be Equal As Numbers    ${pontos}    7.0
