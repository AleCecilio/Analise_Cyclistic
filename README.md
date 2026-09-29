# Analise_Cyclistic

## Sobre o Projeto

Este projeto consiste em uma análise de dados baseada no estudo de caso da **Cyclistic**, empresa fictícia utilizada no curso **Google Data Analytics**.

A análise utiliza dados históricos de viagens do sistema de compartilhamento de bicicletas **Divvy**, de Chicago, Illinois, EUA, com o objetivo de identificar padrões de utilização e diferenças no comportamento entre os diferentes tipos de usuários.

O projeto utiliza **Python, Pandas, PostgreSQL, SQL e Power BI**, abrangendo etapas de exploração, limpeza, tratamento, análise e visualização dos dados.

O fluxo principal do projeto é:

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

O objetivo principal deste projeto é analisar o comportamento dos usuários do serviço de compartilhamento de bicicletas e identificar diferenças nos padrões de utilização entre **members** e **casuals**.

Entre os aspectos analisados estão:

* Perfil dos usuários;
* Frequência de utilização;
* Duração das viagens;
* Distribuição das viagens ao longo da semana;
* Distribuição das viagens ao longo do dia;
* Comportamento ao longo dos meses;
* Utilização das estações;
* Tipo de bicicleta utilizada;
* Diferenças de comportamento entre os tipos de usuários.

Além da análise descritiva, o projeto busca investigar a hipótese de que os diferentes tipos de usuários apresentam padrões de utilização distintos, especialmente em relação a **dias da semana, horários, duração das viagens e localização das estações**.

---

## Fontes de Dados

Os dados utilizados neste projeto são provenientes do conjunto **Divvy Trip Data**, disponibilizado publicamente pela Divvy, sistema de compartilhamento de bicicletas de Chicago, Illinois, EUA.

Os dados são disponibilizados mensalmente em arquivos CSV compactados em arquivos ZIP.

### Período Analisado

Foram utilizados os **12 meses de dados selecionados para o estudo de caso**, abrangendo:

**Setembro de 2025 a agosto de 2026.**

Arquivos utilizados:

```text
202509-divvy-tripdata.csv
202510-divvy-tripdata.csv
202511-divvy-tripdata.csv
202512-divvy-tripdata.csv
202601-divvy-tripdata.csv
202602-divvy-tripdata.csv
202603-divvy-tripdata.csv
202604-divvy-tripdata.csv
202605-divvy-tripdata.csv
202606-divvy-tripdata.csv
202607-divvy-tripdata.csv
202608-divvy-tripdata.csv
```

Os arquivos ZIP originais correspondentes foram utilizados para obtenção dos arquivos CSV.

### Convenção dos Nomes dos Arquivos

Os arquivos seguem o padrão:

```text
YYYYMM-divvy-tripdata.csv
```

Por exemplo:

```text
202509-divvy-tripdata.csv
```

representa os dados referentes a setembro de 2025.

O trecho `YYYYMM` corresponde a:

```text
YYYY = ano
MM   = mês
```

Assim:

```text
202509 → setembro de 2025
202510 → outubro de 2025
202511 → novembro de 2025
202512 → dezembro de 2025
202601 → janeiro de 2026
202602 → fevereiro de 2026
202603 → março de 2026
202604 → abril de 2026
202605 → maio de 2026
202606 → junho de 2026
202607 → julho de 2026
202608 → agosto de 2026
```

Os arquivos mensais são combinados utilizando **Python e Pandas**.

O dataset consolidado inicialmente é salvo como:

```text
cyclistic_202509_202608.csv
```

Após as etapas de limpeza e tratamento, o dataset processado é salvo como:

```text
cyclistic_202509_202608_processed.csv
```

---

## Variáveis dos Dados

Os arquivos originais contêm informações sobre as viagens realizadas pelos usuários, incluindo:

