*** Settings ***
Documentation    Testes de aceitacao do sistema EcoPontos via FacadeEcoPontos.
Library          BuiltIn
Library          Collections
Library          String
Library          facade.FacadeEcoPontos    scope=TEST    WITH NAME    App

*** Variables ***
${CPF_ANA}              11144477735
${CPF_BRA}              52998224725
${CPF_CAR}              39053344705
${CPF_DAN}              23100299900
${CPF_ELI}              12345678909
${SENHA_PADRAO}         senha123456
${SENHA_NOVA}           nova123456
${RESIDENCIA_APT}       APT1B2C
${RESIDENCIA_BLK}       BLK3D4E
${RESIDENCIA_RES}       RES5F6G
${TIPO_RECICLAGEM}      RECICLAGEM
${TIPO_ECONOMIA_AGUA}   ECONOMIA DE ÁGUA
${TIPO_ECONOMIA_ENERGIA}    ECONOMIA DE ENERGIA
${TIPO_COMPOSTAGEM}     COMPOSTAGEM
${CPF_LIKER_05}         71673923081
${CPF_LIKER_06}         84702907006
${CPF_LIKER_07}         56201805089
${CPF_LIKER_08}         93400204083
${CPF_LIKER_09}         60819407042
${CPF_LIKER_10}         45317828791
${CPF_LIKER_11}         31759407026
${RESIDENCIA_LIK11}     LIK11G7
${RESIDENCIA_LIK05}     LIK05B1
${RESIDENCIA_LIK06}     LIK06B2
${RESIDENCIA_LIK07}     LIK07C3
${RESIDENCIA_LIK08}     LIK08D4
${RESIDENCIA_LIK09}     LIK09E5
${RESIDENCIA_LIK10}     LIK10F6
${LINK_COMPROVACAO}     https://ecopontos.gov.br/comprovante/001
${LINK_MIDIA}           https://ecopontos.gov.br/midia/001

*** Keywords ***
Criar Fachada Limpa
    [Documentation]    Prepara estado limpo; a instancia da facade e recriada via scope=TEST.

Cadastrar Morador Com Sucesso
    [Arguments]    ${nome}    ${cpf}    ${senha}    ${residencia}
    ${ok}=    Criar Morador    ${nome}    ${cpf}    ${senha}    ${residencia}
    Should Be True    ${ok}

Cadastrar Morador Ana
    Cadastrar Morador Com Sucesso    Ana Silva    ${CPF_ANA}    ${SENHA_PADRAO}    ${RESIDENCIA_APT}

Cadastrar Morador Bruno
    Cadastrar Morador Com Sucesso    Bruno Costa    ${CPF_BRA}    ${SENHA_PADRAO}    ${RESIDENCIA_BLK}

Cadastrar Morador Carla
    Cadastrar Morador Com Sucesso    Carla Dias    ${CPF_CAR}    ${SENHA_PADRAO}    ${RESIDENCIA_RES}

Cadastrar Morador Daniel
    Cadastrar Morador Com Sucesso    Daniel Alves    ${CPF_DAN}    ${SENHA_PADRAO}    ${RESIDENCIA_APT}

Cadastrar Morador Elias
    Cadastrar Morador Com Sucesso    Elias Ferreira    ${CPF_ELI}    ${SENHA_PADRAO}    ${RESIDENCIA_BLK}

Criar Morador
    [Arguments]    ${nome}    ${cpf}    ${senha}    ${residencia}
    ${resultado}=    App.Criar Morador    ${nome}    ${cpf}    ${senha}    ${residencia}
    [Return]    ${resultado}

Exibir Moradores
    ${resultado}=    App.Exibir Moradores
    [Return]    ${resultado}

Alterar Senha Morador
    [Arguments]    ${cpf}    ${senha_antiga}    ${nova_senha}
    ${resultado}=    App.Alterar Senha Morador    ${cpf}    ${senha_antiga}    ${nova_senha}
    [Return]    ${resultado}

Criar Orientacao
    [Arguments]    ${cpf}    ${senha}    ${tipo}
    ${resultado}=    App.Criar Orientacao    ${cpf}    ${senha}    ${tipo}
    [Return]    ${resultado}

Adicionar Item Texto Orientacao
    [Arguments]    ${cpf}    ${senha}    ${id_orientacao}    ${texto}
    ${resultado}=    App.Adicionar Item Texto Orientacao    ${cpf}    ${senha}    ${id_orientacao}    ${texto}
    [Return]    ${resultado}

