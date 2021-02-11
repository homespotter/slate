up:
	docker run --rm --name slate -p 4567:4567 -v "$(shell pwd)"/source:/srv/slate/source slatedocs/slate serve