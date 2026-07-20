*** Settings ***
Documentation    Testes de aceitacao do sistema Diario de Estudos via FachadaDiario.
Library          BuiltIn
Library          Collections
Library          String
Library          modelo.FachadaDiario    scope=TEST    WITH NAME    App

*** Variables ***
${TEXTO_JAVA}                   Estudei Java
${DATA_JAVA}                    17/06/2026
${TEXTO_NAO_ESTUDEI}            Nao estudei para Java
${TEXTO_NAO_ESTUDEI_2}          Nao estudei para Java 2
${DATA_MAIO}                    29/05/2026
${AVALIACAO_7_5}                7.5
${TEXTO_A}                      A
${DATA_OUTUBRO}                 10/10/2010
${AVALIACAO_6}                  6
${LISTAGEM_VAZIA}               Teste/2026
${TOLERANCIA_MEDIA}             0.01

*** Keywords ***
Criar Fachada Limpa
    [Documentation]    Prepara estado limpo; a instancia da facade e recriada via scope=TEST.
    No Operation

Adicionar Anotacao
    [Arguments]    ${texto}    ${data}
    ${resultado}=    App.Adicionar Anotacao    ${texto}    ${data}
    [Return]    ${resultado}

Adicionar Anotacao Com Avaliacao
    [Arguments]    ${texto}    ${data}    ${avaliacao}
    ${resultado}=    App.Adicionar Anotacao    ${texto}    ${data}    ${avaliacao}
    [Return]    ${resultado}

Pesquisa Anotacao
    [Arguments]    ${index}
    ${resultado}=    App.Pesquisa Anotacao    ${index}
    [Return]    ${resultado}

Listar Anotacoes
    ${resultado}=    App.Listar Anotacoes
    [Return]    ${resultado}

Meu Desempenho
    ${resultado}=    App.Meu Desempenho
    [Return]    ${resultado}

Status Compreensao
    [Arguments]    ${index}
    ${resultado}=    App.Status Compreensao    ${index}
    [Return]    ${resultado}

Normalizar Listagem
    [Arguments]    ${texto}
    ${normalizado}=    Replace String    ${texto}    \r\n    ${SPACE}
    ${normalizado}=    Replace String    ${normalizado}    \n    ${SPACE}
    [Return]    ${normalizado}

Desempenho Deve Ser Aproximadamente
    [Arguments]    ${esperado}
    ${media}=    Meu Desempenho
    ${diferenca}=    Evaluate    abs(${media} - ${esperado})
    Should Be True    ${diferenca} <= ${TOLERANCIA_MEDIA}

Preparar Tres Anotacoes Basicas
    [Documentation]    Cadastra as tres primeiras anotacoes do fluxo de referencia da especificacao.
    Adicionar Anotacao    ${TEXTO_JAVA}    ${DATA_JAVA}
    Adicionar Anotacao Com Avaliacao    ${TEXTO_NAO_ESTUDEI}    ${DATA_MAIO}    ${AVALIACAO_7_5}
    Adicionar Anotacao Com Avaliacao    ${TEXTO_NAO_ESTUDEI_2}    ${DATA_MAIO}    ${AVALIACAO_7_5}

*** Test Cases ***
Diario Inicial Deve Estar Vazio
    [Documentation]    Facade padrao (dono Teste, ano 2026) sem anotacoes: media 0 e listagem apenas com cabecalho.
    [Setup]    Criar Fachada Limpa
    Desempenho Deve Ser Aproximadamente    0
    ${listagem}=    Listar Anotacoes
    Should Be Equal    ${listagem}    ${LISTAGEM_VAZIA}

Adicionar Anotacao Sem Avaliacao Deve Retornar True
    [Documentation]    Caminho feliz do overload texto+data; avaliacao implicita 0.
    [Setup]    Criar Fachada Limpa
    ${ok}=    Adicionar Anotacao    ${TEXTO_JAVA}    ${DATA_JAVA}
    Should Be True    ${ok}
    ${texto}=    Pesquisa Anotacao    0
    Should Be Equal    ${texto}    ${TEXTO_JAVA}
    Desempenho Deve Ser Aproximadamente    0

Adicionar Anotacao Com Avaliacao Deve Retornar True
    [Documentation]    Caminho feliz do overload com autoavaliacao.
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao    ${TEXTO_JAVA}    ${DATA_JAVA}
    ${ok}=    Adicionar Anotacao Com Avaliacao    ${TEXTO_NAO_ESTUDEI}    ${DATA_MAIO}    ${AVALIACAO_7_5}
    Should Be True    ${ok}
    ${texto}=    Pesquisa Anotacao    1
    Should Be Equal    ${texto}    ${TEXTO_NAO_ESTUDEI}
    Desempenho Deve Ser Aproximadamente    3.75

Terceira Anotacao Deve Atualizar Media Para Cinco
    [Documentation]    Media aritmetica apos tres anotacoes: 0, 7.5 e 7.5 resultam em 5.0.
    [Setup]    Criar Fachada Limpa
    Preparar Tres Anotacoes Basicas
    ${texto}=    Pesquisa Anotacao    2
    Should Be Equal    ${texto}    ${TEXTO_NAO_ESTUDEI_2}
    Desempenho Deve Ser Aproximadamente    5

