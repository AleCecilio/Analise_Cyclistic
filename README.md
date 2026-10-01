# Analise_Cyclistic

## Sobre o Projeto

Este projeto apresenta uma análise de dados baseada no estudo de caso da **Cyclistic**, empresa fictícia utilizada no curso **Google Data Analytics**.

São utilizados dados históricos do sistema de compartilhamento de bicicletas **Divvy**, de Chicago, Illinois, com o objetivo de identificar padrões de utilização e diferenças de comportamento entre **members** e **casuals**.

O projeto percorre um fluxo completo de análise de dados, desde a exploração e preparação dos dados até a análise com SQL e posterior visualização no Power BI.

```text
Dados brutos
    ↓
Python + Pandas
    ↓
Exploração e limpeza
    ↓
Dataset processado
    ↓
PostgreSQL
    ↓
Análise com SQL
    ↓
Power BI
```

---

## Objetivo

O objetivo é analisar como os diferentes tipos de usuários utilizam o serviço e identificar diferenças relacionadas a:

* frequência de utilização;
* dias da semana;
* horários;
* duração das viagens;
* tipo de bicicleta;
* estações de origem e destino;
* rotas mais utilizadas.

A análise busca verificar se **members e casuals apresentam padrões de utilização distintos**, utilizando diferentes dimensões dos dados para sustentar essa investigação.

---

## Dados

Os dados utilizados são provenientes do **Divvy Trip Data**, disponibilizado publicamente pela Divvy.

### Período analisado

Foram utilizados 12 meses de dados:

**Setembro de 2025 a agosto de 2026.**

Os arquivos mensais foram consolidados com Python e Pandas em:

```text
cyclistic_202509_202608.csv
```

Após o tratamento, o dataset processado é salvo como:

```text
cyclistic_202509_202608_processed.csv
```

### Principais variáveis

Os dados originais contêm informações como:

* `ride_id` — identificador da viagem;
* `rideable_type` — tipo de bicicleta;
* `started_at` — início da viagem;
* `ended_at` — término da viagem;
* `start_station_name` — estação de origem;
* `start_station_id` — identificador da estação de origem;
* `end_station_name` — estação de destino;
* `end_station_id` — identificador da estação de destino;
* `start_lat` / `start_lng` — coordenadas de origem;
* `end_lat` / `end_lng` — coordenadas de destino;
* `member_casual` — tipo de usuário.

Durante o tratamento foram criadas:

* `ride_length` — duração da viagem em minutos;
* `day_of_week` — número correspondente ao dia da semana;
* `day_of_week_name` — nome do dia da semana;
* `hour` — hora de início da viagem.

---

## Estrutura do Projeto

```text
Analise_Cyclistic/

│
├── data/
│   ├── raw/
│   ├── raw_zip/
│   └── processed/
│
├── notebooks/
│   ├── 01_initial_exploration.ipynb
│   └── 02_data_cleaning.ipynb
│
├── sql/
│   ├── 01_user_profile.sql
│   ├── 02_weekly_usage.sql
│   ├── 03_hourly_usage.sql
│   ├── 04_ride_duration.sql
│   └── 05_station_analysis.sql
│
├── powerbi/
│   └── cyclistic_dashboard.pbix
│
├── .venv/
├── .env
├── README.md
├── requirements.txt
└── .gitignore
```

Os arquivos de dados e o `.env` são mantidos localmente e não são versionados no GitHub.

---

## Metodologia

### 1. Exploração inicial

A exploração foi realizada em Python utilizando Pandas, Jupyter Notebook e Sweetviz.

Foram analisados:

* estrutura dos arquivos mensais;
* quantidade de registros;
* tipos de dados;
* variáveis disponíveis;
* valores ausentes;
* duplicidades;
* consistência dos dados;
* diferenças entre os arquivos mensais.

Os arquivos foram posteriormente consolidados em um único dataset.

### 2. Limpeza e preparação

O processo de tratamento incluiu:

* tratamento de valores ausentes;
* identificação de registros duplicados;
* conversão das variáveis temporais;
* verificação de inconsistências;
* criação de variáveis derivadas;
* tratamento da duração das viagens;
* análise de valores atípicos;
* validação do dataset final.