* `ride_id` — identificador da viagem;
* `rideable_type` — tipo de bicicleta utilizada;
* `started_at` — data e horário de início da viagem;
* `ended_at` — data e horário de término da viagem;
* `start_station_name` — nome da estação de início;
* `start_station_id` — identificador da estação de início;
* `end_station_name` — nome da estação de término;
* `end_station_id` — identificador da estação de término;
* `start_lat` — latitude da estação de início;
* `start_lng` — longitude da estação de início;
* `end_lat` — latitude da estação de término;
* `end_lng` — longitude da estação de término;
* `member_casual` — tipo de usuário.

Durante o processo de tratamento, também foram criadas variáveis derivadas:

* `ride_length` — duração da viagem em minutos;
* `day_of_week` — número correspondente ao dia da semana;
* `day_of_week_name` — nome do dia da semana;
* `hour` — hora de início da viagem.

---

## Estrutura do Projeto

```text
Analise_Cyclistic/

├── data/
│   ├── raw/
│   │   ├── 202509-divvy-tripdata.csv
│   │   ├── 202510-divvy-tripdata.csv
│   │   ├── 202511-divvy-tripdata.csv
│   │   ├── 202512-divvy-tripdata.csv
│   │   ├── 202601-divvy-tripdata.csv
│   │   ├── 202602-divvy-tripdata.csv
│   │   ├── 202603-divvy-tripdata.csv
│   │   ├── 202604-divvy-tripdata.csv
│   │   ├── 202605-divvy-tripdata.csv
│   │   ├── 202606-divvy-tripdata.csv
│   │   ├── 202607-divvy-tripdata.csv
│   │   └── 202608-divvy-tripdata.csv
│   │
│   ├── raw_zip/
│   │   └── arquivos ZIP originais
│   │
│   └── processed/
│       ├── cyclistic_202509_202608.csv
│       └── cyclistic_202509_202608_processed.csv
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

> **Observação:** os diretórios `data/raw/`, `data/raw_zip/` e `data/processed/` são mantidos localmente e não são versionados no GitHub devido ao grande volume dos arquivos. O arquivo `.env` também não é versionado por conter as credenciais de acesso ao banco de dados.

---

## Organização das Pastas

### `data/raw/`

Armazena os arquivos CSV originais, sem alterações, referentes aos meses analisados.

### `data/raw_zip/`

Armazena os arquivos ZIP originais disponibilizados pela fonte dos dados.

### `data/processed/`

Armazena os datasets consolidados e processados utilizados nas etapas posteriores da análise.

### `notebooks/`

Contém os notebooks utilizados para exploração e preparação dos dados.

#### `01_initial_exploration.ipynb`

Responsável pela exploração inicial dos arquivos mensais, incluindo:

* carregamento dos datasets;
* comparação entre os arquivos;
* análise da estrutura;
* identificação das variáveis;
* análise dos tipos de dados;
* inspeção inicial da qualidade dos dados;
* consolidação dos arquivos mensais.

#### `02_data_cleaning.ipynb`

Responsável pelo processo de limpeza e preparação do dataset consolidado.

As principais etapas realizadas incluem:

* tratamento de valores ausentes;
* identificação e tratamento de registros duplicados;
* conversão e padronização de datas;
* verificação de inconsistências;
* tratamento de registros com duração inválida;
* criação de variáveis derivadas;
* análise de valores atípicos;
* validação do dataset após o tratamento;
* geração do dataset processado;
* preparação dos dados para carregamento no PostgreSQL.

### `sql/`

Contém as consultas SQL utilizadas na etapa de análise.

As consultas estão separadas por tema:

* `01_user_profile.sql` — perfil e comportamento geral dos usuários;
* `02_weekly_usage.sql` — utilização ao longo da semana;
* `03_hourly_usage.sql` — utilização ao longo das horas do dia;
* `04_ride_duration.sql` — análise da duração das viagens;
* `05_station_analysis.sql` — análise das estações e padrões de utilização por localização.

As consultas são executadas sobre a tabela `trips` armazenada no PostgreSQL.

### `powerbi/`

Contém o dashboard desenvolvido no Power BI para apresentação dos principais resultados da análise.

### `.env`

Arquivo utilizado para armazenar localmente as configurações de conexão com o PostgreSQL, como usuário, senha, porta e nome do banco de dados.

Esse arquivo não é versionado no GitHub.

---

## Etapas da Análise

### 1. Exploração Inicial

A primeira etapa consiste na compreensão dos datasets disponibilizados pela Divvy.

Foram realizadas atividades como:

* carregamento dos arquivos mensais;
* comparação da estrutura dos datasets;
* identificação das variáveis;
* verificação dos tipos de dados;
* análise da quantidade de registros;
* identificação inicial de valores ausentes;
* consolidação dos arquivos mensais.

O **Sweetviz** foi utilizado como ferramenta auxiliar para inspeção exploratória automatizada.

Devido ao grande volume de registros, a geração do relatório exploratório utiliza uma amostra dos dados. As decisões de tratamento, entretanto, são realizadas considerando o dataset completo.

---

### 2. Limpeza e Tratamento dos Dados

Após a exploração inicial, foi realizado o processo de preparação dos dados.

Entre os procedimentos realizados estão:

* tratamento de valores ausentes;
* identificação e tratamento de registros duplicados;
* conversão das variáveis temporais;
* padronização dos dados;
* verificação de inconsistências;
* criação da duração das viagens;
* criação de variáveis temporais;
* análise de valores atípicos;
* validação do dataset final.

#### Tratamento de inconsistências temporais

Foram identificados registros em que `ended_at` apresentava um horário anterior a `started_at`.

Os registros encontrados estavam concentrados em **2 de novembro de 2025**, durante a transição do horário de verão em Chicago.

A ocorrência foi considerada no cálculo de `ride_length`, evitando que essas viagens fossem interpretadas como tendo duração negativa.

#### Tratamento da duração das viagens

A variável `ride_length` foi utilizada para identificar registros com duração excepcional.

Foram removidas viagens:

```text
ride_length <= 1 minuto
```

e

```text
ride_length > 1440 minutos
```

O limite superior de 1440 minutos corresponde a 24 horas.

A utilização de um limite de 1 minuto para viagens muito curtas foi adotada como critério operacional de preparação dos dados, enquanto o limite de 24 horas foi utilizado para excluir registros excepcionalmente longos.

Valores identificados como outliers pelo método do IQR não foram removidos automaticamente, pois a distribuição da duração das viagens apresenta assimetria à direita e muitos valores elevados podem representar viagens legítimas.

---

### 3. Armazenamento no PostgreSQL

Após o tratamento, o dataset processado é carregado em um banco de dados **PostgreSQL**.

A tabela principal utilizada na análise é:

```text
trips
```

O PostgreSQL foi escolhido como banco de dados analítico do projeto, permitindo a execução das consultas SQL utilizadas na etapa seguinte.

O processo de carregamento inclui:

* criação do banco de dados;
* criação da tabela `trips`;
* carregamento do dataset processado;
* validação da quantidade de registros;
* verificação da estrutura da tabela;
* validação dos dados carregados.

---

### 4. Análise com SQL

A etapa analítica é realizada principalmente utilizando **SQL no PostgreSQL**.

As consultas foram organizadas por temas para facilitar a interpretação dos resultados e demonstrar diferentes recursos da linguagem.

Entre os recursos utilizados estão:

* `GROUP BY`;
* agregações como `COUNT()` e `AVG()`;
* `FILTER`;
* `CASE`;
* `JOIN`;
* `WITH`;
* funções de janela;
* `ROW_NUMBER()`;
* `RANK()`;
* `PERCENTILE_CONT()`;
* ordenação e filtragem de resultados.

As análises incluem:

* distribuição entre members e casuals;
* duração média e mediana;
* utilização por tipo de bicicleta;
* distribuição por dia da semana;
* horários de maior utilização;
* estações de início e término;
* padrões de origem e destino;
* diferenças de comportamento entre os tipos de usuários.

---

## Hipóteses de Análise

Uma das principais hipóteses investigadas é que **members e casuals apresentam padrões de utilização diferentes**.

A hipótese considera que os members podem apresentar um padrão de uso mais associado à mobilidade urbana cotidiana, enquanto os casuals podem apresentar maior concentração em períodos e locais associados a lazer, turismo e atividades recreativas.

Essa hipótese não é assumida como conclusão. Ela será investigada considerando diferentes dimensões dos dados:

* dia da semana;
* horário;
* duração das viagens;
* tipo de bicicleta;
* estações de início;
* estações de término;
* relações entre origem e destino;
* comportamento ao longo dos meses.

A combinação dessas variáveis permite avaliar se os padrões observados são consistentes com a hipótese inicial.

---

## 5. Visualização no Power BI

Após a análise utilizando SQL, os principais resultados serão utilizados na construção de um dashboard no **Power BI**.

O dashboard deverá apresentar os principais indicadores e padrões encontrados durante a análise, permitindo comparar os comportamentos de **members** e **casuals**.

Entre os possíveis indicadores estão:

* quantidade total de viagens;
* participação de cada tipo de usuário;
* duração média e mediana;
* distribuição por dia da semana;
* distribuição por horário;
* tipo de bicicleta;
* principais estações;
* evolução temporal das viagens.

---

## Ferramentas Utilizadas

* **Python** — processamento e preparação dos dados;
* **Pandas** — manipulação, limpeza e transformação dos dados;
* **NumPy** — operações numéricas;
* **Matplotlib** — visualização de dados;
* **Seaborn** — visualização e análise exploratória;
* **Sweetviz** — inspeção exploratória automatizada;
* **Jupyter Notebook** — exploração, tratamento e documentação;
* **PostgreSQL** — armazenamento e análise dos dados;
* **SQL** — consultas e análise dos dados;
* **Power BI** — visualização e apresentação dos resultados;
* **Git e GitHub** — versionamento e documentação do projeto.

---

## Situação Atual do Projeto

O projeto encontra-se na etapa de **análise dos dados utilizando SQL**.

As principais etapas já concluídas são:

* [x] Download dos dados mensais;
* [x] Organização dos arquivos;
* [x] Exploração inicial;
* [x] Consolidação dos datasets;
* [x] Inspeção inicial com Sweetviz;
* [x] Tratamento de valores ausentes;
* [x] Tratamento de registros duplicados;
* [x] Padronização dos tipos de dados;
* [x] Tratamento de inconsistências temporais;
* [x] Criação de variáveis derivadas;
* [x] Tratamento de valores extremos de duração;
* [x] Validação do dataset processado;
* [x] Carregamento dos dados no PostgreSQL;
* [x] Estruturação das consultas SQL;
* [x] Análise inicial do perfil dos usuários;
* [ ] Finalização das análises SQL;
* [ ] Construção do dashboard no Power BI;
* [ ] Consolidação dos principais insights;
* [ ] Finalização da documentação dos resultados.

---

## Resultados

A análise encontra-se em andamento.

Os resultados finais serão apresentados nesta seção após a conclusão das consultas SQL e do dashboard no Power BI.

Entre os pontos que estão sendo investigados estão as diferenças de comportamento entre **members** e **casuals**, especialmente em relação a:

* frequência de utilização;
* dias da semana;
* horários;
* duração das viagens;
* tipo de bicicleta;
* estações utilizadas;
* padrões de origem e destino.

---

## Fonte dos Dados

**Divvy — Bike Share Trip Data**

Os dados são disponibilizados publicamente pela Divvy e utilizados neste projeto para fins de análise de dados e aprendizado.

[Divvy Trip Data — Dados históricos de viagens](https://divvy-tripdata.s3.amazonaws.com/index.html?utm_source=chatgpt.com)
