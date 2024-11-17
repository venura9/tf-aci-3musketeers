init: 
	docker compose run --rm terraform init -input=false
.PHONY: init

plan:
	docker compose run --rm terraform plan -input=false -out=tfplan
.PHONY: plan

apply:
	docker compose run --rm terraform apply -input=false -auto-approve
.PHONY: apply

destroy:
	docker compose run --rm terraform destroy -input=false -auto-approve
.PHONY: destroy
