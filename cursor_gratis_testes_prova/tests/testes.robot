*** Settings ***
Documentation    Testes de aceitacao do sistema RecruitMe via RecruitMeFacade.
Library          BuiltIn
Library          Collections
Library          String
Library          prova2_guilherme_fernandes.RecruitMeFacade    scope=TEST    WITH NAME    App

*** Variables ***
${NOME_ANA}              Ana Silva
${EMAIL_ANA}             ana.silva@universidade.edu
${NOME_BRUNO}            Bruno Costa
${EMAIL_BRUNO}           bruno.costa@universidade.edu
${NOME_CARLA}            Carla Mendes
${EMAIL_CARLA}           carla.mendes@universidade.edu
${NOME_DANIEL}           Daniel Alves
${EMAIL_DANIEL}          daniel.alves@universidade.edu
${PROJETO_ERP}           Sistema ERP
${PROJETO_MOBILE}        App Mobile
${PROJETO_IA}            Plataforma IA
${MSG_CONTRATANDO}       Ainda estamos contratando!
${STATUS_ABERTA}         aberta
${STATUS_FECHADA}        fechada

*** Keywords ***
Criar Fachada Limpa
    No Operation

Cadastrar Candidato
    [Arguments]    ${nome}    ${email}
    ${resultado}=    App.Cadastrar Candidato    ${nome}    ${email}
    [Return]    ${resultado}

Listar Candidatos
    ${resultado}=    App.Listar Candidatos
    [Return]    ${resultado}

Cadastrar Oportunidade
    [Arguments]    ${nome_projeto}    ${tam}    ${pontos}
    ${resultado}=    App.Cadastrar Oportunidade    ${nome_projeto}    ${tam}    ${pontos}
    [Return]    ${resultado}

Listar Oportunidades
    ${resultado}=    App.Listar Oportunidades
    [Return]    ${resultado}

Adicionar Candidato Oportunidade
    [Arguments]    ${email}    ${nome_projeto}
    ${resultado}=    App.Adicionar Candidato Oportunidade    ${email}    ${nome_projeto}
    [Return]    ${resultado}

Listar Selecionados Por Oportunidade
    [Arguments]    ${nome_projeto}
    ${resultado}=    App.Listar Selecionados Por Oportunidade    ${nome_projeto}
    [Return]    ${resultado}

Cadastrar Experiencia Desenvolvimento
    [Arguments]    ${email}    ${descricao}    ${URL}    ${n_files}    ${valor_base}
    App.Cadastrar Experiencia Desenvolvimento    ${email}    ${descricao}    ${URL}    ${n_files}    ${valor_base}

Cadastrar Experiencia Representacao
    [Arguments]    ${email}    ${cargo}    ${semestres}    ${eleito}    ${institucional}    ${valor_base}
    App.Cadastrar Experiencia Representacao    ${email}    ${cargo}    ${semestres}    ${eleito}    ${institucional}    ${valor_base}

Cadastrar Experiencia Recomendacao
    [Arguments]    ${email}    ${prof}    ${carta}    ${aval}    ${valor_base}
    App.Cadastrar Experiencia Recomendacao    ${email}    ${prof}    ${carta}    ${aval}    ${valor_base}

Listar Experiencias Candidato
    [Arguments]    ${email}
    ${resultado}=    App.Listar Experiencias Candidato    ${email}
    [Return]    ${resultado}

Exibir Pontos Experiencias Candidato
    [Arguments]    ${email}
    ${resultado}=    App.Exibir Pontos Experiencias Candidato    ${email}
    [Return]    ${resultado}

Cadastrar Candidato Com Sucesso
    [Arguments]    ${nome}    ${email}
    ${resultado}=    Cadastrar Candidato    ${nome}    ${email}
    Should Be True    ${resultado}

Cadastrar Oportunidade Com Sucesso
    [Arguments]    ${nome_projeto}    ${tam}    ${pontos}
    ${resultado}=    Cadastrar Oportunidade    ${nome_projeto}    ${tam}    ${pontos}
    Should Be True    ${resultado}

