aws ecs describe-tasks \
    --cluster roboshop-cluster \
    --tasks $(aws ecs list-tasks --cluster roboshop-cluster --service-name web-service --query 'taskArns[0]' --output text) \
    --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' \
    --output text

aws ec2 describe-network-interfaces \
    --network-interface-ids <network-interface-id> \
    --query 'NetworkInterfaces[0].Association.PublicIp' \
    --output text
