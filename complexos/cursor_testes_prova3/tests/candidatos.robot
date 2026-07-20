*** Settings ***
Documentation     Testes de aceitação - cadastro e listagem de candidatos (Parte 1)
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Test Cases ***
Cadastrar Candidato Valido Retorna True
    ${resultado}=    Cadastrar Candidato    Ana Silva    ana.silva@email.com
    Should Be True    ${resultado}

Cadastrar Candidato Duplicado Retorna False
    Cadastrar Candidato    Bruno Costa    bruno.costa@email.com
    ${resultado}=    Cadastrar Candidato    Bruno Duplicado    bruno.costa@email.com
    Should Not Be True    ${resultado}

Listar Candidatos Vazio Quando Nao Ha Cadastros
    ${candidatos}=    Listar Candidatos
    Should Be Empty    ${candidatos}

Listar Candidatos Contem Nome E Email Na Representacao
    Cadastrar Candidato    Carla Mendes    carla.mendes@email.com
    ${candidatos}=    Listar Candidatos
    Length Should Be    ${candidatos}    1
    Should Contain    ${candidatos}[0]    Carla Mendes
    Should Contain    ${candidatos}[0]    carla.mendes@email.com

Listar Candidatos Retorna Todos Os Candidatos Cadastrados
    Cadastrar Candidato    Daniel Alves    daniel.alves@email.com
    Cadastrar Candidato    Elena Souza    elena.souza@email.com
    Cadastrar Candidato    Fabio Lima    fabio.lima@email.com
    ${candidatos}=    Listar Candidatos
    Length Should Be    ${candidatos}    3
    ${emails}=    Create List    daniel.alves@email.com    elena.souza@email.com    fabio.lima@email.com
    FOR    ${email}    IN    @{emails}
        ${encontrado}=    Set Variable    ${False}
        FOR    ${candidato}    IN    @{candidatos}
            ${encontrado}=    Set Variable If    '${email}' in '''${candidato}'''    ${True}    ${encontrado}
        END
        Should Be True    ${encontrado}    Candidato com email ${email} nao encontrado
    END

Emails Diferentes Permitem Cadastro De Candidatos Distintos
    ${primeiro}=    Cadastrar Candidato    Gustavo Pereira    gustavo@email.com
    Should Be True    ${primeiro}
    ${resultado}=    Cadastrar Candidato    Helena Rocha    helena@email.com
    Should Be True    ${resultado}
    ${candidatos}=    Listar Candidatos
    Length Should Be    ${candidatos}    2