Adicionar Candidato Oportunidade Com Sucesso
    [Arguments]    ${email}    ${nome_projeto}
    ${resultado}=    Adicionar Candidato Oportunidade    ${email}    ${nome_projeto}
    Should Be True    ${resultado}

Adicionar Candidato Oportunidade Deve Falhar
    [Arguments]    ${email}    ${nome_projeto}
    ${resultado}=    Adicionar Candidato Oportunidade    ${email}    ${nome_projeto}
    Should Not Be True    ${resultado}

Preparar Candidato Ana Com Desenvolvimento
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Cadastrar Experiencia Desenvolvimento    ${EMAIL_ANA}    Sistema de vendas    https://github.com/ana/vendas    30    10

Preparar Candidato Bruno Com Representacao Eleito Institucional
    Cadastrar Candidato Com Sucesso    ${NOME_BRUNO}    ${EMAIL_BRUNO}
    Cadastrar Experiencia Representacao    ${EMAIL_BRUNO}    Representante CAESI    4    ${True}    ${True}    0

Preparar Candidato Carla Com Recomendacao
    Cadastrar Candidato Com Sucesso    ${NOME_CARLA}    ${EMAIL_CARLA}
    Cadastrar Experiencia Recomendacao    ${EMAIL_CARLA}    Prof. Oliveira    Excelente desempenho    3    10

Candidato Deve Aparecer Na Listagem
    [Arguments]    ${nome}    ${email}
    ${candidatos}=    Listar Candidatos
    ${encontrado}=    Set Variable    ${False}
    FOR    ${candidato}    IN    @{candidatos}
        ${contem_nome}=    Evaluate    """${nome}""" in """${candidato}"""
        ${contem_email}=    Evaluate    """${email}""" in """${candidato}"""
        ${encontrado}=    Set Variable If    ${contem_nome} and ${contem_email}    ${True}    ${encontrado}
    END
    Should Be True    ${encontrado}

Oportunidade Deve Conter Status
    [Arguments]    ${nome_projeto}    ${status}
    ${oportunidades}=    Listar Oportunidades
    ${encontrado}=    Set Variable    ${False}
    FOR    ${oportunidade}    IN    @{oportunidades}
        ${contem_projeto}=    Evaluate    """${nome_projeto}""" in """${oportunidade}"""
        ${contem_status}=    Evaluate    """${status}""" in """${oportunidade}"""
        ${encontrado}=    Set Variable If    ${contem_projeto} and ${contem_status}    ${True}    ${encontrado}
    END
    Should Be True    ${encontrado}

*** Test Cases ***
Cadastrar Candidato Valido Deve Retornar Verdadeiro
    [Documentation]    Candidato com nome e email validos deve ser cadastrado com sucesso.
    [Setup]    Criar Fachada Limpa
    ${resultado}=    Cadastrar Candidato    ${NOME_ANA}    ${EMAIL_ANA}
    Should Be True    ${resultado}

Cadastrar Candidato Com Email Duplicado Deve Retornar Falso
    [Documentation]    Nao podem ser cadastrados candidatos com o mesmo email.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    ${resultado}=    Cadastrar Candidato    ${NOME_BRUNO}    ${EMAIL_ANA}
    Should Not Be True    ${resultado}

Listar Candidatos Deve Exibir Nome E Email Na Representacao
    [Documentation]    Nome e email devem aparecer na representacao textual do candidato.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Candidato Deve Aparecer Na Listagem    ${NOME_ANA}    ${EMAIL_ANA}

Listar Candidatos Sem Cadastros Deve Retornar Lista Vazia
    [Documentation]    Sem candidatos cadastrados a listagem deve estar vazia.
    [Setup]    Criar Fachada Limpa
    ${candidatos}=    Listar Candidatos
    Length Should Be    ${candidatos}    0

Cadastrar Oportunidade Valida Deve Retornar Verdadeiro
    [Documentation]    Oportunidade identificada pelo nome do projeto deve ser cadastrada com sucesso.
    [Setup]    Criar Fachada Limpa
    ${resultado}=    Cadastrar Oportunidade    ${PROJETO_ERP}    2    10.0
    Should Be True    ${resultado}

