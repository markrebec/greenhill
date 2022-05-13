# cd test_app/ && docker-compose down ; docker volume rm -f test_app_postgres test_app_mysql test_app_redis ; cd ../ && rm -rf test_app
cd test_app/ && docker-compose down ; docker volume rm -f test_app_postgres test_app_redis ; cd ../ && rm -rf test_app
