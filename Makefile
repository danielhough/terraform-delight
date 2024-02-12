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
	make terraform-init service=cognito
	make terraform-init service=lambda
	make terraform-init service=api-gateway

terraform-plan:
	terraform -chdir=./terraform/$(service) plan

terraform-plan-all:
	make terraform-plan service=cognito
	make terraform-plan service=lambda
	make terraform-plan service=api-gateway

terraform-apply:
	terraform -chdir=./terraform/$(service) apply -auto-approve

terraform-apply-all:
	make terraform-apply service=cognito
	make terraform-apply service=lambda
	make terraform-apply service=api-gateway

terraform-plan-destroy:
	terraform -chdir=./terraform/$(service) plan -destroy

terraform-plan-destroy-all:
	make terraform-plan-destroy service=cognito
	make terraform-plan-destroy service=lambda
	make terraform-plan-destroy service=api-gateway

terraform-destroy:
	terraform -chdir=./terraform/$(service) destroy -auto-approve

# reverse order as api-gateway is dependent on cognito and lambda
terraform-destroy-all:
	make terraform-destroy service=api-gateway
	make terraform-destroy service=lambda
	make terraform-destroy service=cognito

terraform-reset:
	rm -rf ./terraform/*/.terraform
	rm -rf ./terraform/*/.terraform.lock.hcl

terraform-life-cycle:
	make terraform-init service=$(service)
	make terraform-plan service=$(service)
	make terraform-apply service=$(service)
	make terraform-plan-destroy service=$(service)
	make terraform-destroy service=$(service)

# run everything and then destroy it 💥
terraform-life-cycle-all:
	make terraform-reset
	make terraform-init-all
	make terraform-apply-all
	make terraform-destroy-all

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