Cadastrar Oportunidade Com Nome Duplicado Deve Retornar Falso
    [Documentation]    Oportunidades sao identificadas unicamente pelo nome do projeto.
    [Setup]    Criar Fachada Limpa
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    2    10.0
    ${resultado}=    Cadastrar Oportunidade    ${PROJETO_ERP}    3    20.0
    Should Not Be True    ${resultado}

Oportunidade Nova Deve Iniciar Com Status Aberta
    [Documentation]    As oportunidades iniciam com o status aberta.
    [Setup]    Criar Fachada Limpa
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    2    10.0
    Oportunidade Deve Conter Status    ${PROJETO_ERP}    ${STATUS_ABERTA}

Listar Oportunidades Deve Exibir Nome Projeto Tam E Pontos
    [Documentation]    Oportunidade deve sinalizar nome do projeto, quantidade de pessoas e pontos minimos.
    [Setup]    Criar Fachada Limpa
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_MOBILE}    1    25.0
    ${oportunidades}=    Listar Oportunidades
    Length Should Be    ${oportunidades}    1
    Should Contain    ${oportunidades}[0]    ${PROJETO_MOBILE}
    Should Contain    ${oportunidades}[0]    1
    ${contem_pontos}=    Evaluate    "25" in """${oportunidades}[0]""" or "25.0" in """${oportunidades}[0]"""
    Should Be True    ${contem_pontos}

Oportunidade Aberta Incompleta Deve Informar Ainda Estamos Contratando
    [Documentation]    Selecao aberta e incompleta deve informar Ainda estamos contratando!
    [Setup]    Criar Fachada Limpa
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    2    0.0
    ${oportunidades}=    Listar Oportunidades
    Should Contain    ${oportunidades}[0]    ${MSG_CONTRATANDO}

Adicionar Candidato Com Pontos Suficientes Deve Retornar Verdadeiro
    [Documentation]    Candidato com pontos iguais ou superiores ao requerido pode ser selecionado.
    [Setup]    Criar Fachada Limpa
    Preparar Candidato Ana Com Desenvolvimento
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    2    30.0
    Adicionar Candidato Oportunidade Com Sucesso    ${EMAIL_ANA}    ${PROJETO_ERP}
    ${selecionados}=    Listar Selecionados Por Oportunidade    ${PROJETO_ERP}
    Length Should Be    ${selecionados}    1
    Should Contain    ${selecionados}[0]    ${NOME_ANA}

Adicionar Candidato Com Pontos Exatamente No Minimo Deve Retornar Verdadeiro
    [Documentation]    Pontos de experiencia iguais ao minimo requerido atendem o criterio de selecao.
    [Setup]    Criar Fachada Limpa
    Preparar Candidato Ana Com Desenvolvimento
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    1    30.0
    Adicionar Candidato Oportunidade Com Sucesso    ${EMAIL_ANA}    ${PROJETO_ERP}

Adicionar Candidato Com Pontos Insuficientes Deve Retornar Falso
    [Documentation]    Candidato com pontos inferiores ao requerido nao pode ser selecionado.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    2    50.0
    Adicionar Candidato Oportunidade Deve Falhar    ${EMAIL_ANA}    ${PROJETO_ERP}

Adicionar Candidato A Oportunidade Fechada Deve Retornar Falso
    [Documentation]    Nao se pode adicionar candidatos a oportunidade fechada.
    [Setup]    Criar Fachada Limpa
    Preparar Candidato Ana Com Desenvolvimento
    Preparar Candidato Bruno Com Representacao Eleito Institucional
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_IA}    1    10.0
    Adicionar Candidato Oportunidade Com Sucesso    ${EMAIL_ANA}    ${PROJETO_IA}
    Oportunidade Deve Conter Status    ${PROJETO_IA}    ${STATUS_FECHADA}
    Adicionar Candidato Oportunidade Deve Falhar    ${EMAIL_BRUNO}    ${PROJETO_IA}

