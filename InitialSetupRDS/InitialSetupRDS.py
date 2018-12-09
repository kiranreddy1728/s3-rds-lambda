import sys
import boto3
import logging
import pymysql
import config
import os



def handler (eveent, context):
        #rds settings
        rds_host  = os,environ['host']
        username = config.db_username
        db_name = config.db_name
        password=os.environ['password']

        s3 = boto3.client('s3')
        logger = logging.getlogger()
        logger.setLevel(logging.INFO)



        conn = pymysql.connect(rds_host, user='admin',  passwd=password, db='offers', connect_timeout=5)
        logger.info("SUCCESS: Connection to RDS mysql instance succeeded")

        query1 = 'CREATE TABLE 'offers'  ( 'device_id' varchar(200) CHARACTER SET utf8 NOT NULL,  'offer_code' varchar(100) NOT NULL,  'offers_rank' int(11) DEFAULT NULL,  PRIMARY KEY ('device_id','offer_code')) ENGINE=InnoDB DEFAULT CHARSET=latin1;'
        query2 = 'CREATE USER \'lambda\' IDENTIFIED WITH AWSAuthenticationPlugin as \'RDS\';'
        query3 = 'update mysql.user set Select_priv=\'Y\',Insert_priv=\'Y\',Update_priv=\'Y\',Delete_priv=\'Y\',Creat_priv=\'Y\',Drop_priv=\'Y\',Reload_priv=\'Y\',Shutdown_priv=\'N\',Process_priv=\'Y\',File_priv=\'N\',Grant_priv=\'Y\',References_priv=\'Y\',Index_priv=\'Y\',Alter_priv=\'Y\',Show_db_priv=\'Y\',Super_priv=\'N\',Create_tmp_table_priv=\'y\',Lock_tables_priv=\'Y\',Execute-priv=\'Y\',Repl_slave_priv=\'N\',Repl_client_priv=\'N\',Creatr_view_priv=\'Y\',Show_view_priv=\'Y\',Create_routine_priv=\'Y\',Alter_routine_priv=\'Y\',Create_user_priv=\'Y\',Event_priv=\'Y\',Trigger_priv=\'Y\',Create_tablespace_priv=\'N\',password_expired=\'N\',Load_from_S3_priv=\'Y\',Select_into_S3_priv=\'Y\',Invoke_lamdba_priv=\'N\'where user=\'lamdba\';'
        query4 = 'GRANT ALL PRIVILEGES ON dboffers.* To \'lamdba\'@\'%\';'
        query5 = 'FLUSH PRIVILEGES;'

        with conn.cursor() as cur:
            cur.execute(query1);
            cur.execute(query2);
            cur.execute(query3);
            cur.execute(query4);
            cur.execute(query5);

        conn.commit()

        return "Initial set up is done" 

        