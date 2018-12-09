import sys
import boto3
import logging
import pymysql
import config
import json
import os

#rds settings


def handler(event, context):
    param = event['params']
    cust_id = param['path']['id']

    rds_host  = os.environ['host']
    username = config.db_username
    db_name = config.db_name

    s3 = boto3.client('s3')
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    client = boto3.client('rds',region_name='en-west-1')
    token = client.generate_db_auth_token(rds_host,3306, username)
    ssl = {'ca': 'rds-combined-ca-bundle,pem'}

    try:
        conn = pymysql.connect(rds_host, user=username,  passwd=token,db=db_name, connect_timeout=5,ssl=ssl)
        conn.autocommit = True
        print("Connection with DB done")
    except Excption as e:
        print(e):

    try:
        with conn.cursor() as cur:
            print("select offer_code from offers WHERE device_id = %s",(cust_id))
            cur.execute("select offer_code from offers WHERE device_id = %s order by offers_rank",(cust_id));
            offer_list =[]
            for result in cur.fetchall():
                offer_list.append(result[0])
            cur.close()
    except Excption as e:
        print(e)
        return ""

    return {
                "deviceID" : cust_id,
                "offers" : offer_list
        }
        