Oportunidade Deve Fechar Ao Atingir Quantidade Esperada De Selecionados
    [Documentation]    Quando atinge a quantidade esperada de pessoas o status muda para fechada.
    [Setup]    Criar Fachada Limpa
    Preparar Candidato Ana Com Desenvolvimento
    Preparar Candidato Bruno Com Representacao Eleito Institucional
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    2    10.0
    Adicionar Candidato Oportunidade Com Sucesso    ${EMAIL_ANA}    ${PROJETO_ERP}
    Adicionar Candidato Oportunidade Com Sucesso    ${EMAIL_BRUNO}    ${PROJETO_ERP}
    Oportunidade Deve Conter Status    ${PROJETO_ERP}    ${STATUS_FECHADA}
    ${oportunidades}=    Listar Oportunidades
    Should Not Contain    ${oportunidades}[0]    ${MSG_CONTRATANDO}

Adicionar Candidato Inexistente A Oportunidade Deve Lancar Excecao
    [Documentation]    Operacao com candidato inexistente deve lancar IllegalArgumentException.
    [Setup]    Criar Fachada Limpa
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    1    0.0
    Run Keyword And Expect Error    *IllegalArgumentException*    App.Adicionar Candidato Oportunidade    inexistente@email.com    ${PROJETO_ERP}

Adicionar Candidato A Oportunidade Inexistente Deve Lancar Excecao
    [Documentation]    Operacao com oportunidade inexistente deve lancar IllegalArgumentException.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Run Keyword And Expect Error    *IllegalArgumentException*    App.Adicionar Candidato Oportunidade    ${EMAIL_ANA}    Projeto Inexistente

Cadastrar Experiencia Desenvolvimento Deve Calcular XP Valor Base Vezes NFiles Dividido Dez
    [Documentation]    XP de desenvolvimento = valor_base * nFiles/10.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Cadastrar Experiencia Desenvolvimento    ${EMAIL_ANA}    API REST    https://github.com/ana/api    30    10
    ${pontos}=    Exibir Pontos Experiencias Candidato    ${EMAIL_ANA}
    Should Be Equal As Numbers    ${pontos}    30

Cadastrar Experiencia Desenvolvimento Com Divisao Inteira De NFiles
    [Documentation]    Divisao nFiles/10 usa divisao inteira no calculo de XP de desenvolvimento.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Cadastrar Experiencia Desenvolvimento    ${EMAIL_ANA}    Modulo parcial    https://github.com/ana/mod    15    10
    ${pontos}=    Exibir Pontos Experiencias Candidato    ${EMAIL_ANA}
    Should Be Equal As Numbers    ${pontos}    10

Experiencia Desenvolvimento Deve Ter Representacao Desenvolvimento Com Codigo E Informacoes
    [Documentation]    Representacao textual: Desenvolvimento#codigo com todas as informacoes.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Cadastrar Experiencia Desenvolvimento    ${EMAIL_ANA}    Portal web    https://github.com/ana/portal    20    5
    ${experiencias}=    Listar Experiencias Candidato    ${EMAIL_ANA}
    Length Should Be    ${experiencias}    1
    Should Contain    ${experiencias}[0]    Desenvolvimento#1
    Should Contain    ${experiencias}[0]    Portal web
    Should Contain    ${experiencias}[0]    https://github.com/ana/portal

Cadastrar Experiencia Representacao Com Ambos Bonus Deve Calcular XP
    [Documentation]    XP representacao = semestres * bonus1 * bonus2 com bonus 2 quando eleito e institucional.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_BRUNO}    ${EMAIL_BRUNO}
    Cadastrar Experiencia Representacao    ${EMAIL_BRUNO}    Representante CAESI    4    ${True}    ${True}    0
    ${pontos}=    Exibir Pontos Experiencias Candidato    ${EMAIL_BRUNO}
    Should Be Equal As Numbers    ${pontos}    16

