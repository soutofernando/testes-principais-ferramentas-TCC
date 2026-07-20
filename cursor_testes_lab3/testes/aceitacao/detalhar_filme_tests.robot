*** Settings ***
Documentation    Testes de aceitacao para detalhamento de filmes no FilmNow.
Resource         resources/filmnow_keywords.resource

*** Test Cases ***
Detalhar Filme Em Posicao Vazia
    [Documentation]    Deve retornar vazio quando nao ha filme na posicao.
    [Setup]    Criar Fachada Limpa
    Detalhar Deve Retornar Vazio    10

Detalhar Filme Existente
    [Documentation]    Deve exibir nome, ano e local conforme especificacao.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Detalhes Devem Ser    1    Anatomia de uma Queda    2023    Cinema

Detalhar Filme Em Posicao Intermediaria
    [Documentation]    Deve detalhar corretamente filmes fora da primeira posicao.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    11    Shrek 2    2004    Netflix
    Detalhes Devem Ser    11    Shrek 2    2004    Netflix

Detalhar Filme Apos Substituicao
    [Documentation]    Deve exibir os dados do filme atualmente cadastrado na posicao.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    5    Filme Antigo    2000    Cinema
    Adicionar Filme Com Sucesso    5    Filme Novo    2024    Prime Video
    Detalhes Devem Ser    5    Filme Novo    2024    Prime Video

Detalhar Filme Hot Com Indicador
    [Documentation]    Deve exibir o emoji de hot quando o filme esta na HotList.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Atribuir Hot    1    1
    Detalhes Devem Ser    1    Anatomia de uma Queda    2023    Cinema    hot=${True}

Detalhar Filme Apos Remover Hot
    [Documentation]    Deve voltar a exibir detalhes sem indicador hot.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    1    Anatomia de uma Queda    2023    Cinema
    Atribuir Hot    1    1
    Remover Hot    1
    Detalhes Devem Ser    1    Anatomia de uma Queda    2023    Cinema

Detalhar Filme Na Ultima Posicao Valida
    [Documentation]    Deve detalhar filme cadastrado na posicao 100.
    [Setup]    Criar Fachada Limpa
    Adicionar Filme Com Sucesso    100    Duna Parte 2    2024    Cinema
    Detalhes Devem Ser    100    Duna Parte 2    2024    Cinema

Detalhar Filme Em Posicao Zero Deve Falhar
    [Documentation]    Posicao 0 esta fora do limite permitido (1 a 100).
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Detalhar Filme    0

Detalhar Filme Em Posicao Acima De 100 Deve Falhar
    [Documentation]    Posicao 101 esta fora do limite permitido (1 a 100).
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Detalhar Filme    101

Detalhar Filme Em Posicao Negativa Deve Falhar
    [Documentation]    Posicoes negativas sao invalidas.
    [Setup]    Criar Fachada Limpa
    Run Keyword And Expect Error    *    Detalhar Filme    -1
