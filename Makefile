all:
	docker compose -f srcs/docker-compose.yml up --build
down:
	docker compose -f srcs/docker-compose.yml down
clean:
	docker system prune -af
fclean:
	docker compose -f srcs/docker-compose.yml down -v
	docker system prune -af
	sudo rm -rf /home/marwan/data/mariadb/*
	sudo rm -rf /home/marwan/data/wordpress/*
re: fclean all

.PHONY: all down clean fclean re