Adicionar Item Midia Orientacao
    [Arguments]    ${cpf}    ${senha}    ${id_orientacao}    ${link}    ${titulo}    ${duracao_segundos}
    ${resultado}=    App.Adicionar Item Midia Orientacao    ${cpf}    ${senha}    ${id_orientacao}    ${link}    ${titulo}    ${duracao_segundos}
    [Return]    ${resultado}

Adicionar Item Fonte Orientacao
    [Arguments]    ${cpf}    ${senha}    ${id_orientacao}    ${titulo}    ${fonte}    ${ano}    ${verificada}    ${relevancia}
    ${resultado}=    App.Adicionar Item Fonte Orientacao    ${cpf}    ${senha}    ${id_orientacao}    ${titulo}    ${fonte}    ${ano}    ${verificada}    ${relevancia}
    [Return]    ${resultado}

Listar Orientacoes
    ${resultado}=    App.Listar Orientacoes
    [Return]    ${resultado}

Listar Orientacoes Detalhadas
    ${resultado}=    App.Listar Orientacoes Detalhadas
    [Return]    ${resultado}

Listar Orientacao
    [Arguments]    ${id_orientacao}
    ${resultado}=    App.Listar Orientacao    ${id_orientacao}
    [Return]    ${resultado}

Listar Orientacao Detalhada
    [Arguments]    ${id_orientacao}
    ${resultado}=    App.Listar Orientacao Detalhada    ${id_orientacao}
    [Return]    ${resultado}

Consultar Creditos Engajamento
    [Arguments]    ${cpf}    ${senha}
    ${resultado}=    App.Consultar Creditos Engajamento    ${cpf}    ${senha}
    [Return]    ${resultado}

Curtir Orientacao
    [Arguments]    ${cpf}    ${senha}    ${id_orientacao}
    App.Curtir Orientacao    ${cpf}    ${senha}    ${id_orientacao}

Ranking Moradores Por Engajamento
    ${resultado}=    App.Ranking Moradores Por Engajamento
    [Return]    ${resultado}

Registrar Entrega Papel
    [Arguments]    ${cpf}    ${senha}    ${quantidade_kg}    ${descricao}    ${link_comprovacao}
    ${resultado}=    App.Registrar Entrega Papel    ${cpf}    ${senha}    ${quantidade_kg}    ${descricao}    ${link_comprovacao}
    [Return]    ${resultado}

Registrar Entrega Plastico
    [Arguments]    ${cpf}    ${senha}    ${quantidade_kg}    ${descricao}    ${link_comprovacao}
    ${resultado}=    App.Registrar Entrega Plastico    ${cpf}    ${senha}    ${quantidade_kg}    ${descricao}    ${link_comprovacao}
    [Return]    ${resultado}

Registrar Entrega Vidro
    [Arguments]    ${cpf}    ${senha}    ${quantidade_kg}    ${descricao}    ${link_comprovacao}
    ${resultado}=    App.Registrar Entrega Vidro    ${cpf}    ${senha}    ${quantidade_kg}    ${descricao}    ${link_comprovacao}
    [Return]    ${resultado}

Registrar Entrega Eletronico
    [Arguments]    ${cpf}    ${senha}    ${quantidade_itens}    ${descricao}    ${link_comprovacao}
    ${resultado}=    App.Registrar Entrega Eletronico    ${cpf}    ${senha}    ${quantidade_itens}    ${descricao}    ${link_comprovacao}
    [Return]    ${resultado}

Consultar Regra Creditos
    [Arguments]    ${cpf}    ${senha}    ${tipo_entrega}
    ${resultado}=    App.Consultar Regra Creditos    ${cpf}    ${senha}    ${tipo_entrega}
    [Return]    ${resultado}

Gerar Boletim
    [Arguments]    ${cpf}    ${senha}
    ${resultado}=    App.Gerar Boletim    ${cpf}    ${senha}
    [Return]    ${resultado}

Gerar Boletim Por Tipo Material
    [Arguments]    ${cpf}    ${senha}    ${tipo_material}
    ${resultado}=    App.Gerar Boletim Por Tipo Material    ${cpf}    ${senha}    ${tipo_material}
    [Return]    ${resultado}

