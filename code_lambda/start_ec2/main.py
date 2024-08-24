import boto3
import os
import sys
import time
from datetime import datetime, timezone
from time import gmtime, strftime

def start_ec2_instance(instance_ids):
    ec2client = boto3.client('ec2')
    ec2client.start_instances( InstanceIds=[instance_ids] )
    
def list_instances_by_tag_value(tags):
    
    tags_schedule_status = tags[0]
    tags_environment_status = tags[1]
    
    # When passed a tag key, tag value this will return a list of InstanceIds that were found.
    ec2client = boto3.client('ec2')

    response = ec2client.describe_instances(
        Filters=[
            {
                'Name': 'tag:'+tags_schedule_status[0],
                'Values': [tags_schedule_status[1]]
            },
            {
                'Name': 'tag:'+tags_environment_status[0],
                'Values': [tags_environment_status[1]]
            }
        ]
    )
    
    instancelist = []
    for reservation in (response["Reservations"]):
        for instance in reservation["Instances"]:
            instancelist.append(instance["InstanceId"])
    return instancelist

def start_ec2_all():
    schedule_key=os.environ['schedule_key']
    schedule_value=os.environ['schedule_value']

    environment_key=os.environ['environment_key']
    environment_value=os.environ['environment_value']

    tags = [[schedule_key,schedule_value],[environment_key,environment_value]]
    
    if len(list_instances_by_tag_value(tags)) > 0:
        for instance_id in list_instances_by_tag_value(tags):
            start_ec2_instance(instance_id)
                
def lambda_handler(event, context):
    start_ec2_all()