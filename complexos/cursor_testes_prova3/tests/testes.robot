*** Settings ***
Documentation     Suite de testes de aceitacao do sistema RecruitMe (LP2 - Prova 2)
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Variables ***
${EMAIL_ALICE}      alice@email.com
${EMAIL_BOB}        bob@email.com
${EMAIL_CAROL}      carol@email.com
${PROJETO_VAGAS}    Projeto Selecao

${EMAIL_DEV}    dev@email.com

*** Keywords ***
Preparar Candidato Com Pontos
    [Arguments]    ${email}    ${nome}    ${pontos_necessarios}
    Cadastrar Candidato    ${nome}    ${email}
    ${valor_base}=    Evaluate    int(${pontos_necessarios}) - 1
    Cadastrar Experiencia Recomendacao    ${email}    Prof Teste    Carta teste    1    ${valor_base}

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

Adicionar Candidato Com Pontos Suficientes Retorna True
    Preparar Candidato Com Pontos    ${EMAIL_ALICE}    Ana Alice    20.0
    Cadastrar Oportunidade    ${PROJETO_VAGAS}    2    10.0
    ${resultado}=    Adicionar Candidato Oportunidade    ${EMAIL_ALICE}    ${PROJETO_VAGAS}
    Should Be True    ${resultado}

Adicionar Candidato Com Pontos Insuficientes Retorna False
    Preparar Candidato Com Pontos    ${EMAIL_BOB}    Bob Silva    5.0
    Cadastrar Oportunidade    Projeto Exigente    1    10.0
    ${resultado}=    Adicionar Candidato Oportunidade    ${EMAIL_BOB}    Projeto Exigente
    Should Not Be True    ${resultado}

Adicionar Candidato Com Pontos Iguais Ao Minimo Retorna True
    Preparar Candidato Com Pontos    ${EMAIL_CAROL}    Carol Dias    10.0
    Cadastrar Oportunidade    Projeto Minimo    1    10.0
    ${resultado}=    Adicionar Candidato Oportunidade    ${EMAIL_CAROL}    Projeto Minimo
    Should Be True    ${resultado}

Listar Selecionados Por Oportunidade Vazio Quando Ninguem Foi Selecionado
    Cadastrar Oportunidade    Projeto Vazio    2    1.0
    ${selecionados}=    Listar Selecionados Por Oportunidade    Projeto Vazio
    Should Be Empty    ${selecionados}

Listar Selecionados Contem Representacao Do Candidato Selecionado
    Preparar Candidato Com Pontos    ${EMAIL_ALICE}    Diana Lima    15.0
    Cadastrar Oportunidade    Projeto Lista    1    5.0
    Adicionar Candidato Oportunidade    ${EMAIL_ALICE}    Projeto Lista
    ${selecionados}=    Listar Selecionados Por Oportunidade    Projeto Lista
    Length Should Be    ${selecionados}    1
    Should Contain    ${selecionados}[0]    Diana Lima
    Should Contain    ${selecionados}[0]    ${EMAIL_ALICE}

Oportunidade Fecha Apos Atingir Quantidade De Selecionados
    Preparar Candidato Com Pontos    alice.fechar@email.com    Alice Fechar    20.0
    Preparar Candidato Com Pontos    bob.fechar@email.com    Bob Fechar    20.0
    Cadastrar Oportunidade    Projeto Fechar    2    5.0
    Adicionar Candidato Oportunidade    alice.fechar@email.com    Projeto Fechar
    Adicionar Candidato Oportunidade    bob.fechar@email.com    Projeto Fechar
    ${oportunidades}=    Listar Oportunidades
    Should Contain    ${oportunidades}[0]    fechada
    Should Not Contain    ${oportunidades}[0]    Ainda estamos contratando!