Gerar Boletim Por Tipo Orientacao
    [Arguments]    ${cpf}    ${senha}    ${tipo_orientacao}
    ${resultado}=    App.Gerar Boletim Por Tipo Orientacao    ${cpf}    ${senha}    ${tipo_orientacao}
    [Return]    ${resultado}

Gerar Texto Com Tamanho
    [Arguments]    ${tamanho}
    ${texto}=    Evaluate    'A' * int(${tamanho})
    [Return]    ${texto}

Cadastrar Moradores Curtidores Base
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Bruno Costa    ${CPF_BRA}    ${SENHA_PADRAO}    ${RESIDENCIA_BLK}
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Carla Dias    ${CPF_CAR}    ${SENHA_PADRAO}    ${RESIDENCIA_RES}
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Daniel Alves    ${CPF_DAN}    ${SENHA_PADRAO}    ${RESIDENCIA_APT}
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Elias Ferreira    ${CPF_ELI}    ${SENHA_PADRAO}    ${RESIDENCIA_BLK}
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Morador Cinco    ${CPF_LIKER_05}    ${SENHA_PADRAO}    ${RESIDENCIA_LIK05}
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Morador Seis    ${CPF_LIKER_06}    ${SENHA_PADRAO}    ${RESIDENCIA_LIK06}
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Morador Sete    ${CPF_LIKER_07}    ${SENHA_PADRAO}    ${RESIDENCIA_LIK07}
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Morador Oito    ${CPF_LIKER_08}    ${SENHA_PADRAO}    ${RESIDENCIA_LIK08}
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Morador Nove    ${CPF_LIKER_09}    ${SENHA_PADRAO}    ${RESIDENCIA_LIK09}
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Morador Dez    ${CPF_LIKER_10}    ${SENHA_PADRAO}    ${RESIDENCIA_LIK10}
    Run Keyword And Ignore Error    Cadastrar Morador Com Sucesso    Morador Onze    ${CPF_LIKER_11}    ${SENHA_PADRAO}    ${RESIDENCIA_LIK11}

Obter Curtidores Disponiveis
    [Arguments]    ${cpf_autor}=${EMPTY}
    @{todos}=    Create List    ${CPF_BRA}    ${CPF_CAR}    ${CPF_DAN}    ${CPF_ELI}    ${CPF_LIKER_05}    ${CPF_LIKER_06}    ${CPF_LIKER_07}    ${CPF_LIKER_08}    ${CPF_LIKER_09}    ${CPF_LIKER_10}    ${CPF_LIKER_11}
    @{disponiveis}=    Create List
    FOR    ${cpf}    IN    @{todos}
        Run Keyword If    '${cpf}' != '${cpf_autor}'    Append To List    ${disponiveis}    ${cpf}
    END
    [Return]    ${disponiveis}

Dar Curtidas A Orientacao
    [Arguments]    ${id_orientacao}    ${quantidade}    ${cpf_autor}=${EMPTY}
    @{curtidores}=    Obter Curtidores Disponiveis    ${cpf_autor}
    FOR    ${indice}    IN RANGE    ${quantidade}
        Curtir Orientacao    ${curtidores}[${indice}]    ${SENHA_PADRAO}    ${id_orientacao}
    END

*** Test Cases ***
Cadastrar Morador Com Dados Validos Deve Retornar Verdadeiro
    [Documentation]    Morador valido com CPF de 11 digitos, senha com 8+ caracteres e residencia de 7 caracteres alfanumericos.
    [Setup]    Criar Fachada Limpa
    ${ok}=    Criar Morador    Ana Silva    ${CPF_ANA}    ${SENHA_PADRAO}    ${RESIDENCIA_APT}
    Should Be True    ${ok}

Cadastrar Morador Com CPF Duplicado Deve Retornar Falso
    [Documentation]    Nao e permitido cadastrar dois moradores com o mesmo CPF.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${ok}=    Criar Morador    Ana Duplicada    ${CPF_ANA}    ${SENHA_PADRAO}    ${RESIDENCIA_BLK}
    Should Not Be True    ${ok}

Cadastrar Morador Com CPF Nulo Deve Lancar Excecao
    [Documentation]    Strings nulas nao sao aceitas na criacao de morador.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Criar Morador    Ana Silva    ${None}    ${SENHA_PADRAO}    ${RESIDENCIA_APT}

