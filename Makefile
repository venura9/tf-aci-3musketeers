init: 
	docker compose run --rm terraform init -input=false
.PHONY: init

plan:
	make init
	docker compose run --rm terraform plan -input=false -out=tfplan
.PHONY: plan

apply:
	make init
	docker compose run --rm terraform apply -input=false -auto-approve
.PHONY: apply

destroy:
	make init
	docker compose run --rm terraform destroy -input=false -auto-approve
.PHONY: destroy
