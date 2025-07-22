import pandas as pd
import boto3
import os
import time

def load_data(file_path):
    df = pd.read_csv(file_path)
    print(f"Loaded {len(df)} records.")
    return df

def transform_data(df):
    df = df.dropna(subset=['company', 'industry'])
    df['date'] = pd.to_datetime(df['date'], errors='coerce')
    df['country'] = df['location'].apply(lambda x: x.split(',')[-1].strip())
    return df

def upload_to_s3(df, bucket_name, key):
    s3 = boto3.client('s3')
    temp_file = '/tmp/cleaned_layoffs.csv'
    df.to_csv(temp_file, index=False)
    s3.upload_file(temp_file, bucket_name, key)
    print(f"Uploaded to s3://{bucket_name}/{key}")

if __name__ == '__main__':
    start = time.time()
    df_raw = load_data('data/layoffs.csv')
    df_clean = transform_data(df_raw)
    upload_to_s3(df_clean, 'your-s3-bucket', 'layoffs/cleaned_layoffs.csv')
    print(f"Pipeline completed in {round(time.time() - start, 2)}s")