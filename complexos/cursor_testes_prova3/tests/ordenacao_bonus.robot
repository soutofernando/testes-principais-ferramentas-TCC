*** Settings ***
Documentation     Testes de aceitação - bônus de ordenação por pontos de experiência (Parte 3)
Library           RecruitMeFacade
Suite Setup       Inicializar Recruit Me
Test Setup        Inicializar Recruit Me

*** Test Cases ***
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