Cadastrar Experiencia Representacao Sem Bonus Deve Calcular XP
    [Documentation]    Sem eleito nem institucional os bonus valem 1 no calculo de XP.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_BRUNO}    ${EMAIL_BRUNO}
    Cadastrar Experiencia Representacao    ${EMAIL_BRUNO}    Membro comissao    5    ${False}    ${False}    0
    ${pontos}=    Exibir Pontos Experiencias Candidato    ${EMAIL_BRUNO}
    Should Be Equal As Numbers    ${pontos}    5

Cadastrar Experiencia Representacao Com Bonus Eleito Deve Calcular XP
    [Documentation]    Bonus1 = 2 quando eleito e verdadeiro no calculo de XP de representacao.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_BRUNO}    ${EMAIL_BRUNO}
    Cadastrar Experiencia Representacao    ${EMAIL_BRUNO}    Diretor colegiado    3    ${True}    ${False}    0
    ${pontos}=    Exibir Pontos Experiencias Candidato    ${EMAIL_BRUNO}
    Should Be Equal As Numbers    ${pontos}    6

Cadastrar Experiencia Representacao Com Bonus Institucional Deve Calcular XP
    [Documentation]    Bonus2 = 2 quando institucional e verdadeiro no calculo de XP de representacao.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_BRUNO}    ${EMAIL_BRUNO}
    Cadastrar Experiencia Representacao    ${EMAIL_BRUNO}    Conselho CAESI    2    ${False}    ${True}    0
    ${pontos}=    Exibir Pontos Experiencias Candidato    ${EMAIL_BRUNO}
    Should Be Equal As Numbers    ${pontos}    4

Experiencia Representacao Deve Ter Representacao Representacao Com Codigo E Informacoes
    [Documentation]    Representacao textual: Representacao#codigo com todas as informacoes.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_BRUNO}    ${EMAIL_BRUNO}
    Cadastrar Experiencia Representacao    ${EMAIL_BRUNO}    Vice CAESI    3    ${True}    ${False}    0
    ${experiencias}=    Listar Experiencias Candidato    ${EMAIL_BRUNO}
    Length Should Be    ${experiencias}    1
    Should Contain    ${experiencias}[0]    Representação#1
    Should Contain    ${experiencias}[0]    Vice CAESI

Cadastrar Experiencia Recomendacao Deve Calcular XP Aval Mais Valor Base
    [Documentation]    XP de recomendacao = aval + valor_base.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_CARLA}    ${EMAIL_CARLA}
    Cadastrar Experiencia Recomendacao    ${EMAIL_CARLA}    Prof. Souza    Carta de merito    3    10
    ${pontos}=    Exibir Pontos Experiencias Candidato    ${EMAIL_CARLA}
    Should Be Equal As Numbers    ${pontos}    13

Experiencia Recomendacao Deve Ter Representacao Recomendacao Com Codigo E Informacoes
    [Documentation]    Representacao textual: Recomendacao#codigo com todas as informacoes.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_CARLA}    ${EMAIL_CARLA}
    Cadastrar Experiencia Recomendacao    ${EMAIL_CARLA}    Prof. Lima    Recomendo fortemente    2    7
    ${experiencias}=    Listar Experiencias Candidato    ${EMAIL_CARLA}
    Length Should Be    ${experiencias}    1
    Should Contain    ${experiencias}[0]    Recomendação#1
    Should Contain    ${experiencias}[0]    Prof. Lima
    Should Contain    ${experiencias}[0]    Recomendo fortemente

Experiencias Devem Receber Codigos Sequenciais Iniciando Em Um
    [Documentation]    Cada experiencia cadastrada recebe codigo identificador sequencial numerico iniciando de 1.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Cadastrar Experiencia Desenvolvimento    ${EMAIL_ANA}    Primeira    https://github.com/ana/1    10    5
    Cadastrar Experiencia Representacao    ${EMAIL_ANA}    Segunda    2    ${False}    ${False}    0
    Cadastrar Experiencia Recomendacao    ${EMAIL_ANA}    Prof. A    Terceira    1    4
    ${experiencias}=    Listar Experiencias Candidato    ${EMAIL_ANA}
    Length Should Be    ${experiencias}    3
    Should Contain    ${experiencias}[0]    Desenvolvimento#1
    Should Contain    ${experiencias}[1]    Representação#2
    Should Contain    ${experiencias}[2]    Recomendação#3

