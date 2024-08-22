aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name mongo-service \
    --task-definition mongo \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-pqhbd5wmnk33g5za"

#This is my ServiceID: srv-pqhbd5wmnk33g5za