init: 
	docker-compose run --rm terraform init -input=false
.PHONY: init

plan:
	docker-compose run --rm terraform plan -input=false -out=tfplan
.PHONY: plan

#docker-compose run --rm terraform apply -auto-approve
apply:
	docker-compose run --rm terraform apply -input=false 
.PHONY: apply

#docker-compose run --rm terraform destroy -auto-approve
destroy:
	docker-compose run --rm terraform destroy -input=false 
.PHONY: destroy