#### Inconsistências temporais

Foram identificados 29 registros em que `ended_at` apresentava horário anterior a `started_at`.

Os registros estavam concentrados em **2 de novembro de 2025**, durante a transição do horário de verão em Chicago. A ocorrência foi considerada no cálculo da duração para evitar valores negativos.

#### Duração das viagens

Foram removidas viagens com:

```text
ride_length <= 1 minuto
```

e:

```text
ride_length > 1440 minutos
```

O limite superior corresponde a 24 horas.

Valores classificados como outliers pelo IQR não foram removidos automaticamente, considerando a assimetria da distribuição e a possibilidade de representarem viagens legítimas.

---

## PostgreSQL

O dataset processado é carregado no **PostgreSQL**, onde é armazenado na tabela:

```text
trips
```

O banco é utilizado como ambiente para a etapa analítica, permitindo realizar consultas sobre o dataset tratado.

Entre os recursos utilizados estão:

* agregações;
* `GROUP BY`;
* `CASE`;
* `FILTER`;
* `WITH`;
* funções de janela;
* `ROW_NUMBER()`;
* `PERCENTILE_CONT()`;
* `JOIN`;
* ordenação e filtragem.

---

## Análise SQL

As consultas foram organizadas por tema:

| Arquivo                   | Análise                               |
| ------------------------- | ------------------------------------- |
| `01_user_profile.sql`     | Perfil e características dos usuários |
| `02_weekly_usage.sql`     | Utilização ao longo da semana         |
| `03_hourly_usage.sql`     | Utilização ao longo do dia            |
| `04_ride_duration.sql`    | Duração das viagens                   |
| `05_station_analysis.sql` | Estações, origens, destinos e rotas   |

### Perfil dos usuários

São analisados:

* distribuição entre `members` e `casuals`;
* duração média e mediana;
* tipos de bicicleta utilizados;
* participação relativa de cada tipo de bicicleta.

### Utilização semanal

A análise considera:

* quantidade de viagens por dia;
* comparação entre dias úteis e finais de semana;
* comportamento de cada tipo de usuário;
* dia de maior utilização.

### Utilização horária

São analisados:

* volume de viagens por hora;
* comportamento horário de cada grupo;
* horário de maior utilização;
* distribuição por período do dia;
* relação entre período, tipo de dia e tipo de usuário.

### Duração das viagens

A análise considera:

* duração média e mediana por dia da semana;
* duração por hora;
* duração por período do dia;
* duração por dia e tipo de usuário;
* duração por período e tipo de usuário;
* duração por dia, hora e tipo de usuário;
* distribuição das viagens por faixas de duração.

### Estações

A análise de estações considera:

* principais estações de origem;
* principais estações de destino;
* composição das estações por tipo de usuário;
* estações mais utilizadas por dia da semana e tipo de usuário;
* estações associadas às maiores e menores durações médias;
* rotas mais utilizadas por tipo de usuário.

---

# Principais Resultados

A análise dos 12 meses de dados identificou diferenças entre `members` e `casuals` em relação à distribuição semanal, horários, duração das viagens, tipo de bicicleta e utilização das estações.

## Perfil dos usuários

A distribuição geral das viagens mostra maior volume de viagens realizadas por `members` do que por `casuals`.

Além da quantidade de viagens, também foi analisada a utilização dos diferentes tipos de bicicleta.

### Tipo de bicicleta

As bicicletas elétricas apresentam maior volume de utilização do que as bicicletas clássicas nos dois grupos.

| Tipo de usuário | Elétricas | Clássicas |
| --------------- | --------: | --------: |
| Casuals         | 1.514.975 |   565.859 |
| Members         | 2.608.278 | 1.262.365 |

Entre os `casuals`, foram registradas **1.514.975 viagens com bicicletas elétricas** e **565.859 com bicicletas clássicas**.

Entre os `members`, foram registradas **2.608.278 viagens com bicicletas elétricas** e **1.262.365 com bicicletas clássicas**.