Exibir Pontos Experiencias Candidato Deve Somar Todas As Experiencias
    [Documentation]    Pontos exibidos correspondem a soma do XP de todas as experiencias do candidato.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Cadastrar Experiencia Desenvolvimento    ${EMAIL_ANA}    Projeto A    https://github.com/ana/a    30    10
    Cadastrar Experiencia Representacao    ${EMAIL_ANA}    Cargo B    2    ${True}    ${False}    0
    Cadastrar Experiencia Recomendacao    ${EMAIL_ANA}    Prof. C    Carta C    2    5
    ${pontos}=    Exibir Pontos Experiencias Candidato    ${EMAIL_ANA}
    Should Be Equal As Numbers    ${pontos}    45

Exibir Pontos Experiencias Candidato Sem Experiencias Deve Retornar Zero
    [Documentation]    Candidato sem experiencias acumula zero pontos de experiencia.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    ${pontos}=    Exibir Pontos Experiencias Candidato    ${EMAIL_ANA}
    Should Be Equal As Numbers    ${pontos}    0

Cadastrar Experiencia Desenvolvimento Para Candidato Inexistente Deve Lancar Excecao
    [Documentation]    Operacao com candidato inexistente deve lancar IllegalArgumentException.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *IllegalArgumentException*    App.Cadastrar Experiencia Desenvolvimento    inexistente@email.com    Desc    https://github.com/x    10    5

Cadastrar Experiencia Representacao Para Candidato Inexistente Deve Lancar Excecao
    [Documentation]    Operacao com candidato inexistente deve lancar IllegalArgumentException.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *IllegalArgumentException*    App.Cadastrar Experiencia Representacao    inexistente@email.com    Cargo    2    ${False}    ${False}    0

Cadastrar Experiencia Recomendacao Para Candidato Inexistente Deve Lancar Excecao
    [Documentation]    Operacao com candidato inexistente deve lancar IllegalArgumentException.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *IllegalArgumentException*    App.Cadastrar Experiencia Recomendacao    inexistente@email.com    Prof. X    Carta    2    5

Listar Experiencias Candidato Inexistente Deve Lancar Excecao
    [Documentation]    Operacao com candidato inexistente deve lancar IllegalArgumentException.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *IllegalArgumentException*    App.Listar Experiencias Candidato    inexistente@email.com

Exibir Pontos Experiencias Candidato Inexistente Deve Lancar Excecao
    [Documentation]    Operacao com candidato inexistente deve lancar IllegalArgumentException.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *IllegalArgumentException*    App.Exibir Pontos Experiencias Candidato    inexistente@email.com

Listar Selecionados Por Oportunidade Inexistente Deve Lancar Excecao
    [Documentation]    Operacao com oportunidade inexistente deve lancar IllegalArgumentException.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *IllegalArgumentException*    App.Listar Selecionados Por Oportunidade    Projeto Inexistente

Listar Candidatos Deve Ordenar Por Pontos De Experiencia Decrescente
    [Documentation]    Bonus: listarCandidatos apresenta candidatos ordenados por XP do maior para o menor.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    Zara Lima    zara@universidade.edu
    Cadastrar Candidato Com Sucesso    Ana Campos    ana.campos@universidade.edu
    Cadastrar Candidato Com Sucesso    Bruno Dias    bruno.dias@universidade.edu
    Cadastrar Experiencia Desenvolvimento    zara@universidade.edu    Proj Z    https://github.com/z    10    5
    Cadastrar Experiencia Desenvolvimento    ana.campos@universidade.edu    Proj A    https://github.com/a    30    10
    Cadastrar Experiencia Desenvolvimento    bruno.dias@universidade.edu    Proj B    https://github.com/b    20    10
    ${candidatos}=    Listar Candidatos
    Length Should Be    ${candidatos}    3
    Should Contain    ${candidatos}[0]    Ana Campos
    Should Contain    ${candidatos}[1]    Bruno Dias
    Should Contain    ${candidatos}[2]    Zara Lima