Pesquisa Anotacao Com Indice Muito Alto Deve Retornar INVALIDO
    [Documentation]    Indice fora dos limites retorna INVALIDO.
    [Setup]    Criar Fachada Limpa
    Preparar Tres Anotacoes Basicas
    ${resultado}=    Pesquisa Anotacao    9999
    Should Be Equal    ${resultado}    INVALIDO

Pesquisa Anotacao Com Indice Igual Ao Tamanho Deve Retornar INVALIDO
    [Documentation]    Indice 3 com tres anotacoes (indices 0, 1 e 2) retorna INVALIDO.
    [Setup]    Criar Fachada Limpa
    Preparar Tres Anotacoes Basicas
    ${resultado}=    Pesquisa Anotacao    3
    Should Be Equal    ${resultado}    INVALIDO

Listar Anotacoes Deve Seguir Formato Data E Texto
    [Documentation]    Listagem no formato dono/ano seguido de Data e Texto de cada anotacao.
    [Setup]    Criar Fachada Limpa
    Preparar Tres Anotacoes Basicas
    ${listagem}=    Listar Anotacoes
    ${normalizado}=    Normalizar Listagem    ${listagem}
    Should Be Equal    ${normalizado}    Teste/2026 Data: 17/06/2026 Texto: Estudei Java Data: 29/05/2026 Texto: Nao estudei para Java Data: 29/05/2026 Texto: Nao estudei para Java 2

Media Deve Considerar Anotacao Com Avaliacao Seis
    [Documentation]    Quarta anotacao com avaliacao 6 eleva media para 5.25.
    [Setup]    Criar Fachada Limpa
    Preparar Tres Anotacoes Basicas
    Adicionar Anotacao Com Avaliacao    ${TEXTO_A}    ${DATA_OUTUBRO}    ${AVALIACAO_6}
    Desempenho Deve Ser Aproximadamente    5.25

Media Deve Considerar Anotacao Sem Avaliacao Como Zero
    [Documentation]    Quinta anotacao sem autoavaliacao reduz media para 4.2.
    [Setup]    Criar Fachada Limpa
    Preparar Tres Anotacoes Basicas
    Adicionar Anotacao Com Avaliacao    ${TEXTO_A}    ${DATA_OUTUBRO}    ${AVALIACAO_6}
    Adicionar Anotacao    ${TEXTO_A}    ${DATA_OUTUBRO}
    Desempenho Deve Ser Aproximadamente    4.2

Status Compreensao Sem Avaliacao Deve Ser ATENCAO
    [Documentation]    Autoavaliacao 0 ou ausente retorna ATENCAO!
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao    ${TEXTO_JAVA}    ${DATA_JAVA}
    ${status}=    Status Compreensao    0
    Should Be Equal    ${status}    ATENCAO!

Status Compreensao Avaliacao Sete E Meio Deve Ser MUITO BOM
    [Documentation]    Faixa (7, 9) retorna MUITO BOM.
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao Com Avaliacao    ${TEXTO_NAO_ESTUDEI}    ${DATA_MAIO}    ${AVALIACAO_7_5}
    ${status}=    Status Compreensao    0
    Should Be Equal    ${status}    MUITO BOM

Status Compreensao Avaliacao Seis Deve Ser BOM
    [Documentation]    Faixa (5, 7] retorna BOM.
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao Com Avaliacao    ${TEXTO_A}    ${DATA_OUTUBRO}    ${AVALIACAO_6}
    ${status}=    Status Compreensao    0
    Should Be Equal    ${status}    BOM

Status Compreensao Limite Regular Cinco Deve Ser REGULAR
    [Documentation]    Valor exatamente 5 pertence a faixa (0, 5].
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao Com Avaliacao    Limite regular    01/01/2026    5
    ${status}=    Status Compreensao    0
    Should Be Equal    ${status}    REGULAR

Status Compreensao Limite Bom Inferior Cinco Virgula Zero Um Deve Ser BOM
    [Documentation]    Valor 5.01 pertence a faixa (5, 7].
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao Com Avaliacao    Limite bom inferior    02/01/2026    5.01
    ${status}=    Status Compreensao    0
    Should Be Equal    ${status}    BOM

Status Compreensao Limite Bom Superior Sete Deve Ser BOM
    [Documentation]    Valor exatamente 7 pertence a faixa (5, 7].
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao Com Avaliacao    Limite bom superior    03/01/2026    7
    ${status}=    Status Compreensao    0
    Should Be Equal    ${status}    BOM

Status Compreensao Limite Muito Bom Oito Virgula Noventa E Nove Deve Ser MUITO BOM
    [Documentation]    Valor 8.99 pertence a faixa (7, 9).
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao Com Avaliacao    Limite muito bom    04/01/2026    8.99
    ${status}=    Status Compreensao    0
    Should Be Equal    ${status}    MUITO BOM

