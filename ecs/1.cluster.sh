aws ecs create-cluster --cluster-name roboshop-cluster

aws servicediscovery create-private-dns-namespace \
  --name roboshop.local \
  --vpc vpc-07e30bcef51446692 \
  --description "Service discovery for RoboShop ECS"



