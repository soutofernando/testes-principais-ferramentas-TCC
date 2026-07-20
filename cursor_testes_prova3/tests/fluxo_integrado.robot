*** Settings ***
Documentation     Testes de aceitação - fluxo integrado completo do sistema
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Test Cases ***
Fluxo Completo Cadastro Experiencias E Selecao
    ${c1}=    Cadastrar Candidato    Integracao Um    int1@email.com
    Should Be True    ${c1}
    ${c2}=    Cadastrar Candidato    Integracao Dois    int2@email.com
    Should Be True    ${c2}
    ${op}=    Cadastrar Oportunidade    Projeto Integracao    2    25.0
    Should Be True    ${op}
    Cadastrar Experiencia Desenvolvimento    int1@email.com    Sistema LP2    https://github.com/int1/lp2    80    10
    Cadastrar Experiencia Representacao    int2@email.com    Monitoria    3    ${True}    ${True}    1
    Cadastrar Experiencia Recomendacao    int2@email.com    Prof LP2    Carta integracao    3    5
    ${pontos1}=    Exibir Pontos Experiencias Candidato    int1@email.com
    Should Be Equal As Numbers    ${pontos1}    80.0
    ${pontos2}=    Exibir Pontos Experiencias Candidato    int2@email.com
    Should Be Equal As Numbers    ${pontos2}    20.0
    ${add1}=    Adicionar Candidato Oportunidade    int1@email.com    Projeto Integracao
    Should Be True    ${add1}
    ${add2}=    Adicionar Candidato Oportunidade    int2@email.com    Projeto Integracao
    Should Not Be True    ${add2}
    ${oportunidades}=    Listar Oportunidades
    Should Contain    ${oportunidades}[0]    aberta
    Should Contain    ${oportunidades}[0]    Ainda estamos contratando!
    ${selecionados}=    Listar Selecionados Por Oportunidade    Projeto Integracao
    Length Should Be    ${selecionados}    1
    Should Contain    ${selecionados}[0]    int1@email.com

Cadastro Duplicado Nao Altera Estado Do Sistema
    ${c1}=    Cadastrar Candidato    Unico    unico@email.com
    Should Be True    ${c1}
    ${c2}=    Cadastrar Candidato    Outro Nome    unico@email.com
    Should Not Be True    ${c2}
    ${o1}=    Cadastrar Oportunidade    Projeto Unico    1    1.0
    Should Be True    ${o1}
    ${o2}=    Cadastrar Oportunidade    Projeto Unico    3    5.0
    Should Not Be True    ${o2}
    ${candidatos}=    Listar Candidatos
    Length Should Be    ${candidatos}    1
    Should Contain    ${candidatos}[0]    Unico
    ${oportunidades}=    Listar Oportunidades
    Length Should Be    ${oportunidades}    1
    Should Contain    ${oportunidades}[0]    Projeto Unico
    Should Contain    ${oportunidades}[0]    1

Selecao Respeita Limite De Vagas E Pontos Simultaneamente
    Cadastrar Candidato    Apto Um    apto1@email.com
    Cadastrar Candidato    Apto Dois    apto2@email.com
    Cadastrar Candidato    Inapto    inapto@email.com
    Cadastrar Experiencia Recomendacao    apto1@email.com    Prof    Carta    3    17
    Cadastrar Experiencia Recomendacao    apto2@email.com    Prof    Carta    3    17
    Cadastrar Experiencia Recomendacao    inapto@email.com    Prof    Carta    1    4
    Cadastrar Oportunidade    Projeto Dupla    2    20.0
    ${add1}=    Adicionar Candidato Oportunidade    apto1@email.com    Projeto Dupla
    Should Be True    ${add1}
    ${add2}=    Adicionar Candidato Oportunidade    apto2@email.com    Projeto Dupla
    Should Be True    ${add2}
    ${add3}=    Adicionar Candidato Oportunidade    inapto@email.com    Projeto Dupla
    Should Not Be True    ${add3}
    ${selecionados}=    Listar Selecionados Por Oportunidade    Projeto Dupla
    Length Should Be    ${selecionados}    2
