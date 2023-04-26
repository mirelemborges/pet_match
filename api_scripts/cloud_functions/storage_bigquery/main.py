# final version - used in cloud function
# packages
from datetime import datetime, timedelta
from google.cloud import storage 
from google.cloud import bigquery
from os import environ
from google.cloud.bigquery.table import TableReference
import pandas as pd

#os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="C:/Users/mirel/OneDrive/Documents/git_projects/pet_match/crendentials/pet-match-378611-6b43fb1dc6ee-service-account.json"
#g_cred = environ.get("GOOGLE_APPLICATION_CREDENTIALS")

def storage_bigquery(self):
    ## listing files in the bucket
    storage_client = storage.Client()

    bucket = storage_client.get_bucket('api_return')

    blobs = bucket.list_blobs()

    list_files = []

    for blob in blobs:
        list_files.append(blob.name)

    # getting dates/dataset_name/table_name form the folders names
    dates = []             
    table_name = []
    for z in list_files:
        dates.append(datetime.strptime(z.split('/')[0], '%Y-%m-%d'))
        table_name.append(z.split('/')[1][:-4])

    # getting max
    max_date = max(dates).strftime('%Y-%m-%d')

    # create a data frame
    df = pd.DataFrame({
        'list_files': list_files,
        'dates': dates,
        'table_name': table_name
        })
    
    # filtering the df by the max date 
    df_filter = df[df['dates']==max_date]


    ## send the csv from Storage to Big Query
    client = bigquery.Client()

    # table ID
    table_id = 'pet-match-378611.pet_match.adoption_list_table'

    # delete the table
    client.delete_table(table_id, not_found_ok = True)
                
    # saving the csv into Big Query
    job_config = bigquery.LoadJobConfig(
        source_format = bigquery.SourceFormat.CSV, 
        skip_leading_rows = 1, 
        autodetect = True,
        allow_quoted_newlines = True
    )

    job = client.load_table_from_uri(
        ["gs://" + 'api_return' + "/" + df_filter['list_files'].iloc[0]],
        table_id,
        job_config = job_config
    )
    job.result()
    client.close()

    return job.state