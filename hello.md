1. Create ECS cluster Name: instana
   aws ecs create-cluster --cluster-name instana
2. Create IAM Role for ECS Cluster InstanaECSCluster
   assume.json
   {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
   }
   
   assume.sh
   aws iam put-role-policy --role-name InstanaECSCluster --policy-name ecsTaskExecutionPolicy --policy-document file://policy.json
   
   policy.json
   {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        "Resource": "*"
       }
      ]
   }

   aws iam create-role --role-name InstanaECSCluster --assume-role-policy-document file://assume.json

3. Create log groups for all your micro services
logs.sh
#!/bin/bash
aws logs create-log-group --log-group-name /ecs/mongo
aws logs create-log-group --log-group-name /ecs/rabbit
aws logs create-log-group --log-group-name /ecs/redis
aws logs create-log-group --log-group-name /ecs/catalogue
aws logs create-log-group --log-group-name /ecs/cart
aws logs create-log-group --log-group-name /ecs/dispatch
aws logs create-log-group --log-group-name /ecs/payment
aws logs create-log-group --log-group-name /ecs/shipping
aws logs create-log-group --log-group-name /ecs/user
aws logs create-log-group --log-group-name /ecs/web
4. Actually I creare mysql RDS instan so did not create any log group for mysql Now this  create RDS instance
#!/bin/bash
# Variables
DB_INSTANCE_IDENTIFIER="instana"
DB_INSTANCE_CLASS="db.t3.micro"
ENGINE="mysql"
ALLOCATED_STORAGE=20
MASTER_USERNAME="root"
MASTER_USER_PASSWORD="RoboShop1"
ZONE_NAME="ullagallu.cloud"
DOMAIN_NAME="rb-mysql.${ZONE_NAME}"
DB_INSTANCE_ENDPOINT=""

# Get the hosted zone ID for the specified zone name
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name --dns-name $ZONE_NAME --query "HostedZones[0].Id" --output text)

# Check if RDS instance already exists
DB_INSTANCE_EXISTS=$(aws rds describe-db-instances --db-instance-identifier $DB_INSTANCE_IDENTIFIER --query "DBInstances[0].DBInstanceIdentifier" --output text 2>/dev/null)

if [ "$DB_INSTANCE_EXISTS" == "$DB_INSTANCE_IDENTIFIER" ]; then
    echo "RDS instance already exists. Skipping creation."
else
    # Create RDS instance
    aws rds create-db-instance \
        --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
        --db-instance-class $DB_INSTANCE_CLASS \
        --engine $ENGINE \
        --allocated-storage $ALLOCATED_STORAGE \
        --master-username $MASTER_USERNAME \
        --master-user-password $MASTER_USER_PASSWORD

    # Wait for the DB instance to be available
    echo "Waiting for RDS instance to become available..."
    aws rds wait db-instance-available --db-instance-identifier $DB_INSTANCE_IDENTIFIER
fi

# Get the endpoint of the RDS instance
DB_INSTANCE_ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
    --query "DBInstances[0].Endpoint.Address" \
    --output text)

# Check if Route 53 record already exists
RECORD_EXISTS=$(aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --query "ResourceRecordSets[?Name == '$DOMAIN_NAME.']" --output text)

if [ -n "$RECORD_EXISTS" ]; then
    echo "Route 53 record already exists. Skipping creation."
else
    # Create a Route 53 record
    aws route53 change-resource-record-sets \
        --hosted-zone-id $HOSTED_ZONE_ID \
        --change-batch '{
          "Changes": [{
            "Action": "CREATE",
            "ResourceRecordSet": {
              "Name": "'"$DOMAIN_NAME"'",
              "Type": "CNAME",
              "TTL": 300,
              "ResourceRecords": [{"Value": "'"$DB_INSTANCE_ENDPOINT"'"}]
            }
          }]
        }'
fi

echo "RDS instance and Route 53 record setup complete."

5. create namespaces it will create private hosted zone
#!/bin/bash
aws servicediscovery create-private-dns-namespace \
    --name instana \
    --vpc vpc-0f82095ba1b38b677

echo "Here are the ns avaialable"
aws servicediscovery list-namespaces

6. Here we are creating cloud map entries
cm.create.sh
#!/bin/bash
aws servicediscovery create-service \
    --name mongo \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name redis \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name rabbit \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name catalogue \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name cart \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name user \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name shipping \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name payment \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name web \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name debug \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery list-services \
    --query "Services[*].[Id,Name]" \
    --output table
replace namespace ID with step 5 output

7. Now create task definitions for each and every micro services

mongo.sh

```bash
#!/bin/bash
aws ecs register-task-definition \
    --family mongo \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "mongo",
            "image": "siva9666/mongo-instana:v1",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 27017,
                    "hostPort": 27017,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/mongo",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
```
redis.sh

```bash
#!/bin/bash
aws ecs register-task-definition \
    --family redis \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "redis",
            "image": "siva9666/redis-instana:v1",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 6379,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/redis",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
```

rabbit.sh
```bash
#!/bin/bash
aws ecs register-task-definition \
    --family rabbit \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "rabbit",
            "image": "siva9666/rabbit-instana:v1",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 5671,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/rabbit",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
```

