pre-init:
	./scripts/pre_init.sh

daemon:
	docker-compose up -d

post-init:
	./scripts/post_init.sh
