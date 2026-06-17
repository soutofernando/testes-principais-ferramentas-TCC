*** Settings ***
Library    modelo.FachadaDiario
Library    String

*** Test Cases ***
Testes Do Diario

    adicionarAnotacao    Estudei Java    17/06/2026
    ${resultado}=    pesquisaAnotacao    0
    Should Be Equal    ${resultado}    Estudei Java

    adicionarAnotacao    Nao estudei para Java    29/05/2026    7.5
    ${resultado}=    pesquisaAnotacao    1
    Should Be Equal    ${resultado}    Nao estudei para Java

    adicionarAnotacao    Nao estudei para Java 2    29/05/2026    7.5
    ${resultado}=    pesquisaAnotacao    9999
    Should Be Equal    ${resultado}    INVALIDO
    
    ${resultado}=    listarAnotacoes
    ${normalizado}=    Replace String    ${resultado}    \r\n    ${SPACE}
    ${normalizado}=    Replace String    ${normalizado}    \n    ${SPACE}
    ${normalizado}=    Strip String    ${normalizado}
    Should Be Equal    ${normalizado}    Teste/2026 Data: 17/06/2026 Texto: Estudei Java Data: 29/05/2026 Texto: Nao estudei para Java Data: 29/05/2026 Texto: Nao estudei para Java 2

    adicionarAnotacao    A    10/10/2010    6
    ${resultado}=    meuDesempenho
    Should Be Equal As Numbers    ${resultado}    5.25

    adicionarAnotacao    A    10/10/2010
    ${resultado}=    meuDesempenho
    Should Be Equal As Numbers    ${resultado}    4.2
    
    ${resultado}=    statusCompreensao    1
    Should Be Equal    ${resultado}    MUITO BOM

    ${resultado}=    statusCompreensao    2
    Should Be Equal    ${resultado}    MUITO BOM

    ${resultado}=    statusCompreensao    0
    Should Be Equal    ${resultado}    ATENCAO!
