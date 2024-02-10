include .env

export $(shell sed 's/=.*//' .env)

export TF_VAR_app_name=$(APP_NAME)
export TF_VAR_app_env=$(APP_ENV)
export TF_VAR_aws_s3_bucket=$(AWS_S3_BUCKET)
export TF_VAR_aws_region=$(AWS_REGION)
export TF_LOG=error

init:
	terraform -chdir=./terraform/$(service) init \
		-backend-config="bucket=$(AWS_S3_BUCKET)" \
		-backend-config="key=terraform/${APP_NAME}-$(service)-${APP_ENV}.tfstate" \
		-backend-config="region=$(AWS_REGION)"; \

init-all:
	make init service=cognito
	make init service=lambda
	make init service=api-gateway

plan:
	terraform -chdir=./terraform/$(service) plan

plan-all:
	make plan service=cognito
	make plan service=lambda
	make plan service=api-gateway

apply:
	terraform -chdir=./terraform/$(service) apply -auto-approve

apply-all:
	make apply service=cognito
	make apply service=lambda
	make apply service=api-gateway

plan-destroy:
	terraform -chdir=./terraform/$(service) plan -destroy

destroy:
	terraform -chdir=./terraform/$(service) destroy -auto-approve

# reverse order as api-gateway is dependent on cognito and lambda
destroy-all:
	make destroy service=api-gateway
	make destroy service=lambda
	make destroy service=cognito

reset-all:
	rm -rf ./terraform/*/.terraform
	rm -rf ./terraform/*/.terraform.lock.hcl

build:
	CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -ldflags "-s -w" -o ./bin/test-lambda/main ./cmd/main.go
