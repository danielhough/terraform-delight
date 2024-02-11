include .env

export $(shell sed 's/=.*//' .env)

export TF_VAR_app_name=$(APP_NAME)
export TF_VAR_app_env=$(APP_ENV)
export TF_VAR_aws_s3_bucket=$(AWS_S3_BUCKET)
export TF_VAR_aws_region=$(AWS_REGION)
export TF_LOG=error

terraform-init:
	terraform -chdir=./terraform/$(service) init \
		-backend-config="bucket=$(AWS_S3_BUCKET)" \
		-backend-config="key=terraform/${APP_NAME}-$(service)-${APP_ENV}.tfstate" \
		-backend-config="region=$(AWS_REGION)"; \

terraform-init-all:
	make init service=cognito
	make init service=lambda
	make init service=api-gateway

terraform-plan:
	terraform -chdir=./terraform/$(service) plan

terraform-plan-all:
	make plan service=cognito
	make plan service=lambda
	make plan service=api-gateway

terraform-apply:
	terraform -chdir=./terraform/$(service) apply -auto-approve

terraform-apply-all:
	make apply service=cognito
	make apply service=lambda
	make apply service=api-gateway

terraform-plan-destroy:
	terraform -chdir=./terraform/$(service) plan -destroy

terraform-destroy:
	terraform -chdir=./terraform/$(service) destroy -auto-approve

# reverse order as api-gateway is dependent on cognito and lambda
terraform-destroy-all:
	make destroy service=api-gateway
	make destroy service=lambda
	make destroy service=cognito

terraform-reset-all:
	rm -rf ./terraform/*/.terraform
	rm -rf ./terraform/*/.terraform.lock.hcl

docker-build:
	docker build --target go --file ./build/Dockerfile --tag terraform_delight_go .

docker-run-go:
	docker run --rm -v ${PWD}:/go/src/app terraform_delight_go ${cmd}

go-build:
	make docker-run-go cmd='env GOARCH=amd64 GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -o bin/${service}/main cmd/${service}/main.go'

go-get:
	make docker-run-go cmd='go get ${package}'

go-mod-vendor:
	make docker-run-go cmd='go mod vendor'

sam-build:
	sam build --debug

sam-start-api:
	sam local start-api --skip-pull-image --debug

sam-build-start:
	make go-build service=${service}
	make sam-build
	make sam-start-api