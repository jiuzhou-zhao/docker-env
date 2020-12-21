pre-init:
	python ./scripts/pre_init.py

daemon:
	docker-compose up -d

post-init:
	python ./scripts/post_init.py

update-all:
	docker-compose down
	python ./scripts/pre_init.py false
	docker-compose up -d
	python ./scripts/post_init.py
