# Pet Match

Repository intended to track the codes and process of the pet match app.

## Structure

The structure is build in Google Cloud platform, it has a Cloud Function
(python) responsible for obtain, clean and save a dateset obtained from
an API query of Comunidad de Zaragoza about pets available for adoption.
The function saves its results in a google cloud storage bucket named
“api\_return”. Also, it has another cloud function (python) intended to
update a bigquery table.