Nao Adicionar Candidato Em Oportunidade Fechada Retorna False
    Preparar Candidato Com Pontos    carol.fechar@email.com    Carol Fechar    20.0
    Preparar Candidato Com Pontos    dave.fechar@email.com    Dave Fechar    20.0
    Preparar Candidato Com Pontos    eve.fechar@email.com    Eve Fechar    20.0
    Cadastrar Oportunidade    Projeto Lotado    2    5.0
    Adicionar Candidato Oportunidade    carol.fechar@email.com    Projeto Lotado
    Adicionar Candidato Oportunidade    dave.fechar@email.com    Projeto Lotado
    ${resultado}=    Adicionar Candidato Oportunidade    eve.fechar@email.com    Projeto Lotado
    Should Not Be True    ${resultado}

Listar Selecionados Retorna Todos Os Candidatos Selecionados
    Preparar Candidato Com Pontos    um@email.com    Candidato Um    30.0
    Preparar Candidato Com Pontos    dois@email.com    Candidato Dois    30.0
    Cadastrar Oportunidade    Projeto Multi    3    10.0
    Adicionar Candidato Oportunidade    um@email.com    Projeto Multi
    Adicionar Candidato Oportunidade    dois@email.com    Projeto Multi
    ${selecionados}=    Listar Selecionados Por Oportunidade    Projeto Multi
    Length Should Be    ${selecionados}    2

Oportunidade Aberta Com Vagas Disponiveis Exibe Mensagem Contratando
    Preparar Candidato Com Pontos    parcial@email.com    Candidato Parcial    25.0
    Cadastrar Oportunidade    Projeto Parcial    3    5.0
    Adicionar Candidato Oportunidade    parcial@email.com    Projeto Parcial
    ${oportunidades}=    Listar Oportunidades
    Should Contain    ${oportunidades}[0]    aberta
    Should Contain    ${oportunidades}[0]    Ainda estamos contratando!

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

Listar Candidatos Ordenados Por Pontos Decrescente
    Cadastrar Candidato    Baixo XP    baixo@email.com
    Cadastrar Candidato    Medio XP    medio@email.com
    Cadastrar Candidato    Alto XP    alto@email.com
    Cadastrar Experiencia Recomendacao    baixo@email.com    Prof    Carta    1    4
    Cadastrar Experiencia Recomendacao    medio@email.com    Prof    Carta    2    13
    Cadastrar Experiencia Desenvolvimento    alto@email.com    Repo    https://github.com/alto/r    100    10
    ${candidatos}=    Listar Candidatos
    Length Should Be    ${candidatos}    3
    Should Contain    ${candidatos}[0]    alto@email.com
    Should Contain    ${candidatos}[1]    medio@email.com
    Should Contain    ${candidatos}[2]    baixo@email.com

Listar Candidatos Com Mesmos Pontos Mantem Todos Na Lista
    Cadastrar Candidato    Empate A    empate.a@email.com
    Cadastrar Candidato    Empate B    empate.b@email.com
    Cadastrar Experiencia Recomendacao    empate.a@email.com    Prof    Carta    2    8
    Cadastrar Experiencia Recomendacao    empate.b@email.com    Prof    Carta    2    8
    ${candidatos}=    Listar Candidatos
    Length Should Be    ${candidatos}    2
    Should Contain    ${candidatos}[0]    empate.a@email.com
    Should Contain    ${candidatos}[1]    empate.b@email.com

Listar Selecionados Por Oportunidade Ordenados Por Pontos Decrescente
    Cadastrar Candidato    Sel Baixo    sel.baixo@email.com
    Cadastrar Candidato    Sel Medio    sel.medio@email.com
    Cadastrar Candidato    Sel Alto    sel.alto@email.com
    Cadastrar Experiencia Recomendacao    sel.baixo@email.com    Prof    Carta    1    4
    Cadastrar Experiencia Recomendacao    sel.medio@email.com    Prof    Carta    2    13
    Cadastrar Experiencia Desenvolvimento    sel.alto@email.com    Repo    https://github.com/s/a    100    10
    Cadastrar Oportunidade    Projeto Ordem    3    1.0
    Adicionar Candidato Oportunidade    sel.baixo@email.com    Projeto Ordem
    Adicionar Candidato Oportunidade    sel.medio@email.com    Projeto Ordem
    Adicionar Candidato Oportunidade    sel.alto@email.com    Projeto Ordem
    ${selecionados}=    Listar Selecionados Por Oportunidade    Projeto Ordem
    Length Should Be    ${selecionados}    3
    Should Contain    ${selecionados}[0]    sel.alto@email.com
    Should Contain    ${selecionados}[1]    sel.medio@email.com
    Should Contain    ${selecionados}[2]    sel.baixo@email.com