Portanto, as bicicletas elétricas representam o maior volume de utilização nos dois grupos.

---

## Utilização ao longo da semana

No conjunto dos dados, o sábado apresenta a maior participação das viagens, com **15,62%**, enquanto o domingo apresenta **12,53%**.

Separando os grupos:

| Tipo de usuário | Dias úteis | Finais de semana |
| --------------- | ---------: | ---------------: |
| Members         |  2.968.134 |          902.509 |
| Casuals         |  1.307.763 |          773.071 |

O maior volume de viagens dos `members` ocorre na **quarta-feira**, enquanto o dos `casuals` ocorre no **sábado**.

Esse resultado mostra uma diferença na distribuição semanal dos grupos: os `members` apresentam maior concentração de viagens nos dias úteis, enquanto os `casuals` possuem participação relativamente maior nos finais de semana.

---

## Utilização ao longo do dia

**17h é o horário de maior utilização para ambos os grupos.**

```text
Members:  417.885 viagens
Casuals:  197.592 viagens
```

A distribuição por período do dia apresenta:

| Período   |   Members | Casuals |
| --------- | --------: | ------: |
| Tarde     | 1.643.820 | 941.247 |
| Manhã     | 1.151.763 | 433.873 |
| Noite     |   986.150 | 594.890 |
| Madrugada |    88.910 | 110.824 |

Os `members` apresentam maior volume durante a tarde e manhã, enquanto os `casuals` apresentam participação relativamente maior durante a tarde e noite.

Esses padrões são compatíveis com diferentes formas de utilização, mas os dados de horário e dia da semana, isoladamente, não permitem determinar a finalidade das viagens.

---

## Duração das viagens

A duração média apresenta variações ao longo da semana.

O sábado apresenta a maior média, com **16,90 minutos**, seguido pelo domingo, com **16,86 minutos**. A menor média ocorre na quarta-feira, com **12,68 minutos**.

Por hora, as maiores médias concentram-se principalmente entre **11h e 16h**, com o maior valor às **14h**, de **16,28 minutos**.

Por período do dia:

| Período   |     Média |   Mediana |
| --------- | --------: | --------: |
| Tarde     | 15,32 min | 10,14 min |
| Noite     | 14,08 min |  9,69 min |
| Madrugada | 13,90 min |  8,51 min |
| Manhã     | 13,17 min |  8,52 min |

### Duração por tipo de usuário

Os `casuals` apresentam duração média superior aos `members` em todos os dias analisados.

Entre os `casuals`:

* maior média: **domingo — 21,22 min**;
* menor média: **quarta-feira — 15,25 min**.

Entre os `members`:

* maior média: **sábado — 13,46 min**;
* menor média: **quarta-feira — 11,69 min**.

A variação entre os dias também é maior entre os `casuals`, enquanto os `members` apresentam durações mais próximas entre si.

O mesmo padrão aparece na análise por período: os `casuals` apresentam maior duração média em todos os períodos, com destaque para a tarde, enquanto os `members` apresentam médias mais próximas entre os períodos.

---

## Distribuição por faixa de duração

A maior parte das viagens concentra-se nas menores faixas de duração.

| Faixa           | Casuals | Members |
| --------------- | ------: | ------: |
| Até 10 min      |  44,28% |  57,03% |
| 11–20 min       |  30,38% |  28,76% |
| 21–30 min       |  11,72% |   8,77% |
| 31–60 min       |   9,62% |   4,79% |
| 61–120 min      |   3,17% |   0,47% |
| Mais de 120 min |   0,83% |   0,19% |

Os dois grupos apresentam forte concentração em viagens curtas, mas essa concentração é maior entre os `members`: **57,03%** das viagens desse grupo possuem até 10 minutos, contra **44,28%** entre os `casuals`.

Também é possível observar uma redução progressiva da participação conforme a duração aumenta.

---

## Análise das estações

A análise das estações mostrou diferenças claras na composição das principais estações de origem e destino.

### Principais estações de origem

Entre as estações com maior volume de viagens, algumas apresentam forte concentração de um dos grupos.

