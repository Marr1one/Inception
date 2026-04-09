all:
	mkdir -p /home/maissat/data/mariadb
	mkdir -p /home/maissat/data/wordpress
	docker compose -f srcs/docker-compose.yml up --build
down:
	docker compose -f srcs/docker-compose.yml down
clean:
	docker system prune -af
fclean:
	docker compose -f srcs/docker-compose.yml down -v
	docker system prune -af

re: fclean all

.PHONY: all down clean fclean re
