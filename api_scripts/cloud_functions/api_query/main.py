# final version - used in cloud function
import pandas as pd
from datetime import datetime, timedelta
import requests
import tempfile

from os import environ

from google.cloud import storage
import os
#os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="C:/Users/mirel/OneDrive/Documents/git_projects/pet_match/crendentials/pet-match-378611-6b43fb1dc6ee-service-account.json"

# if the function doesn´t have any argument we need to include self to use in google cloud function.
def api_call(self):
    # calling api
    pet_call = requests.get("https://www.zaragoza.es/sede/servicio/proteccion-animal.json?rows=10000")
    
    # transforming to a dataframe
    data = pd.json_normalize(pet_call.json(),record_path=["result"])

    # creating a new column with the complete foto address
    data["foto2"]="https://www.zaragoza.es"+data["foto"]

    # saving the csv (specify the temporary directory to save the csv tempfile.gettempdir())
    data.to_csv(tempfile.gettempdir() + "/" + "result_api" + '.csv', index = False)


    # saving into google cloud storage
    bucket_name = 'api_return' # do not give gs:// ,just bucket name
    local_path = tempfile.gettempdir() + "/" + "result_api" + '.csv' #local file path
    blob_path = datetime.today().strftime('%Y-%m-%d') + '/' + "result_api" + '.csv'
    
    bucket = storage.Client().bucket(bucket_name)
    blob = bucket.blob(blob_path)
    blob.upload_from_filename(local_path)


    return tempfile.gettempdir() + "/" + "result_api" + '.csv'