A **Navy Pier**, por exemplo, registra **66.991 viagens de início**, sendo **75,93% de casuals** e **24,07% de members**.

Em contraste, a **Canal St & Adams St** registra **61.279 viagens**, com **77,25% de members** e **22,75% de casuals**.

Outros exemplos:

| Estação                           |  Total | Members | Casuals |
| --------------------------------- | -----: | ------: | ------: |
| Navy Pier                         | 66.991 |  24,07% |  75,93% |
| Canal St & Adams St               | 61.279 |  77,25% |  22,75% |
| DuSable Lake Shore Dr & Monroe St | 56.235 |  27,94% |  72,06% |
| Dearborn Pkwy & Delaware Pl       | 55.111 |  70,65% |  29,35% |
| Kingsbury St & Kinzie St 2        | 46.625 |  76,35% |  23,65% |

As estações de destino apresentam composição semelhante. A **Navy Pier** também se destaca entre os destinos, com **66.720 viagens**, sendo **78,05% de casuals**.

### Estação mais utilizada por dia e tipo de usuário

A análise por dia da semana mostrou um padrão particularmente consistente:

* a **Navy Pier** é a principal estação de início dos `casuals` em todos os dias da semana;
* entre os `members`, a **Canal St & Adams St** ocupa a primeira posição de segunda a quinta-feira;
* entre sexta-feira, sábado e domingo, a **Dearborn Pkwy & Delaware Pl** é a principal estação de início dos `members`.

No sábado, a Navy Pier registra **13.299 viagens de início de casuals**, sendo o maior valor observado nessa análise.

Esses resultados mostram que a concentração das viagens nas estações não ocorre de maneira uniforme entre os dois grupos.

### Duração por estação

Também foram analisadas as estações com maiores e menores durações médias, considerando apenas estações com pelo menos 100 viagens.

Entre as maiores médias, destacam-se:

| Estação                            | Viagens |     Média |   Mediana |
| ---------------------------------- | ------: | --------: | --------: |
| Cumberland Ave & Catherine Ave     |     152 | 65,18 min | 34,28 min |
| Burnham Greenway & 112th St        |     150 | 43,94 min | 38,35 min |
| Mason Ave & Montrose Ave           |     262 | 41,57 min | 16,51 min |
| Public Rack - Justine St & 87th St |     172 | 41,36 min | 29,88 min |
| Karlov Ave & Madison St            |     121 | 41,29 min | 21,90 min |

Entre as menores médias:

| Estação                              | Viagens |    Média |  Mediana |
| ------------------------------------ | ------: | -------: | -------: |
| Public Rack - Pulaski Rd & 44th St   |     120 | 4,26 min | 3,02 min |
| Public Rack - Foster Ave & Drake Ave |     204 | 6,84 min | 2,86 min |
| University Ave & 65th St             |   3.504 | 7,64 min | 4,74 min |
| Public Rack - Lighthouse Beach       |   3.697 | 7,95 min | 5,90 min |
| University Ave & 57th St             |  37.499 | 8,01 min | 4,70 min |

A diferença entre média e mediana em algumas estações também indica a presença de distribuições assimétricas. Por exemplo, **Mason Ave & Montrose Ave** apresenta média de 41,57 minutos e mediana de 16,51 minutos.

Esses resultados descrevem diferenças de duração associadas às estações de início, mas não permitem afirmar que a estação seja a causa dessas diferenças.

### Rotas mais utilizadas

A análise das combinações entre estação de origem e destino revelou padrões diferentes entre os grupos.

Entre os `casuals`, aparecem com destaque diversas rotas envolvendo a **Navy Pier** e a **DuSable Lake Shore Dr & Monroe St**, além de várias viagens em que a estação de origem e destino é a mesma.

As principais rotas incluem:

* Navy Pier → Navy Pier: **9.482 viagens**;
* DuSable Lake Shore Dr & Monroe St → mesma estação: **8.148**;
* DuSable Lake Shore Dr & Monroe St → Navy Pier: **5.212**;
* Michigan Ave & Oak St → mesma estação: **3.509**.

