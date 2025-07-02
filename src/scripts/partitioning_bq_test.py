import pandas as pd
from google.cloud import bigquery

# --- 1. Inicialize o cliente do BigQuery ---
# Certifique-se de que suas credenciais estão configuradas (GOOGLE_APPLICATION_CREDENTIALS)
client = bigquery.Client()

# --- 2. Defina os IDs da sua tabela ---
project_id = "labs-vibra"
dataset_id = "anp_biomass_calculation_dataset"  # Substitua pelo ID do seu dataset
table_id = "b100_sales" # Substitua pelo nome da sua tabela particionada

# O ID completo da sua tabela no formato "projeto.dataset.tabela"
full_table_id = f"{project_id}.{dataset_id}.{table_id}"

# --- 3. Simule seus novos dados para MARÇO DE 2024 ---
# IMPORTANTE: Este DataFrame deve conter TODOS os dados de março de 2024
# que você deseja ter na sua partição. Se um dado existente em março não estiver aqui, ele será REMOVIDO.
df_novos_dados_marco = pd.DataFrame({
    'date': ['2024-03-01', '2024-03-05', '2024-03-10', '2024-03-15', '2024-03-20', '2024-03-25'],
    'company_base_cnpj': ['111.222.333/0001-01', '444.555.666/0001-02', '111.222.333/0001-01', '777.888.999/0001-03', '444.555.666/0001-02', '101.202.303/0001-04'],
    'company_name': ['Alpha Dist.', 'Beta Fuel', 'Alpha Dist.', 'Delta Energy', 'Beta Fuel', 'Gama Petro'],
    'volume_m3': [1500.0, 2800.0, 1650.0, 3100.0, 2950.0, 1200.0], # Novos volumes
    'producer_name': ['Prod X', 'Prod Y', 'Prod X', 'Prod Z', 'Prod Y', 'Prod W'],
    'producer_cnpj': ['P_X', 'P_Y', 'P_X', 'P_Z', 'P_Y', 'P_W']
})

df_dados_abril = pd.DataFrame({
    'date': ['2024-04-01', '2024-04-05', '2024-04-10', '2024-04-15', '2024-04-20', '2024-04-25'],
    'company_base_cnpj': ['111.222.333/0001-01', '444.555.666/0001-02', '111.222.333/0001-01', '777.888.999/0001-03', '444.555.666/0001-02',
    '101.202.303/0001-04'],
    'company_name': ['Alpha Dist.', 'Beta Fuel', 'Alpha Dist.', 'Delta Energy', 'Beta Fuel', 'Gama Petro'],
    'volume_m3': [22222.0, 11111.0, 1213650.0, 100.0, 2912350.0, 3000.0], # Novos volumes
    'producer_name': ['Prod X', 'Prod Y', 'Prod X', 'Prod Z', 'Prod Y', 'Prod W'],
    'producer_cnpj': ['P_X', 'P_Y', 'P_X', 'P_Z', 'P_Y', 'P_W']
})

# Converta a coluna 'date' para o tipo datetime do Pandas (essencial para o BigQuery)
df_novos_dados_marco['date'] = pd.to_datetime(df_novos_dados_marco['date'])
df_dados_abril['date'] = pd.to_datetime(df_dados_abril['date'])

# --- 4. Prepare o Job de Carga para BigQuery ---

# Define a partição alvo: Março de 2024. O formato é YYYYMM.
# Você pode obter isso dinamicamente do seu DataFrame ou definir explicitamente.
mes_alvo_decorator = df_novos_dados_marco['date'].dt.strftime('%Y%m').iloc[0] # Pega '202403'
mes_abril_decorator = df_dados_abril['date'].dt.strftime('%Y%m').iloc[0] # Pega '202404'

# Constrói o ID completo da tabela de destino, incluindo o decorator da partição
destination_table_id_with_partition = f"{full_table_id}${mes_alvo_decorator}"
destination_table_id_with_partition_abril = f"{full_table_id}${mes_abril_decorator}"

print(f"Preparando para sobrescrever a partição: {destination_table_id_with_partition}")
print(f"DataFrame a ser carregado tem {len(df_novos_dados_marco)} linhas.")

job_config = bigquery.LoadJobConfig(
    write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE, # <--- ESSENCIAL: SOBRESCREVER esta partição
    # Se você quiser garantir o esquema, pode defini-lo aqui explicitamente:
    schema=[
        bigquery.SchemaField("date", "DATE", mode="NULLABLE"),
        bigquery.SchemaField("company_base_cnpj", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("company_name", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("volume_m3", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("producer_name", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("producer_cnpj", "STRING", mode="NULLABLE"),
    ]
)

# --- 5. Carregue os dados para o BigQuery ---
try:
    # load_job = client.load_table_from_dataframe(
    #     df_novos_dados_marco, destination_table_id_with_partition, job_config=job_config
    # )

    load_job = client.load_table_from_dataframe(
        df_dados_abril, destination_table_id_with_partition_abril, job_config=job_config
    )



    load_job.result() # Aguarda a conclusão da carga
    print(f"\nSucesso! Dados para Março de 2024 (partição {mes_alvo_decorator}) foram carregados e sobrescritos.")
    print(f"Total de linhas carregadas: {load_job.output_rows}")

except Exception as e:
    print(f"\nOcorreu um erro durante a carga: {e}")
    # Detalhes do erro podem ser encontrados em load_job.errors se o job for criado
    # mas falhar na execução assíncrona.