Listar Selecionados Por Oportunidade Deve Ordenar Por Pontos De Experiencia Decrescente
    [Documentation]    Bonus: listarSelecionadosPorOportunidade apresenta selecionados ordenados por XP decrescente.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    Zara Lima    zara@universidade.edu
    Cadastrar Candidato Com Sucesso    Ana Campos    ana.campos@universidade.edu
    Cadastrar Experiencia Desenvolvimento    zara@universidade.edu    Proj Z    https://github.com/z    10    5
    Cadastrar Experiencia Desenvolvimento    ana.campos@universidade.edu    Proj A    https://github.com/a    30    10
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    2    5.0
    Adicionar Candidato Oportunidade Com Sucesso    zara@universidade.edu    ${PROJETO_ERP}
    Adicionar Candidato Oportunidade Com Sucesso    ana.campos@universidade.edu    ${PROJETO_ERP}
    ${selecionados}=    Listar Selecionados Por Oportunidade    ${PROJETO_ERP}
    Length Should Be    ${selecionados}    2
    Should Contain    ${selecionados}[0]    Ana Campos
    Should Contain    ${selecionados}[1]    Zara Lima

Inicializar Recruit Me Deve Limpar Estado Do Sistema
    [Documentation]    inicializarRecruitMe recria o sistema descartando candidatos e oportunidades cadastrados.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    1    0.0
    App.Inicializar Recruit Me
    ${candidatos}=    Listar Candidatos
    ${oportunidades}=    Listar Oportunidades
    Length Should Be    ${candidatos}    0
    Length Should Be    ${oportunidades}    0

Fluxo Integrado Cadastro Experiencias Selecao E Consultas
    [Documentation]    Fluxo composto: candidatos, oportunidades, experiencias, selecao, listagens e pontos.
    [Setup]    Criar Fachada Limpa
    Cadastrar Candidato Com Sucesso    ${NOME_ANA}    ${EMAIL_ANA}
    Cadastrar Candidato Com Sucesso    ${NOME_BRUNO}    ${EMAIL_BRUNO}
    Cadastrar Oportunidade Com Sucesso    ${PROJETO_ERP}    2    20.0
    Cadastrar Experiencia Desenvolvimento    ${EMAIL_ANA}    ERP modular    https://github.com/ana/erp    25    8
    Cadastrar Experiencia Recomendacao    ${EMAIL_ANA}    Prof. Gomes    Destaque academico    3    5
    Cadastrar Experiencia Representacao    ${EMAIL_BRUNO}    Monitoria    3    ${False}    ${True}    0
    ${pontos_ana}=    Exibir Pontos Experiencias Candidato    ${EMAIL_ANA}
    Should Be Equal As Numbers    ${pontos_ana}    24
    ${pontos_bruno}=    Exibir Pontos Experiencias Candidato    ${EMAIL_BRUNO}
    Should Be Equal As Numbers    ${pontos_bruno}    6
    Adicionar Candidato Oportunidade Com Sucesso    ${EMAIL_ANA}    ${PROJETO_ERP}
    Adicionar Candidato Oportunidade Com Sucesso    ${EMAIL_BRUNO}    ${PROJETO_ERP}
    Oportunidade Deve Conter Status    ${PROJETO_ERP}    ${STATUS_FECHADA}
    ${selecionados}=    Listar Selecionados Por Oportunidade    ${PROJETO_ERP}
    Length Should Be    ${selecionados}    2
    Should Contain    ${selecionados}[0]    ${NOME_ANA}
    Should Contain    ${selecionados}[1]    ${NOME_BRUNO}
    ${experiencias}=    Listar Experiencias Candidato    ${EMAIL_ANA}
    Length Should Be    ${experiencias}    2
    Candidato Deve Aparecer Na Listagem    ${NOME_ANA}    ${EMAIL_ANA}
    Candidato Deve Aparecer Na Listagem    ${NOME_BRUNO}    ${EMAIL_BRUNO}