Cadastrar Morador Com CPF Vazio Deve Lancar Excecao
    [Documentation]    Strings vazias nao sao aceitas na criacao de morador.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Criar Morador    Ana Silva    ${EMPTY}    ${SENHA_PADRAO}    ${RESIDENCIA_APT}

Cadastrar Morador Com Senha Menor Que Oito Caracteres Deve Lancar Excecao
    [Documentation]    Senha textual deve possuir no minimo oito caracteres.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Criar Morador    Ana Silva    ${CPF_ANA}    senha12    ${RESIDENCIA_APT}

Cadastrar Morador Com Residencia Invalida Deve Lancar Excecao
    [Documentation]    Residencia deve conter sete caracteres incluindo letras e numeros.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Criar Morador    Ana Silva    ${CPF_ANA}    ${SENHA_PADRAO}    APT123

Exibir Moradores Deve Ordenar Alfabeticamente
    [Documentation]    Listagem de moradores deve apresentar nomes em ordem alfabetica.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Com Sucesso    Carla Dias    ${CPF_CAR}    ${SENHA_PADRAO}    ${RESIDENCIA_RES}
    Cadastrar Morador Com Sucesso    Ana Silva    ${CPF_ANA}    ${SENHA_PADRAO}    ${RESIDENCIA_APT}
    Cadastrar Morador Com Sucesso    Bruno Costa    ${CPF_BRA}    ${SENHA_PADRAO}    ${RESIDENCIA_BLK}
    ${lista}=    Exibir Moradores
    Length Should Be    ${lista}    3
    Should Contain    ${lista}[0]    Ana Silva
    Should Contain    ${lista}[1]    Bruno Costa
    Should Contain    ${lista}[2]    Carla Dias

Exibir Moradores Nao Deve Expor CPF Nem Senha
    [Documentation]    Representacao textual de morador nao deve expor informacoes sensiveis.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${lista}=    Exibir Moradores
    Should Not Contain    ${lista}[0]    ${CPF_ANA}
    Should Not Contain    ${lista}[0]    ${SENHA_PADRAO}
    Should Contain    ${lista}[0]    ${RESIDENCIA_APT}

Alterar Senha Morador Com Senha Atual Correta Deve Retornar Verdadeiro
    [Documentation]    Senha pode ser alterada quando a senha atual informada e valida.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${ok}=    Alterar Senha Morador    ${CPF_ANA}    ${SENHA_PADRAO}    ${SENHA_NOVA}
    Should Be True    ${ok}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_NOVA}
    Should Be Equal As Integers    ${creditos}    0

Alterar Senha Morador Com Senha Atual Incorreta Deve Retornar Falso
    [Documentation]    Alteracao de senha falha quando a senha atual nao confere.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${ok}=    Alterar Senha Morador    ${CPF_ANA}    senhaerrada    ${SENHA_NOVA}
    Should Not Be True    ${ok}

Criar Orientacao Com Tipo Reciclagem Deve Retornar Identificador Zero
    [Documentation]    Orientacao e identificada pela ordem de insercao iniciando em zero.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    Should Be Equal As Integers    ${id}    0

Criar Orientacao Com Tipo Economia De Agua Deve Retornar Identificador Sequencial
    [Documentation]    Cada nova orientacao recebe identificador numerico sequencial.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_ECONOMIA_AGUA}
    Should Be Equal As Integers    ${id}    1

Criar Orientacao Sem Autenticacao Deve Lancar Excecao
    [Documentation]    Autenticacao e obrigatoria antes de registrar orientacao ambiental.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Run Keyword And Expect Error    *    Criar Orientacao    ${CPF_ANA}    senhaerrada    ${TIPO_RECICLAGEM}

Criar Orientacao Com Tipo Invalido Deve Lancar Excecao
    [Documentation]    Tipos permitidos: RECICLAGEM, ECONOMIA DE AGUA, ECONOMIA DE ENERGIA e COMPOSTAGEM.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Run Keyword And Expect Error    *    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    TIPO_INEXISTENTE

Adicionar Item Texto Orientacao Com Texto Valido Deve Retornar Verdadeiro
    [Documentation]    Item textual valido com ate 500 caracteres deve ser adicionado com sucesso.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    ${ok}=    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Should Be True    ${ok}

Adicionar Item Texto Orientacao Com Texto Acima De Quinhentos Caracteres Deve Lancar Excecao
    [Documentation]    Itens textuais possuem limite maximo de 500 caracteres.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    501
    Run Keyword And Expect Error    *    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}

