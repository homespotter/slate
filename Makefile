aws-login:
	(aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 769352775470.dkr.ecr.us-east-1.amazonaws.com) || \
	(aws ecr get-login --no-include-email --region us-east-1 | bash)

up:
	docker run --rm --name slate -p 4567:4567 -v "$(shell pwd)"/source:/srv/slate/source slatedocs/slate serve

prod:
	SLATE_HOST_PORT=8080 \
	docker-compose -f docker/docker-compose.prod.yml -p slate up --build

build-prod:
	docker build \
		-t com.homespotter.slate:latest \
		-f docker/prod/Dockerfile \
		.

push-prod: aws-login
	docker tag com.homespotter.slate:latest 769352775470.dkr.ecr.us-east-1.amazonaws.com/slate:latest
	docker push 769352775470.dkr.ecr.us-east-1.amazonaws.com/slate:latest
