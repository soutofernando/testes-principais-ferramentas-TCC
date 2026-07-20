*** Settings ***
Documentation     Testes de aceitação - cadastro e listagem de oportunidades (Parte 1)
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Test Cases ***
Cadastrar Oportunidade Valida Retorna True
    ${resultado}=    Cadastrar Oportunidade    Projeto Alpha    3    10.0
    Should Be True    ${resultado}

Cadastrar Oportunidade Duplicada Retorna False
    Cadastrar Oportunidade    Projeto Beta    2    5.0
    ${resultado}=    Cadastrar Oportunidade    Projeto Beta    5    20.0
    Should Not Be True    ${resultado}

Listar Oportunidades Vazio Quando Nao Ha Cadastros
    ${oportunidades}=    Listar Oportunidades
    Should Be Empty    ${oportunidades}

Listar Oportunidades Contem Nome Tamanho Pontos E Status Aberta
    Cadastrar Oportunidade    Projeto Gamma    4    15.5
    ${oportunidades}=    Listar Oportunidades
    Length Should Be    ${oportunidades}    1
    Should Contain    ${oportunidades}[0]    Projeto Gamma
    Should Contain    ${oportunidades}[0]    4
    Should Contain    ${oportunidades}[0]    15.5
    Should Contain    ${oportunidades}[0]    aberta

Oportunidade Aberta Exibe Mensagem Ainda Estamos Contratando
    Cadastrar Oportunidade    Projeto Delta    2    8.0
    ${oportunidades}=    Listar Oportunidades
    Should Contain    ${oportunidades}[0]    Ainda estamos contratando!

Listar Oportunidades Retorna Todas As Oportunidades Cadastradas
    Cadastrar Oportunidade    Projeto Epsilon    1    3.0
    Cadastrar Oportunidade    Projeto Zeta    3    12.0
    ${oportunidades}=    Listar Oportunidades
    Length Should Be    ${oportunidades}    2
    Should Contain    ${oportunidades}[0]    Projeto Epsilon
    Should Contain    ${oportunidades}[1]    Projeto Zeta

Nomes De Projeto Diferentes Permitem Cadastro De Oportunidades Distintas
    Should Be True    ${Cadastrar Oportunidade('Projeto Um', 1, 1.0)}
    ${resultado}=    Cadastrar Oportunidade    Projeto Dois    2    2.0
    Should Be True    ${resultado}
    ${oportunidades}=    Listar Oportunidades
    Length Should Be    ${oportunidades}    2