Adicionar Item Midia Orientacao Com Duracao Negativa Deve Lancar Excecao
    [Documentation]    Duracao em segundos nao pode ser negativa.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    Run Keyword And Expect Error    *    Adicionar Item Midia Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${LINK_MIDIA}    Video Sustentavel    -1

Adicionar Item Fonte Orientacao Verificada Deve Retornar Verdadeiro
    [Documentation]    Fonte informativa verificada pode ser adicionada com relevancia entre 1 e 5.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_COMPOSTAGEM}
    ${ok}=    Adicionar Item Fonte Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    Guia Compostagem    Prefeitura    2024    ${True}    5
    Should Be True    ${ok}

Adicionar Item Fonte Orientacao Com Relevancia Fora Do Intervalo Deve Lancar Excecao
    [Documentation]    Relevancia de fonte informativa deve variar de 1 a 5.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_COMPOSTAGEM}
    Run Keyword And Expect Error    *    Adicionar Item Fonte Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    Guia Compostagem    Prefeitura    2024    ${True}    6

Listar Orientacoes Deve Exibir Do Mais Recente Para O Mais Antigo
    [Documentation]    Visualizacao resumida deve respeitar ordem inversa de registro.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id1}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${id2}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_ECONOMIA_ENERGIA}
    ${texto1}=    Gerar Texto Com Tamanho    50
    ${texto2}=    Gerar Texto Com Tamanho    60
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id1}    ${texto1}
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id2}    ${texto2}
    ${lista}=    Listar Orientacoes
    Length Should Be    ${lista}    2
    Should Contain    ${lista}[0]    ${TIPO_ECONOMIA_ENERGIA}
    Should Contain    ${lista}[1]    ${TIPO_RECICLAGEM}

Listar Orientacao Detalhada Deve Incluir Metadados
    [Documentation]    Visualizacao detalhada inclui metadados como duracao, verificacao e relevancia.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    Adicionar Item Midia Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${LINK_MIDIA}    Video Ecologico    120
    Adicionar Item Fonte Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    Fonte Oficial    IBAMA    2023    ${True}    4
    ${detalhe}=    Listar Orientacao Detalhada    ${id}
    Should Contain    ${detalhe}    Video Ecologico
    Should Contain    ${detalhe}    IBAMA
    Should Contain    ${detalhe}    4

Item Texto Com Menos De Cinquenta Caracteres Nao Deve Pontuar
    [Documentation]    Textos com menos de 50 caracteres nao geram creditos de engajamento.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    49
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    0

Item Texto Deve Pontuar Um Credito A Cada Dez Caracteres Com Truncamento
    [Documentation]    Pontuacao textual: 1 ponto a cada 10 caracteres, com truncamento de fracao.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    55
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    5    ${CPF_ANA}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    5

Item Midia Deve Pontuar Cinco Creditos Por Minuto Completo
    [Documentation]    Pontuacao de midia: 5 creditos a cada minuto completo de duracao.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_ECONOMIA_ENERGIA}
    Adicionar Item Midia Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${LINK_MIDIA}    Aula Energia    120
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    5    ${CPF_ANA}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    10

Item Fonte Verificada Deve Gerar Quinze Creditos
    [Documentation]    Fonte verificada gera 15 creditos; relevancia e apenas para visualizacao.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_COMPOSTAGEM}
    Adicionar Item Fonte Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    Manual    Secretaria    2024    ${True}    3
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    5    ${CPF_ANA}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    15

Item Fonte Nao Verificada Deve Gerar Cinco Creditos
    [Documentation]    Fonte nao verificada gera 5 creditos de engajamento.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_COMPOSTAGEM}
    Adicionar Item Fonte Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    Artigo    Blog    2024    ${False}    2
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    5    ${CPF_ANA}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    5

Pontuacao De Item Nao Deve Ultrapassar Cinquenta Creditos
    [Documentation]    Cada item informativo possui teto maximo de 50 creditos.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    500
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    5    ${CPF_ANA}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    50

Fator Curtidas Menos De Cinco Deve Zerar Pontuacao Da Orientacao
    [Documentation]    Com menos de 5 curtidas o fator de curtidas e zero.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Curtir Orientacao    ${CPF_BRA}    ${SENHA_PADRAO}    ${id}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    0

