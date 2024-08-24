import boto3
import os
import sys
import time
from datetime import datetime, timezone
from time import gmtime, strftime

def database_find_strings_in_array(tags, array):
    
    found_schedule_tag = False
        
    schedule_array = tags[0]
    schedule_key = schedule_array[0]
    schedule_value = schedule_array[1]    

    environment_array = tags[1]
    environment_key = environment_array[0]
    environment_value = environment_array[1]

    
    ### check schedule tags
    for tag in array:
        if tag['Key']==schedule_key and tag['Value']==schedule_value:
            found_schedule_tag = True
    
    if found_schedule_tag:
        
        ### check environment tags
        for tag in array:
            if tag['Key']==environment_key and tag['Value']==environment_value:
                return True
    return False

def shut_rds_all():
    schedule_key=os.environ['schedule_key']
    schedule_value=os.environ['schedule_value']

    environment_key=os.environ['environment_key']
    environment_value=os.environ['environment_value']

    tags = [[schedule_key,schedule_value],[environment_key,environment_value]]
    
    client = boto3.client('rds')
    response = client.describe_db_instances()
    
    v_readReplica=[]
    for i in response['DBInstances']:
        readReplica=i['ReadReplicaDBInstanceIdentifiers']
        v_readReplica.extend(readReplica)
    
    for i in response['DBInstances']:
        #The if condition below filters aurora clusters from single instance databases as boto3 commands defer to stop the aurora clusters.
        if i['Engine'] not in ['aurora-mysql','aurora-postgresql']:
            
            #The if condition below filters Read replicas.
            if i['DBInstanceIdentifier'] not in v_readReplica and len(i['ReadReplicaDBInstanceIdentifiers']) == 0:
                arn=i['DBInstanceArn']
                resp2=client.list_tags_for_resource(ResourceName=arn)

                #check if the RDS instance is part of the Auto-Shutdown group.
                if 0==len(resp2['TagList']):
                    print('DB Instance {0} is not part of autoshutdown'.format(i['DBInstanceIdentifier']))
                else:
                    
                    if database_find_strings_in_array(tags,resp2['TagList']):
                                                
                        if i['DBInstanceStatus'] == 'available':
                            client.stop_db_instance(DBInstanceIdentifier = i['DBInstanceIdentifier'])
                            print('stopping DB instance {0}'.format(i['DBInstanceIdentifier']))
                        elif i['DBInstanceStatus'] == 'stopped':
                            print('DB Instance {0} is already stopped'.format(i['DBInstanceIdentifier']))
                        elif i['DBInstanceStatus']=='starting':
                            print('DB Instance {0} is in starting state. Please stop the cluster after starting is complete'.format(i['DBInstanceIdentifier']))
                        elif i['DBInstanceStatus']=='stopping':
                            print('DB Instance {0} is already in stopping state.'.format(i['DBInstanceIdentifier']))
                            
                    elif not database_find_strings_in_array(tags,resp2['TagList']):
                        print('DB instance {0} is not part of autoshutdown'.format(i['DBInstanceIdentifier']))
                            
            elif i['DBInstanceIdentifier'] in v_readReplica:
                print('DB Instance {0} is a Read Replica. Cannot shutdown a Read Replica instance'.format(i['DBInstanceIdentifier']))
            else:
                print('DB Instance {0} has a read replica. Cannot shutdown a database with Read Replica'.format(i['DBInstanceIdentifier']))

    response=client.describe_db_clusters()
    for i in response['DBClusters']:
        cluarn=i['DBClusterArn']
        resp2=client.list_tags_for_resource(ResourceName=cluarn)
        if 0==len(resp2['TagList']):
            print('DB Cluster {0} is not part of autoshutdown'.format(i['DBClusterIdentifier']))
        else:

            if database_find_strings_in_array(tags,resp2['TagList']):
                if i['Status'] == 'available':
                    client.stop_db_cluster(DBClusterIdentifier=i['DBClusterIdentifier'])
                    print('stopping DB cluster {0}'.format(i['DBClusterIdentifier']))
                elif i['Status'] == 'stopped':
                    print('DB Cluster {0} is already stopped'.format(i['DBClusterIdentifier']))
                elif i['Status']=='starting':
                    print('DB Cluster {0} is in starting state. Please stop the cluster after starting is complete'.format(i['DBClusterIdentifier']))
                elif i['Status']=='stopping':
                    print('DB Cluster {0} is already in stopping state.'.format(i['DBClusterIdentifier']))

            elif not database_find_strings_in_array(tags,resp2['TagList']):
                print('DB Cluster {0} is not part of autoshutdown'.format(i['DBClusterIdentifier']))
            else:
                print('DB Instance {0} is not part of auroShutdown'.format(i['DBClusterIdentifier']))

def lambda_handler(event, context):
    shut_rds_all()