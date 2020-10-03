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

proxy-build:
ifeq ($(tag),)
	@echo "Please execute this command with the docker image tag."
	@echo "Usage:"
	@echo "	$$ make proxy-build tag=<version>"
else
	docker build -f ./Dockerfile.proxy -t istsh/gitops-sample-app-proxy:${tag} ./
endif

server-build:
ifeq ($(tag),)
	@echo "Please execute this command with the docker image tag."
	@echo "Usage:"
	@echo "	$$ make server-build tag=<version>"
else
	docker build -f ./Dockerfile.server -t istsh/gitops-sample-app-server:${tag} ./
endif

proxy-push:
ifeq ($(tag),)
	@echo "Please execute this command with the docker image tag."
	@echo "Usage:"
	@echo "	$$ make proxy-push tag=<version>"
else
	docker push istsh/gitops-sample-app-proxy:${tag}
endif

server-push:
ifeq ($(tag),)
	@echo "Please execute this command with the docker image tag."
	@echo "Usage:"
	@echo "	$$ make server-push tag=<version>"
else
	docker push istsh/gitops-sample-app-server:${tag}
endif