Status Compreensao Limite Excelente Inferior Nove Deve Ser EXCELENTE
    [Documentation]    Valor 9 pertence a faixa [9, 10].
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao Com Avaliacao    Limite excelente inferior    05/01/2026    9
    ${status}=    Status Compreensao    0
    Should Be Equal    ${status}    EXCELENTE

Status Compreensao Limite Excelente Superior Dez Deve Ser EXCELENTE
    [Documentation]    Valor 10 pertence a faixa [9, 10].
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao Com Avaliacao    Limite excelente superior    06/01/2026    10
    ${status}=    Status Compreensao    0
    Should Be Equal    ${status}    EXCELENTE

Fluxo Integrado Deve Consolidar Pesquisa Listagem E Media
    [Documentation]    Fluxo composto: cadastro, consultas, faixas de status e validacao final consolidada.
    [Setup]    Criar Fachada Limpa
    Adicionar Anotacao    ${TEXTO_JAVA}    ${DATA_JAVA}
    Adicionar Anotacao Com Avaliacao    ${TEXTO_NAO_ESTUDEI}    ${DATA_MAIO}    ${AVALIACAO_7_5}
    Adicionar Anotacao Com Avaliacao    ${TEXTO_NAO_ESTUDEI_2}    ${DATA_MAIO}    ${AVALIACAO_7_5}
    ${texto0}=    Pesquisa Anotacao    0
    ${texto1}=    Pesquisa Anotacao    1
    ${texto2}=    Pesquisa Anotacao    2
    Should Be Equal    ${texto0}    ${TEXTO_JAVA}
    Should Be Equal    ${texto1}    ${TEXTO_NAO_ESTUDEI}
    Should Be Equal    ${texto2}    ${TEXTO_NAO_ESTUDEI_2}
    ${invalido_alto}=    Pesquisa Anotacao    9999
    ${invalido_tamanho}=    Pesquisa Anotacao    3
    Should Be Equal    ${invalido_alto}    INVALIDO
    Should Be Equal    ${invalido_tamanho}    INVALIDO
    Adicionar Anotacao Com Avaliacao    ${TEXTO_A}    ${DATA_OUTUBRO}    ${AVALIACAO_6}
    Adicionar Anotacao    ${TEXTO_A}    ${DATA_OUTUBRO}
    ${status0}=    Status Compreensao    0
    ${status1}=    Status Compreensao    1
    ${status2}=    Status Compreensao    2
    ${status3}=    Status Compreensao    3
    ${status4}=    Status Compreensao    4
    Should Be Equal    ${status0}    ATENCAO!
    Should Be Equal    ${status1}    MUITO BOM
    Should Be Equal    ${status2}    MUITO BOM
    Should Be Equal    ${status3}    BOM
    Should Be Equal    ${status4}    ATENCAO!
    Adicionar Anotacao Com Avaliacao    Limite regular    01/01/2026    5
    Adicionar Anotacao Com Avaliacao    Limite bom inferior    02/01/2026    5.01
    Adicionar Anotacao Com Avaliacao    Limite bom superior    03/01/2026    7
    Adicionar Anotacao Com Avaliacao    Limite muito bom    04/01/2026    8.99
    Adicionar Anotacao Com Avaliacao    Limite excelente inferior    05/01/2026    9
    Adicionar Anotacao Com Avaliacao    Limite excelente superior    06/01/2026    10
    ${status5}=    Status Compreensao    5
    ${status6}=    Status Compreensao    6
    ${status7}=    Status Compreensao    7
    ${status8}=    Status Compreensao    8
    ${status9}=    Status Compreensao    9
    ${status10}=    Status Compreensao    10
    Should Be Equal    ${status5}    REGULAR
    Should Be Equal    ${status6}    BOM
    Should Be Equal    ${status7}    BOM
    Should Be Equal    ${status8}    MUITO BOM
    Should Be Equal    ${status9}    EXCELENTE
    Should Be Equal    ${status10}    EXCELENTE
    ${texto_final}=    Pesquisa Anotacao    10
    Should Be Equal    ${texto_final}    Limite excelente superior
    ${invalido_final}=    Pesquisa Anotacao    11
    Should Be Equal    ${invalido_final}    INVALIDO
    ${listagem}=    Listar Anotacoes
    ${normalizado}=    Normalizar Listagem    ${listagem}
    Should Be Equal    ${normalizado}    Teste/2026 Data: 17/06/2026 Texto: Estudei Java Data: 29/05/2026 Texto: Nao estudei para Java Data: 29/05/2026 Texto: Nao estudei para Java 2 Data: 10/10/2010 Texto: A Data: 10/10/2010 Texto: A Data: 01/01/2026 Texto: Limite regular Data: 02/01/2026 Texto: Limite bom inferior Data: 03/01/2026 Texto: Limite bom superior Data: 04/01/2026 Texto: Limite muito bom Data: 05/01/2026 Texto: Limite excelente inferior Data: 06/01/2026 Texto: Limite excelente superior
    Desempenho Deve Ser Aproximadamente    6
