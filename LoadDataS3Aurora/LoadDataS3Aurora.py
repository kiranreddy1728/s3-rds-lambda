import os
import boto3
import logging
import pymysql
import config
import json
import time

#rds settings


def handler(event, context):
    bucket_name = event['Record'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']

    rds_host = os.environ['host']
    username = config.db_username
    db_name = config.db_name

    s3 = boto3.client('s3')
    logger = logging.getlogger()
    logger.setLevel(logging.INFO)

    client = boto3.client('rds',region_name='eu-west-1')
    token = client.generate_db_auth_token(rds_host,3306, username)
    ssl = {'ca': 'rds-combined-ca-bundle.pem'}
    logger.info("token: "+ token)

    distribution = os.environ['CDNDistributionID']

    
    logger.info("SUCCESS: Connection to RDS mysql instance succeeded")

    print(bucket_name)
    print(file_key)

    file = 's3://' + bucket_name + '/' + file_key

    query = 'LOAD DATA FROM S3 \'' + file +'\' INTO TABLE offers fields terminated by \',\' lines terminated by \'\\'r\\n\' ignore 1 lines (device_id,offer_code,offers_rank);'
    print(query)

    try:
        conn = pymysql.connect(rds_host, user=username, passwd=token,db=db_name, connect_timeout=5,ssl=ssl)
        conn.autocommit = True
    except Exception as e:
        print(e)

    try:
        with conn.cursor() as cur:
            cur.executer("delete from offers;")
            time.sleep(10)
            cur.execute(query);
        conn.commit()
        print "Added items to RDS MYSQL table from file " + file

    except Exception as e:
        print(e)


    client = boto3.client('cloudfront')
    print(distribution)
    invalidation = client.create_invalidation(distributionId=distribution,
        invalidationBatch={
            'paths': {
                'Quantity': 1,
                'Items': ["/*"]
        },
        'CallerReference': str(time.time())
    })
    print(invalidation)
    print("Cache Cleared.")


return "Lamdba Executed"