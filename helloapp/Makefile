.PHONY: initenv inittestenv initdb cleanall cleancache rundev rungunicorn test build auth push

initenv:
	python3 -m venv .venv
	.venv/bin/pip3 install -r requirements/runtime.txt

inittestenv:
	python3 -m venv .venv
	.venv/bin/pip3 install -r requirements/test.txt

initdb:
	FLASK_APP=main.py flask db upgrade

cleanall:
	rm -rf .venv app.db && $(MAKE) cleancache

cleancache:
	find . | grep -E "(__pycache__|\.pyc|\.pyo\$$)" | xargs rm -rf 
	rm -rf .pytest_cache

rundev:
	export FLASK_APP=main.py:app
	export FLASK_ENV=development
	.venv/bin/flask run

rungunicorn:
	.venv/bin/gunicorn --workers 1 \
	--bind 0.0.0.0:8000 \
	--access-logfile=- \
	--error-logfile=- \
	main:app

test:
	.venv/bin/pytest

build:
	$(MAKE) cleancache && \
	docker build -t app .

auth:
	# Authenticate to AWS ECR
	eval $(shell aws ecr get-login --no-include-email)

push:
	# Tags and pushes docker image to ECR
	docker tag app ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/app
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/app

deploy:
	$(MAKE) push && \
	aws ecs update-service --service app --cluster app --force-new-deployment
