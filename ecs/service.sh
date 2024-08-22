aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name mongo-service \
    --task-definition mongo \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"

aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name mysql-service \
    --task-definition mysql \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"

aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name redis-service \
    --task-definition redis \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"
    

aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name rabbit-service \
    --task-definition rabbit \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"
    

aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name catalogue-service \
    --task-definition catalogue \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"
    


aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name user-service \
    --task-definition user \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"
    

aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name cart-service \
    --task-definition cart \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"
    

aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name shipping-service \
    --task-definition shipping \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"
    

aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name payment-service \
    --task-definition payment \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"
    

aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name dispatch-service \
    --task-definition dispatch \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0]}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"

aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name web-service \
    --task-definition web \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=$(aws servicediscovery list-services --query 'Services[?Name==`roboshop.local`].Arn' --output text)"

    


    

