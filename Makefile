lint:
	GO111MODULE=on golangci-lint run ./app/...

test:
	GO111MODULE=on \
	go test -short ./app/...

generate-pb:
	@for file in `\find proto/v1 -type f -name '*.proto'`; do \
		protoc \
			$$file \
			-I ./proto/v1/ \
			-I $(GOPATH)/pkg/mod/github.com/envoyproxy/protoc-gen-validate@v0.4.0 \
			-I $(GOPATH)/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v1.14.6 \
			-I $(GOPATH)/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v1.14.6/third_party/googleapis/ \
			--go_out=plugins=grpc:$(GOPATH)/src \
			--validate_out="lang=go:$(GOPATH)/src" \
			--grpc-gateway_out=logtostderr=true:$(GOPATH)/src; \
	done

app-build:
ifeq ($(tag),)
	@echo "Please execute this command with the docker image tag."
	@echo "Usage:"
	@echo "	$$ make app-build tag=<version>"
else
	docker build -f ./Dockerfile -t istsh/gitops-sample-app:${tag} ./
endif

app-push:
ifeq ($(tag),)
	@echo "Please execute this command with the docker image tag."
	@echo "Usage:"
	@echo "	$$ make app-push tag=<version>"
else
	docker push istsh/gitops-sample-app:${tag}
endif

migration-build:
ifeq ($(tag),)
	@echo "Please execute this command with the docker image tag."
	@echo "Usage:"
	@echo "	$$ make migration-build tag=<version>"
else
	docker build -f ./Dockerfile.migration -t istsh/gitops-sample-migration:${tag} ./
endif

migration-push:
ifeq ($(tag),)
	@echo "Please execute this command with the docker image tag."
	@echo "Usage:"
	@echo "	$$ make migration-push tag=<version>"
else
	docker push istsh/gitops-sample-migration:${tag}
endif

create-migration-file:
ifeq ($(name),)
	@echo "Please execute this command with the migration file name."
	@echo "Usage:"
	@echo "	$$ make create-migration-file name=<name>"
else
	migrate create -dir db/migrations/ -ext sql ${name}
endif
