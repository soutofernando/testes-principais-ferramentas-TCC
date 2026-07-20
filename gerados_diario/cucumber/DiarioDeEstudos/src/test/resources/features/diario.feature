# language: pt
Funcionalidade: Diario de Estudos

  Cenario: Estado inicial do diario
    # Facade padrao: dono Teste, ano 2026; diario sem anotacoes
    Entao espero 0 meuDesempenho
    Entao espero "Teste/2026" listarAnotacoes

  Cenario: Adicionar anotacao sem autoavaliacao
    # Caminho feliz: texto e data validos; avaliacao implicita 0
    Quando adiciono anotacao texto "Estudei Java" data "17/06/2026"
    Entao adicionar anotacao deve retornar true
    Entao espero "Estudei Java" pesquisaAnotacao index 0
    Entao espero 0 meuDesempenho

  Cenario: Adicionar anotacao com autoavaliacao
    # Caminho feliz: overload com avaliacao
    Quando adiciono anotacao texto "Estudei Java" data "17/06/2026"
    Quando adiciono anotacao texto "Nao estudei para Java" data "29/05/2026" avaliacao 7.5
    Entao adicionar anotacao deve retornar true
    Entao espero "Nao estudei para Java" pesquisaAnotacao index 1
    Entao espero 3.75 meuDesempenho

  Cenario: Terceira anotacao atualiza media para cinco
    Quando adiciono anotacao texto "Estudei Java" data "17/06/2026"
    Quando adiciono anotacao texto "Nao estudei para Java" data "29/05/2026" avaliacao 7.5
    Quando adiciono anotacao texto "Nao estudei para Java 2" data "29/05/2026" avaliacao 7.5
    Entao espero "Nao estudei para Java 2" pesquisaAnotacao index 2
    Entao espero 5 meuDesempenho

  Cenario: Pesquisa anotacao com indice invalido
    # Indice fora dos limites retorna INVALIDO
    Quando adiciono anotacao texto "Estudei Java" data "17/06/2026"
    Quando adiciono anotacao texto "Nao estudei para Java" data "29/05/2026" avaliacao 7.5
    Quando adiciono anotacao texto "Nao estudei para Java 2" data "29/05/2026" avaliacao 7.5
    Entao espero "INVALIDO" pesquisaAnotacao index 9999
    Entao espero "INVALIDO" pesquisaAnotacao index 3

  Cenario: Listar anotacoes no formato data e texto
    # Formato: dono/ano seguido das anotacoes (Data + Texto)
    Quando adiciono anotacao texto "Estudei Java" data "17/06/2026"
    Quando adiciono anotacao texto "Nao estudei para Java" data "29/05/2026" avaliacao 7.5
    Quando adiciono anotacao texto "Nao estudei para Java 2" data "29/05/2026" avaliacao 7.5
    Entao espero "Teste/2026 Data: 17/06/2026 Texto: Estudei Java Data: 29/05/2026 Texto: Nao estudei para Java Data: 29/05/2026 Texto: Nao estudei para Java 2" listarAnotacoes

  Cenario: Media de compreensao com autoavaliacao seis
    # Media aritmetica das autoavaliacoes; anotacao sem avaliacao conta como 0
    Quando adiciono anotacao texto "Estudei Java" data "17/06/2026"
    Quando adiciono anotacao texto "Nao estudei para Java" data "29/05/2026" avaliacao 7.5
    Quando adiciono anotacao texto "Nao estudei para Java 2" data "29/05/2026" avaliacao 7.5
    Quando adiciono anotacao texto "A" data "10/10/2010" avaliacao 6
    Entao espero 5.25 meuDesempenho

  Cenario: Media de compreensao com anotacao sem autoavaliacao
    Quando adiciono anotacao texto "Estudei Java" data "17/06/2026"
    Quando adiciono anotacao texto "Nao estudei para Java" data "29/05/2026" avaliacao 7.5
    Quando adiciono anotacao texto "Nao estudei para Java 2" data "29/05/2026" avaliacao 7.5
    Quando adiciono anotacao texto "A" data "10/10/2010" avaliacao 6
    Quando adiciono anotacao texto "A" data "10/10/2010"
    Entao espero 4.2 meuDesempenho

  Cenario: Status de compreensao por faixa
    # autoAvaliacao 0 ou ausente: ATENCAO! | (0,5]: REGULAR | (5,7]: BOM | (7,9): MUITO BOM | [9,10]: EXCELENTE
    Quando adiciono anotacao texto "Estudei Java" data "17/06/2026"
    Quando adiciono anotacao texto "Nao estudei para Java" data "29/05/2026" avaliacao 7.5
    Quando adiciono anotacao texto "Nao estudei para Java 2" data "29/05/2026" avaliacao 7.5
    Quando adiciono anotacao texto "A" data "10/10/2010" avaliacao 6
    Quando adiciono anotacao texto "A" data "10/10/2010"
    Entao espero "ATENCAO!" statusCompreensao index 0
    Entao espero "MUITO BOM" statusCompreensao index 1
    Entao espero "MUITO BOM" statusCompreensao index 2
    Entao espero "BOM" statusCompreensao index 3
    Entao espero "ATENCAO!" statusCompreensao index 4

  Cenario: Faixas de status nos limites exatos
    Quando adiciono anotacao texto "Limite regular" data "01/01/2026" avaliacao 5
    Entao espero "REGULAR" statusCompreensao index 0
    Quando adiciono anotacao texto "Limite bom inferior" data "02/01/2026" avaliacao 5.01
    Entao espero "BOM" statusCompreensao index 1
    Quando adiciono anotacao texto "Limite bom superior" data "03/01/2026" avaliacao 7
    Entao espero "BOM" statusCompreensao index 2
    Quando adiciono anotacao texto "Limite muito bom" data "04/01/2026" avaliacao 8.99
    Entao espero "MUITO BOM" statusCompreensao index 3
    Quando adiciono anotacao texto "Limite excelente inferior" data "05/01/2026" avaliacao 9
    Entao espero "EXCELENTE" statusCompreensao index 4
    Quando adiciono anotacao texto "Limite excelente superior" data "06/01/2026" avaliacao 10
    Entao espero "EXCELENTE" statusCompreensao index 5

  Cenario: Fluxo integrado consolidado
    # Cadastro, consultas, faixas de status e validacao final
    Quando adiciono anotacao texto "Estudei Java" data "17/06/2026"
    Quando adiciono anotacao texto "Nao estudei para Java" data "29/05/2026" avaliacao 7.5
    Quando adiciono anotacao texto "Nao estudei para Java 2" data "29/05/2026" avaliacao 7.5
    Entao espero "Estudei Java" pesquisaAnotacao index 0
    Entao espero "Nao estudei para Java" pesquisaAnotacao index 1
    Entao espero "Nao estudei para Java 2" pesquisaAnotacao index 2
    Entao espero "INVALIDO" pesquisaAnotacao index 9999
    Entao espero "INVALIDO" pesquisaAnotacao index 3
    Quando adiciono anotacao texto "A" data "10/10/2010" avaliacao 6
    Quando adiciono anotacao texto "A" data "10/10/2010"
    Entao espero "ATENCAO!" statusCompreensao index 0
    Entao espero "MUITO BOM" statusCompreensao index 1
    Entao espero "MUITO BOM" statusCompreensao index 2
    Entao espero "BOM" statusCompreensao index 3
    Entao espero "ATENCAO!" statusCompreensao index 4
    Quando adiciono anotacao texto "Limite regular" data "01/01/2026" avaliacao 5
    Quando adiciono anotacao texto "Limite bom inferior" data "02/01/2026" avaliacao 5.01
    Quando adiciono anotacao texto "Limite bom superior" data "03/01/2026" avaliacao 7
    Quando adiciono anotacao texto "Limite muito bom" data "04/01/2026" avaliacao 8.99
    Quando adiciono anotacao texto "Limite excelente inferior" data "05/01/2026" avaliacao 9
    Quando adiciono anotacao texto "Limite excelente superior" data "06/01/2026" avaliacao 10
    Entao espero "REGULAR" statusCompreensao index 5
    Entao espero "BOM" statusCompreensao index 6
    Entao espero "BOM" statusCompreensao index 7
    Entao espero "MUITO BOM" statusCompreensao index 8
    Entao espero "EXCELENTE" statusCompreensao index 9
    Entao espero "EXCELENTE" statusCompreensao index 10
    Entao espero "Limite excelente superior" pesquisaAnotacao index 10
    Entao espero "INVALIDO" pesquisaAnotacao index 11
    Entao espero "Teste/2026 Data: 17/06/2026 Texto: Estudei Java Data: 29/05/2026 Texto: Nao estudei para Java Data: 29/05/2026 Texto: Nao estudei para Java 2 Data: 10/10/2010 Texto: A Data: 10/10/2010 Texto: A Data: 01/01/2026 Texto: Limite regular Data: 02/01/2026 Texto: Limite bom inferior Data: 03/01/2026 Texto: Limite bom superior Data: 04/01/2026 Texto: Limite muito bom Data: 05/01/2026 Texto: Limite excelente inferior Data: 06/01/2026 Texto: Limite excelente superior" listarAnotacoes
    Entao espero 6 meuDesempenho
