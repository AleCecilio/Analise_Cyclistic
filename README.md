# Analise_Cyclistic

## Sobre o Projeto

Este projeto consiste em uma análise de dados baseada no estudo de caso da **Cyclistic**, empresa fictícia utilizada no curso **Google Data Analytics**.

A análise utiliza dados históricos de viagens do sistema de compartilhamento de bicicletas **Divvy**, de Chicago, Illinois, EUA, com o objetivo de identificar padrões de utilização e diferenças no comportamento entre os diferentes tipos de usuários.

O projeto foi desenvolvido utilizando **Python, Pandas, SQL e Power BI**, abrangendo etapas de exploração, limpeza, tratamento, análise e visualização dos dados.

## Objetivo

O objetivo principal deste projeto é analisar o comportamento dos usuários do serviço de compartilhamento de bicicletas e identificar padrões relacionados às viagens realizadas.

Entre os aspectos analisados estão:

* Perfil dos usuários;
* Frequência de utilização;
* Duração das viagens;
* Distribuição das viagens ao longo da semana;
* Distribuição das viagens ao longo do dia;
* Comportamento ao longo dos meses;
* Utilização das estações;
* Diferenças de comportamento entre os tipos de usuários.

A análise busca transformar os dados brutos em informações que possam contribuir para a compreensão do comportamento dos usuários.

## Fontes de Dados

Os dados utilizados neste projeto são provenientes do conjunto **Divvy Trip Data**, disponibilizado publicamente pela **Divvy**, sistema de compartilhamento de bicicletas de Chicago, Illinois, EUA.

Os dados são disponibilizados mensalmente em arquivos CSV, compactados em arquivos ZIP.

### Período Analisado

Foram utilizados os **12 meses mais recentes disponíveis**, abrangendo o período de:

**Setembro de 2025 a agosto de 2026.**

Os arquivos CSV utilizados são:

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

Os respectivos arquivos ZIP originais são:

```text
202509-divvy-tripdata.zip
202510-divvy-tripdata.zip
202511-divvy-tripdata.zip
202512-divvy-tripdata.zip
202601-divvy-tripdata.zip
202602-divvy-tripdata.zip
202603-divvy-tripdata.zip
202604-divvy-tripdata.zip
202605-divvy-tripdata.zip
202606-divvy-tripdata.zip
202607-divvy-tripdata.zip
202608-divvy-tripdata.zip
```

### Convenção dos Nomes dos Arquivos

Os arquivos originais seguem um padrão de nomenclatura que identifica o período e o tipo de dado.

Por exemplo:

```text
202509-divvy-tripdata.csv
```

O nome pode ser dividido em três partes:

```text
202509
  ↓
Ano e mês

divvy
  ↓
Sistema Divvy

tripdata
  ↓
Dados de viagens
```

O trecho `202509` utiliza o formato **YYYYMM**:

```text
YYYY = ano
MM   = mês
```

Portanto:

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

Dessa forma, `202509-divvy-tripdata.csv` representa os dados de viagens da Divvy referentes a **setembro de 2025**, enquanto `202608-divvy-tripdata.csv` representa os dados referentes a **agosto de 2026**.

Após o carregamento dos arquivos mensais, os datasets são combinados utilizando **Python e Pandas**.

O conjunto consolidado é salvo como:

```text
cyclistic_202509_202608.csv
```

O nome representa:

```text
cyclistic
    ↓
Projeto baseado no estudo de caso da Cyclistic

202509_202608
    ↓
Período exato dos dados consolidados
```

Assim, o nome do arquivo indica precisamente que o conjunto contém dados de **setembro de 2025 (`202509`) a agosto de 2026 (`202608`)**.

### Variáveis Disponíveis

