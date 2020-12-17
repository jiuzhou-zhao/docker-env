pre-init:
	./scripts/pre_init.sh

daemon:
	docker-compose up -d

post-init:
	./scripts/post_init.sh

update-all:
	docker-compose down
	./scripts/pre_init.sh false
	docker-compose up -d
	./scripts/post_init.sh