Listar Candidatos Sem Experiencia Aparecem Com Zero Pontos
    Cadastrar Candidato    Com XP    com.xp@email.com
    Cadastrar Candidato    Sem XP    sem.xp@email.com
    Cadastrar Experiencia Recomendacao    com.xp@email.com    Prof    Carta    3    10
    ${candidatos}=    Listar Candidatos
    Length Should Be    ${candidatos}    2
    Should Contain    ${candidatos}[0]    com.xp@email.com
    Should Contain    ${candidatos}[1]    sem.xp@email.com

Ordenacao Reflete Pontos Atualizados Apos Novas Experiencias
    Cadastrar Candidato    Inicial Lider    lider@email.com
    Cadastrar Candidato    Inicial Seguidor    seguidor@email.com
    Cadastrar Experiencia Recomendacao    lider@email.com    Prof    Carta    3    20
    Cadastrar Experiencia Recomendacao    seguidor@email.com    Prof    Carta    1    4
    ${antes}=    Listar Candidatos
    Should Contain    ${antes}[0]    lider@email.com
    Cadastrar Experiencia Desenvolvimento    seguidor@email.com    Repo grande    https://github.com/s/r    200    10
    ${depois}=    Listar Candidatos
    Should Contain    ${depois}[0]    seguidor@email.com
    Should Contain    ${depois}[1]    lider@email.com

Cadastrar Experiencia Desenvolvimento Candidato Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Cadastrar Experiencia Desenvolvimento
    ...    inexistente@email.com    Desc    https://github.com/x    10    5

Cadastrar Experiencia Representacao Candidato Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Cadastrar Experiencia Representacao
    ...    inexistente@email.com    Cargo    2    ${False}    ${False}    1

Cadastrar Experiencia Recomendacao Candidato Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Cadastrar Experiencia Recomendacao
    ...    inexistente@email.com    Prof    Carta    2    5

Listar Experiencias Candidato Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Listar Experiencias Candidato    inexistente@email.com

Exibir Pontos Experiencias Candidato Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Exibir Pontos Experiencias Candidato    inexistente@email.com

Adicionar Candidato Oportunidade Candidato Inexistente Lanca Excecao
    Cadastrar Oportunidade    Projeto Excecao    1    1.0
    Run Keyword And Expect Error    *IllegalArgumentException*    Adicionar Candidato Oportunidade
    ...    inexistente@email.com    Projeto Excecao

Adicionar Candidato Oportunidade Oportunidade Inexistente Lanca Excecao
    Cadastrar Candidato    Candidato Valido    valido@email.com
    Run Keyword And Expect Error    *IllegalArgumentException*    Adicionar Candidato Oportunidade
    ...    valido@email.com    Projeto Inexistente

Listar Selecionados Por Oportunidade Inexistente Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Listar Selecionados Por Oportunidade    Projeto Fantasma

Adicionar Candidato Oportunidade Ambos Inexistentes Lanca Excecao
    Run Keyword And Expect Error    *IllegalArgumentException*    Adicionar Candidato Oportunidade
    ...    fantasma@email.com    Projeto Fantasma

Cadastrar Experiencia Desenvolvimento Excecao Possui Mensagem Adequada
    ${erro}=    Run Keyword And Expect Error    *    Cadastrar Experiencia Desenvolvimento
    ...    nao.existe@email.com    Desc    https://github.com/x    1    1
    Should Contain    ${erro}    IllegalArgumentException

Adicionar Candidato Oportunidade Excecao Possui Mensagem Adequada
    ${erro}=    Run Keyword And Expect Error    *    Adicionar Candidato Oportunidade
    ...    nao.existe@email.com    Projeto Qualquer
    Should Contain    ${erro}    IllegalArgumentException

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
