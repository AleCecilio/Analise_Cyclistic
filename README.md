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
* evolução temporal.

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

| Arquivo                   | Análise                                 |
| ------------------------- | --------------------------------------- |
| `01_user_profile.sql`     | Perfil e características dos usuários   |
| `02_weekly_usage.sql`     | Utilização ao longo da semana           |
| `03_hourly_usage.sql`     | Utilização ao longo do dia              |
| `04_ride_duration.sql`    | Duração das viagens                     |
| `05_station_analysis.sql` | Estações e relações de origem e destino |

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
* distribuição por período do dia.

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
* estações mais utilizadas por grupo;
* relações entre origem e destino;
* possíveis diferenças de localização entre `members` e `casuals`.

---

# Principais Resultados

A análise ainda está em desenvolvimento, mas os resultados obtidos até o momento apresentam alguns padrões relevantes.

## Utilização ao longo da semana

No conjunto dos dados, o sábado apresenta a maior participação das viagens, com **15,62%**, enquanto o domingo apresenta a menor, com **12,53%**.

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

Os `members` apresentam maior volume durante a tarde e manhã, enquanto os `casuals` apresentam maior participação relativa durante a tarde e noite.

Esses padrões são compatíveis com diferentes formas de utilização, mas os dados de horário e dia da semana, isoladamente, não permitem determinar a finalidade das viagens.

---

## Duração das viagens

A duração média apresenta variações ao longo da semana, mas permanece dentro de uma faixa relativamente próxima.

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

## Interpretação inicial

Os resultados obtidos até o momento indicam diferenças consistentes entre os grupos em diferentes dimensões:

* `members` apresentam maior concentração de viagens nos dias úteis;
* `casuals` possuem participação relativamente maior nos finais de semana;
* ambos apresentam pico de utilização às 17h;
* `casuals` apresentam viagens com maior duração média;
* `members` apresentam maior concentração de viagens de até 10 minutos;
* a duração dos `members` varia menos entre dias e períodos;
* as diferenças de duração são mais acentuadas entre os `casuals`.

Esses padrões ajudam a caracterizar os grupos, mas não permitem, isoladamente, determinar o motivo ou finalidade de cada viagem. A análise das estações, origens, destinos e evolução temporal será utilizada para complementar essa interpretação.

---

## Próximas Etapas

O projeto encontra-se na etapa final da análise exploratória com SQL.

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
* [x] Análise da duração das viagens.

### Em andamento

* [ ] Análise das estações;
* [ ] Consolidação dos principais insights;
* [ ] Desenvolvimento do dashboard no Power BI;
* [ ] Revisão final da documentação.

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

[Divvy Trip Data — Dados históricos de viagens](https://divvy-tripdata.s3.amazonaws.com/index.html)