catalogue.sh
```bash
#!/bin/bash
aws ecs register-task-definition \
    --family catalogue \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "catalogue",
            "image": "siva9666/catalogue-instana:v1",
            "essential": true,
            "environment": [
                {
                    "name": "MONGO",
                    "value": "true"
                },
                {
                    "name": "MONGO_URL",
                    "value": "mongodb://mongo.instana:27017/catalogue"
                }
            ],
            "portMappings": [
                {
                    "containerPort": 8080,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/catalogue",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
```
  
user.sh

```bash
#!/bin/bash
aws ecs register-task-definition \
    --family user \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "user",
            "image": "siva9666/user-instana:v1",
            "essential": true,
            "environment": [
                {
                    "name": "MONGO",
                    "value": "true"
                },
                {
                    "name": "MONGO_URL",
                    "value": "mongodb://mongo.instana:27017/users"
                },
                {
                    "name": "REDIS_HOST",
                    "value": "redis.instana"
                }
            ],
            "portMappings": [
                {
                    "containerPort": 8080,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/user",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
```

cart.sh

```bash
#!/bin/bash
aws ecs register-task-definition \
    --family cart \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "cart",
            "image": "siva9666/cart-instana:v1",
            "essential": true,
            "environment": [
                {
                    "name": "CATALOGUE_HOST",
                    "value": "catalogue.instana"
                },
                {
                    "name": "CATALOGUE_PORT",
                    "value": "8080"
                },
                {
                    "name": "REDIS_HOST",
                    "value": "redis.instana"
                }
            ],
            "portMappings": [
                {
                    "containerPort": 8080,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/cart",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
```

shipping.sh

```bash
#!/bin/bash
aws ecs register-task-definition \
    --family cart \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "cart",
            "image": "siva9666/cart-instana:v1",
            "essential": true,
            "environment": [
                {
                    "name": "CATALOGUE_HOST",
                    "value": "catalogue.instana"
                },
                {
                    "name": "CATALOGUE_PORT",
                    "value": "8080"
                },
                {
                    "name": "REDIS_HOST",
                    "value": "redis.instana"
                }
            ],
            "portMappings": [
                {
                    "containerPort": 8080,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/cart",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'

```

payment.sh

```bash
#!/bin/bash
aws ecs register-task-definition \
    --family payment \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "payment",
            "image": "siva9666/payment-instana:v1",
            "essential": true,
            "environment": [
                {
                    "name": "CART_HOST",
                    "value": "cart.instana"
                },
                {
                    "name": "CART_PORT",
                    "value": "8080"
                },
                {
                    "name": "USER_HOST",
                    "value": "user.instana"
                },
                {
                    "name": "USER_PORT",
                    "value": "8080"
                },
                {
                    "name": "AMQP_HOST",
                    "value": "rabbit.instana"
                },
                {
                    "name": "AMQP_USER",
                    "value": "roboshop"
                },
                {
                    "name": "AMQP_PASS",
                    "value": "roboshop123"
                }
            ],
            "portMappings": [
                {
                    "containerPort": 8080,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/payment",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
```

dispatch.sh

```bash
#!/bin/bash
aws ecs register-task-definition \
    --family dispatch \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "dispatch",
            "image": "siva9666/dispatch-instana:v1",
            "essential": true,
            "environment": [
                {
                    "name": "AMQP_HOST",
                    "value": "rabbit"
                },
                {
                    "name": "AMQP_USER",
                    "value": "roboshop"
                },
                {
                    "name": "AMQP_PASS",
                    "value": "roboshop123"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/dispatch",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
```

web.sh

```bash
#!/bin/bash
aws ecs register-task-definition \
    --family web \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "web",
            "image": "siva9666/web-instana:v2",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 80,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/web",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
```

8. create service file now this actual deployment of your micro serivces in to ECS cluster

mongo.sh

```bash
#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name mongo-service \
    --task-definition mongo \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-urkzleffyiy52pzo"
```
redis.sh
```bash
#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name redis-service \
    --task-definition redis \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-62vkm352txfipy4t"
```

rabbit.sh

```bash
#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name rabbit-service \
    --task-definition rabbit \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-gvnnu75owlmdpjaz"
```

catalogue.sh

```bash
#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name catalogue-service \
    --task-definition catalogue \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-deyboiux25ylznqq"
```

user.sh

```bash
#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name user-service \
    --task-definition user \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-j4yin42lrhoynlgw"
```

```cart
#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name cart-service \
    --task-definition cart \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-44o77euxjge6opr5"
```

shipping.sh

```bash
#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name shipping-service \
    --task-definition shipping \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-essvcg6gtk3qprsx"
```

payment.sh

```bash
#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name payment-service \
    --task-definition payment \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-eeupqibwzaswxhdz"
```

dispatch.sh

```bash
#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name dispatch-service \
    --task-definition dispatch \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-l3y2q2sek2lz7ck5"
```

web.sh

```bash
#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name web-service \
    --task-definition web \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-ha6ortodbjaapihi"
```