Os arquivos contêm informações sobre as viagens realizadas pelos usuários do sistema, incluindo:

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
│   │   ├── 202509-divvy-tripdata.zip
│   │   ├── 202510-divvy-tripdata.zip
│   │   ├── 202511-divvy-tripdata.zip
│   │   ├── 202512-divvy-tripdata.zip
│   │   ├── 202601-divvy-tripdata.zip
│   │   ├── 202602-divvy-tripdata.zip
│   │   ├── 202603-divvy-tripdata.zip
│   │   ├── 202604-divvy-tripdata.zip
│   │   ├── 202605-divvy-tripdata.zip
│   │   ├── 202606-divvy-tripdata.zip
│   │   ├── 202607-divvy-tripdata.zip
│   │   └── 202608-divvy-tripdata.zip
│   │
│   └── processed/
│       ├── cyclistic_202509_202608.csv
│       └── cyclistic_202509_202608_processed.csv    
│
├── notebooks/
│   ├── 01_initial_exploration.ipynb
│   ├── 02_data_cleaning.ipynb
│   ├── 03_exploratory_analysis.ipynb
│   └── 04_sql_analysis.ipynb
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
├── README.md
├── requirements.txt
└── .gitignore
```

> **Observação:** Os diretórios `data/raw/`, `data/raw_zip/` e `data/processed/` são mantidos localmente e não são versionados no GitHub devido ao grande volume dos arquivos. O processamento e a consolidação dos dados podem ser reproduzidos por meio dos notebooks do projeto.

### Organização das Pastas

**`data/raw/`**

Armazena os arquivos CSV originais, sem alterações, referentes aos 12 meses analisados.

**`data/raw_zip/`**

Armazena os arquivos ZIP originais baixados da fonte de dados. Esses arquivos representam a versão original disponibilizada pela fonte antes da extração dos CSVs.

**`data/processed/`**

Armazena os dados consolidados e processados utilizados nas etapas seguintes da análise.

**`notebooks/`**

Contém os notebooks utilizados durante as diferentes etapas do projeto:

* `01_initial_exploration.ipynb` — exploração inicial e compreensão da estrutura dos dados;
* `02_data_cleaning.ipynb` — limpeza, tratamento e preparação dos dados;
* `03_exploratory_analysis.ipynb` — análise exploratória e identificação de padrões;
* `04_sql_analysis.ipynb` — análises utilizando SQL.

**`sql/`**

Contém as consultas SQL utilizadas no projeto, organizadas de acordo com os diferentes temas analisados.

**`powerbi/`**

Contém o dashboard desenvolvido no Power BI para apresentação dos resultados.

## Etapas da Análise

### 1. Exploração Inicial

Nesta etapa será realizada a análise inicial dos datasets, incluindo:

* Carregamento dos arquivos mensais;
* Verificação da estrutura dos dados;
* Identificação das variáveis;
* Verificação dos tipos de dados;
* Comparação entre os arquivos mensais;
* Consolidação dos datasets.

### 2. Limpeza e Tratamento

Nesta etapa serão identificados e tratados problemas relacionados à qualidade dos dados, incluindo:

* Valores ausentes;
* Registros duplicados;
* Tipos de dados incorretos;
* Inconsistências;
* Valores inválidos;
* Conversão das variáveis `started_at` e `ended_at` para `datetime`;
* Criação de variáveis relacionadas a data e horário;
* Cálculo da duração das viagens;
* Criação de novas variáveis para análise.

Antes do tratamento detalhado, será utilizado o **Sweetviz** como ferramenta auxiliar para uma inspeção inicial automatizada do conjunto de dados.

Devido ao grande volume de registros, o relatório exploratório será gerado utilizando uma amostra dos dados. As decisões de limpeza e tratamento, entretanto, serão realizadas sobre o conjunto completo.

### 3. Análise Exploratória

Após o tratamento dos dados, serão realizadas análises para identificar padrões de comportamento dos usuários.

Serão exploradas variáveis relacionadas a:

* Perfil do usuário;
* Duração das viagens;
* Horários;
* Dias da semana;
* Meses;
* Estações;
* Tipo de bicicleta.

### 4. Análise com SQL

Consultas SQL serão utilizadas para aprofundar a análise dos dados e responder perguntas específicas relacionadas ao comportamento dos usuários.

As consultas serão mantidas em arquivos `.sql` separados e executadas sobre o conjunto de dados consolidado.

### 5. Visualização no Power BI

Os principais resultados obtidos durante a análise serão utilizados na construção de um dashboard no **Power BI**.

O dashboard terá como objetivo apresentar os principais indicadores e padrões encontrados de forma visual e interativa.

## Ferramentas Utilizadas

* **Python** — processamento e análise dos dados;
* **Pandas** — manipulação e tratamento dos dados;
* **NumPy** — operações e cálculos numéricos;
* **Matplotlib** — visualização de dados;
* **Seaborn** — visualização e análise exploratória;
* **Sweetviz** — inspeção exploratória automatizada;
* **Jupyter Notebook** — desenvolvimento e documentação das análises;
* **SQL** — consultas e análise dos dados;
* **DuckDB** — execução das consultas SQL;
* **Power BI** — criação do dashboard e visualização dos resultados;
* **Git e GitHub** — versionamento e documentação do projeto.

## Resultados

Esta seção será atualizada após a conclusão das etapas de análise, apresentando os principais padrões, descobertas e conclusões obtidas a partir dos dados.

## Fonte dos Dados

**Divvy — Bike Share Trip Data**

Os dados são disponibilizados publicamente pela Divvy e utilizados neste projeto para fins de análise de dados e aprendizado.

**Link dos Dados:**

https://divvy-tripdata.s3.amazonaws.com/index.html
