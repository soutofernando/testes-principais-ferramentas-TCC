# language: pt
Funcionalidade: Diario de Estudos

  Cenario: Testes do diario
    # Usuario adiciona anotacao e consulta pelo indice 0
    Quando adiciono anotacao texto "Estudei Java" data "17/06/2026"
    Entao espero "Estudei Java" pesquisaAnotacao index 0

    Quando adiciono anotacao texto "Nao estudei para Java" data "29/05/2026" avaliacao 7.5
    Entao espero "Nao estudei para Java" pesquisaAnotacao index 1

    Quando adiciono anotacao texto "Nao estudei para Java 2" data "29/05/2026" avaliacao 7.5
    Entao espero "INVALIDO" pesquisaAnotacao index 9999

    # Usuario lista todas as anotacoes
    Entao espero "Teste/2026 Data: 17/06/2026 Texto: Estudei Java Data: 29/05/2026 Texto: Nao estudei para Java Data: 29/05/2026 Texto: Nao estudei para Java 2" listarAnotacoes

    # Desempenho
    Quando adiciono anotacao texto "A" data "10/10/2010" avaliacao 6
    Entao espero 5.25 meuDesempenho

    Quando adiciono anotacao texto "A" data "10/10/2010"
    Entao espero 4.2 meuDesempenho

    # Compreensao
    Entao espero "MUITO BOM" statusCompreensao index 1
    Entao espero "MUITO BOM" statusCompreensao index 2
    Entao espero "ATENCAO!" statusCompreensao index 0