Entre os `members`, as principais rotas apresentam maior presença de deslocamentos entre estações distintas, especialmente na região de **University Ave, Blackstone Ave e Ellis Ave**.

Entre elas:

* Blackstone Ave & 59th St → University Ave & 57th St: **3.421 viagens**;
* University Ave & 57th St → mesma estação: **3.362**;
* University Ave & 57th St → Blackstone Ave & 59th St: **3.232**;
* Ellis Ave & 60th St → University Ave & 57th St: **3.194**.

As viagens com a mesma estação de origem e destino aparecem nos dois grupos. Esse padrão pode ser descrito como uma característica das rotas observadas, mas não permite determinar, isoladamente, a finalidade da viagem.

---

## Interpretação Final

A análise dos 12 meses de dados apresenta diferenças consistentes entre `members` e `casuals` em diversas dimensões.

Os principais padrões identificados foram:

* `members` apresentam maior concentração de viagens nos dias úteis;
* `casuals` possuem participação relativamente maior nos finais de semana;
* sábado é o dia com maior participação geral das viagens;
* 17h é o horário de maior utilização para ambos os grupos;
* bicicletas elétricas apresentam maior volume de utilização do que bicicletas clássicas nos dois grupos;
* `casuals` apresentam maior duração média das viagens em todos os dias e períodos analisados;
* `members` apresentam maior concentração de viagens de até 10 minutos;
* a duração das viagens apresenta maior variação entre os `casuals`;
* algumas estações apresentam forte concentração de `casuals`, enquanto outras são predominantemente utilizadas por `members`;
* a Navy Pier se destaca entre as estações utilizadas por `casuals`;
* Canal St & Adams St e Dearborn Pkwy & Delaware Pl apresentam forte presença de `members`;
* as principais rotas diferem entre os grupos, com maior presença de determinadas regiões e combinações de estações para cada perfil.

Em conjunto, esses resultados mostram que os dois grupos apresentam **padrões de utilização distintos em relação ao momento, duração, tipo de bicicleta, localização e combinação entre estações**.

Ao mesmo tempo, os dados analisados não permitem determinar isoladamente a finalidade de cada viagem. Dessa forma, as conclusões são apresentadas como padrões observados no comportamento de utilização, evitando atribuir uma finalidade específica às viagens sem evidências adicionais.

---

## Próximas Etapas

A etapa de análise exploratória e analítica com SQL foi concluída.

### Concluído

* [x] Download e organização dos dados;
* [x] Exploração inicial;
* [x] Consolidação dos arquivos mensais;
* [x] Inspeção com Sweetviz;
* [x] Tratamento de valores ausentes;
* [x] Tratamento de duplicidades;
* [x] Padronização dos dados;
* [x] Tratamento de inconsistências temporais;
* [x] Criação das variáveis derivadas;
* [x] Tratamento da duração das viagens;
* [x] Validação do dataset;
* [x] Carregamento no PostgreSQL;
* [x] Análise do perfil dos usuários;
* [x] Análise semanal;
* [x] Análise horária;
* [x] Análise da duração das viagens;
* [x] Análise das estações;
* [x] Análise das principais rotas;
* [x] Consolidação dos principais insights.

### Próximas etapas

* [ ] Desenvolvimento do dashboard no Power BI;
* [ ] Revisão final da documentação;
* [ ] Publicação e apresentação dos resultados.

---

## Ferramentas

* **Python** — processamento e preparação dos dados;
* **Pandas** — manipulação e transformação;
* **NumPy** — operações numéricas;
* **Matplotlib / Seaborn** — visualização;
* **Sweetviz** — exploração automatizada;
* **Jupyter Notebook** — exploração e documentação;
* **PostgreSQL** — armazenamento e análise;
* **SQL** — análise dos dados;
* **Power BI** — visualização dos resultados;
* **Git / GitHub** — versionamento.

---

## Fonte dos Dados

**Divvy — Bike Share Trip Data**

Dados históricos de viagens disponibilizados publicamente pela Divvy:

[Divvy Trip Data](https://divvy-tripdata.s3.amazonaws.com/index.html)