Fator Curtidas Entre Cinco E Dez Deve Multiplicar Por Um
    [Documentation]    Entre 5 e 10 curtidas o fator de curtidas e 1.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    5    ${CPF_ANA}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    5

Morador Nao Deve Curtir Propria Orientacao
    [Documentation]    Morador nao pode curtir orientacoes proprias.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Run Keyword And Expect Error    *    Curtir Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}

Morador Nao Deve Curtir Mesma Orientacao Duas Vezes
    [Documentation]    Curtida duplicada na mesma orientacao nao e permitida.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Curtir Orientacao    ${CPF_BRA}    ${SENHA_PADRAO}    ${id}
    Run Keyword And Expect Error    *    Curtir Orientacao    ${CPF_BRA}    ${SENHA_PADRAO}    ${id}

Ranking Moradores Por Engajamento Deve Ordenar Por Creditos
    [Documentation]    Ranking identifica moradores com mais creditos de engajamento.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id_ana}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${id_bra}=    Criar Orientacao    ${CPF_BRA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto_maior}=    Gerar Texto Com Tamanho    100
    ${texto_menor}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id_ana}    ${texto_menor}
    Adicionar Item Texto Orientacao    ${CPF_BRA}    ${SENHA_PADRAO}    ${id_bra}    ${texto_maior}
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id_ana}    5    ${CPF_ANA}
    Dar Curtidas A Orientacao    ${id_bra}    5    ${CPF_BRA}
    ${ranking}=    Ranking Moradores Por Engajamento
    Length Should Be    ${ranking}    2
    Should Contain    ${ranking}[0]    Bruno Costa
    Should Contain    ${ranking}[1]    Ana Silva

Ranking Moradores Por Engajamento Deve Desempatar Alfabeticamente
    [Documentation]    Em empate de creditos aplica-se desempate alfabetico pelo nome.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id_ana}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${id_bra}=    Criar Orientacao    ${CPF_BRA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id_ana}    ${texto}
    Adicionar Item Texto Orientacao    ${CPF_BRA}    ${SENHA_PADRAO}    ${id_bra}    ${texto}
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id_ana}    5    ${CPF_ANA}
    Dar Curtidas A Orientacao    ${id_bra}    5    ${CPF_BRA}
    ${ranking}=    Ranking Moradores Por Engajamento
    Should Contain    ${ranking}[0]    Ana Silva
    Should Contain    ${ranking}[1]    Bruno Costa

Registrar Entrega Papel Com Cinco Virgula Seis Kg Deve Gerar Um Credito
    [Documentation]    Exemplo da especificacao: 5,6 kg de papel geram 1 credito com truncamento.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${creditos}=    Registrar Entrega Papel    ${CPF_ANA}    ${SENHA_PADRAO}    5.6    Entrega de papel    ${LINK_COMPROVACAO}
    Should Be Equal As Integers    ${creditos}    1

Registrar Entrega Papel Abaixo De Cinco Kg Nao Deve Efetuar Registro
    [Documentation]    Quantidade inferior a 5 kg de papel nao gera credito nem registro.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${creditos}=    Registrar Entrega Papel    ${CPF_ANA}    ${SENHA_PADRAO}    4.9    Papel insuficiente    ${LINK_COMPROVACAO}
    Should Be Equal As Integers    ${creditos}    0

Registrar Entrega Papel Deve Respeitar Teto De Oito Creditos Por Entrega
    [Documentation]    Entrega de papel possui teto maximo de 8 creditos por registro.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${creditos}=    Registrar Entrega Papel    ${CPF_ANA}    ${SENHA_PADRAO}    100    Grande volume de papel    ${LINK_COMPROVACAO}
    Should Be Equal As Integers    ${creditos}    8

Registrar Entrega Plastico Com Quinze Virgula Cinco Kg Deve Gerar Cinco Creditos
    [Documentation]    Exemplo da especificacao: 15,5 kg de plastico geram 5 creditos.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${creditos}=    Registrar Entrega Plastico    ${CPF_ANA}    ${SENHA_PADRAO}    15.5    Entrega de plastico    ${LINK_COMPROVACAO}
    Should Be Equal As Integers    ${creditos}    5

Registrar Entrega Plastico Deve Respeitar Teto De Dez Creditos Por Entrega
    [Documentation]    Entrega de plastico possui teto maximo de 10 creditos por registro.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${creditos}=    Registrar Entrega Plastico    ${CPF_ANA}    ${SENHA_PADRAO}    100    Grande volume de plastico    ${LINK_COMPROVACAO}
    Should Be Equal As Integers    ${creditos}    10

