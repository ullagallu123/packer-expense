- Aws Cli Commands to create
- ECS cluster creation
- ECS service discovery
- ECS task definition
  docker run --rm -dit --name mongo siva9666/mongo-instana:v1
  docker run --rm -dit --name mysql -e MYSQL_ROOT_PASSWORD=RoboShop@1 siva9666/mysql-instana:v1
  docker run --rm -dit --name redis siva9666/redis-instana:v1
  docker run --rm -dit --name rabbit siva9666/rabbit-instana:v1
  docker run --rm -dit -e MONGO=true -e MONGO_URL="mongodb://mongo:27017/catalogue" --name catalogue siva9666/catalogue-instana:v1
  docker run --rm -dit -e MONGO=true -e MONGO_URL="mongodb://mongo:27017/users" -e REDIS_HOST=redis --name user siva9666/user-instana:v1
  docker run --rm -dit -e CATALOGUE_HOST=catalogue -e CATALOGUE_PORT=8080 -e REDIS_HOST=redis --name cart siva9666/cart-instana:v1
  docker run --rm -dit \
  -e DB_HOST="mysql" \
  -e DB_PORT="3306" \
  -e DB_USER="shipping" \
  -e DB_PASSWD="RoboShop@1" \
  -e CART_ENDPOINT="cart:8080" \
  --name shipping \
  siva9666/shipping-instana:v1

  docker run --rm -dit --name payment \
    -e CART_HOST="cart" \
    -e CART_PORT=8080 \
    -e USER_HOST="user" \
    -e USER_PORT=8080 \
    -e AMQP_HOST="rabbit" \
    -e AMQP_USER=roboshop \
    -e AMQP_PASS=roboshop123 \
    siva9666/payment-instana:v1

  docker run --rm -dit --name dispatch \
    -e AMQP_HOST="rabbit" \
        -e AMQP_USER=roboshop \
        -e AMQP_PASS=roboshop123 \
        --network rb \
        siva9666/dispatch-instana:v1
  docker run --rm -dit --name web -p 80:80 --network rb siva9666/web-instana:v2
- Ensure All Containers are with in ns discoverable via it's name
- ECS Service creation

- I have default VPC with 3 public Subnets and default sg it will allow traffic




aws servicediscovery create-private-dns-namespace --name microservices.local --vpc vpc-07e30bcef51446692