Registrar Entrega Vidro Deve Respeitar Teto De Seis Creditos Por Entrega
    [Documentation]    Entrega de vidro possui teto maximo de 6 creditos por registro.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${creditos}=    Registrar Entrega Vidro    ${CPF_ANA}    ${SENHA_PADRAO}    100    Grande volume de vidro    ${LINK_COMPROVACAO}
    Should Be Equal As Integers    ${creditos}    6

Registrar Entrega Eletronico Deve Gerar Dois Creditos Por Item
    [Documentation]    Cada item eletronico entregue gera 2 creditos ambientais.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${creditos}=    Registrar Entrega Eletronico    ${CPF_ANA}    ${SENHA_PADRAO}    3    Celulares usados    ${LINK_COMPROVACAO}
    Should Be Equal As Integers    ${creditos}    6

Registrar Entrega Eletronico Deve Respeitar Teto De Doze Creditos Por Entrega
    [Documentation]    Entrega eletronica possui teto maximo de 12 creditos por registro.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${creditos}=    Registrar Entrega Eletronico    ${CPF_ANA}    ${SENHA_PADRAO}    10    Lote de eletronicos    ${LINK_COMPROVACAO}
    Should Be Equal As Integers    ${creditos}    12

Registrar Entrega Com Quantidade Negativa Deve Lancar Excecao
    [Documentation]    Quantidades negativas devem ser rejeitadas com excecao.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Run Keyword And Expect Error    *    Registrar Entrega Papel    ${CPF_ANA}    ${SENHA_PADRAO}    -1    Papel invalido    ${LINK_COMPROVACAO}

Consultar Regra Creditos De Papel Deve Retornar Texto Explicativo
    [Documentation]    Morador autenticado pode consultar regra de creditos por tipo de entrega.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${regra}=    Consultar Regra Creditos    ${CPF_ANA}    ${SENHA_PADRAO}    PAPEL
    Should Not Be Empty    ${regra}
    ${regra_minuscula}=    Convert To Lower Case    ${regra}
    Should Contain    ${regra_minuscula}    5

Gerar Boletim Geral Deve Retornar Resumo Textual
    [Documentation]    Boletim geral consolida creditos de entregas e orientacoes do morador.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    5    ${CPF_ANA}
    Registrar Entrega Papel    ${CPF_ANA}    ${SENHA_PADRAO}    5.6    Papel reciclado    ${LINK_COMPROVACAO}
    ${boletim}=    Gerar Boletim    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Not Be Empty    ${boletim}
    Should Contain    ${boletim}    Ana Silva

Gerar Boletim Por Tipo Material Deve Refletir Apenas Material Informado
    [Documentation]    Boletim por tipo de material exibe somente creditos daquele material.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Registrar Entrega Papel    ${CPF_ANA}    ${SENHA_PADRAO}    5.6    Papel reciclado    ${LINK_COMPROVACAO}
    Registrar Entrega Plastico    ${CPF_ANA}    ${SENHA_PADRAO}    15.5    Plastico reciclado    ${LINK_COMPROVACAO}
    ${boletim}=    Gerar Boletim Por Tipo Material    ${CPF_ANA}    ${SENHA_PADRAO}    PAPEL
    Should Not Be Empty    ${boletim}
    Should Contain    ${boletim}    PAPEL
    Should Not Contain    ${boletim}    PLASTICO

Gerar Boletim Por Tipo Orientacao Deve Refletir Apenas Tipo Informado
    [Documentation]    Boletim por tipo de orientacao exibe somente orientacoes daquele tipo.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id_reciclagem}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${id_compostagem}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_COMPOSTAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id_reciclagem}    ${texto}
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id_compostagem}    ${texto}
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id_reciclagem}    5    ${CPF_ANA}
    Dar Curtidas A Orientacao    ${id_compostagem}    5    ${CPF_ANA}
    ${boletim}=    Gerar Boletim Por Tipo Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    Should Not Be Empty    ${boletim}
    Should Contain    ${boletim}    RECICLAGEM
    Should Not Contain    ${boletim}    COMPOSTAGEM

Listar Orientacao Resumida Deve Exibir Autor E Conteudo Essencial
    [Documentation]    Visualizacao resumida de orientacao especifica deve conter autor e conteudo essencial.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    ${resumo}=    Listar Orientacao    ${id}
    Should Contain    ${resumo}    Ana Silva
    Should Contain    ${resumo}    ${TIPO_RECICLAGEM}

Listar Orientacoes Detalhadas Deve Retornar Lista Com Metadados
    [Documentation]    Listagem detalhada de orientacoes inclui metadados dos itens informativos.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_ECONOMIA_ENERGIA}
    Adicionar Item Midia Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${LINK_MIDIA}    Video Energia    60
    ${lista}=    Listar Orientacoes Detalhadas
    Length Should Be    ${lista}    1
    Should Contain    ${lista}[0]    Video Energia

Item Midia Com Menos De Um Minuto Completo Nao Deve Pontuar
    [Documentation]    Duracao truncada em minutos inteiros: 59 segundos geram zero creditos.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_ECONOMIA_ENERGIA}
    Adicionar Item Midia Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${LINK_MIDIA}    Video Curto    59
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    5    ${CPF_ANA}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    0

Fator Curtidas Com Quatro Curtidas Deve Zerar Pontuacao Da Orientacao
    [Documentation]    Com exatamente 4 curtidas o fator de curtidas permanece zero.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    4    ${CPF_ANA}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    0

Fator Curtidas Entre Onze E Cinquenta Deve Multiplicar Por Dois
    [Documentation]    Entre 11 e 50 curtidas o fator de curtidas e 2.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_RECICLAGEM}
    ${texto}=    Gerar Texto Com Tamanho    50
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    11    ${CPF_ANA}
    ${creditos}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be Equal As Integers    ${creditos}    10

Fluxo Integrado EcoPontos Deve Consolidar Moradores Orientacoes Entregas E Boletins
    [Documentation]    Fluxo completo: cadastro, orientacoes com itens, curtidas, entregas, creditos, ranking e boletins.
    [Setup]    Criar Fachada Limpa
    Cadastrar Morador Ana
    Cadastrar Morador Bruno
    ${id}=    Criar Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_ECONOMIA_AGUA}
    ${texto}=    Gerar Texto Com Tamanho    80
    Adicionar Item Texto Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${texto}
    Adicionar Item Midia Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    ${LINK_MIDIA}    Dica Agua    60
    Adicionar Item Fonte Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${id}    Cartilha    SEMA    2025    ${True}    5
    Cadastrar Moradores Curtidores Base
    Dar Curtidas A Orientacao    ${id}    5    ${CPF_ANA}
    ${creditos_papel}=    Registrar Entrega Papel    ${CPF_ANA}    ${SENHA_PADRAO}    5.6    Papel    ${LINK_COMPROVACAO}
    ${creditos_plastico}=    Registrar Entrega Plastico    ${CPF_ANA}    ${SENHA_PADRAO}    15.5    Plastico    ${LINK_COMPROVACAO}
    ${creditos_vidro}=    Registrar Entrega Vidro    ${CPF_ANA}    ${SENHA_PADRAO}    10    Vidro    ${LINK_COMPROVACAO}
    ${creditos_eletronico}=    Registrar Entrega Eletronico    ${CPF_ANA}    ${SENHA_PADRAO}    2    Eletronicos    ${LINK_COMPROVACAO}
    Should Be Equal As Integers    ${creditos_papel}    1
    Should Be Equal As Integers    ${creditos_plastico}    5
    Should Be Equal As Integers    ${creditos_vidro}    1
    Should Be Equal As Integers    ${creditos_eletronico}    4
    ${creditos_engajamento}=    Consultar Creditos Engajamento    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Be True    ${creditos_engajamento} > 0
    ${ranking}=    Ranking Moradores Por Engajamento
    Should Contain    ${ranking}[0]    Ana Silva
    ${boletim}=    Gerar Boletim    ${CPF_ANA}    ${SENHA_PADRAO}
    Should Not Be Empty    ${boletim}
    ${boletim_material}=    Gerar Boletim Por Tipo Material    ${CPF_ANA}    ${SENHA_PADRAO}    PAPEL
    Should Contain    ${boletim_material}    PAPEL
    ${boletim_orientacao}=    Gerar Boletim Por Tipo Orientacao    ${CPF_ANA}    ${SENHA_PADRAO}    ${TIPO_ECONOMIA_AGUA}
    Should Contain    ${boletim_orientacao}    ECONOMIA
