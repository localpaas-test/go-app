mod:
	go mod tidy && go mod vendor

build:
	@go build -o app ./cmd/...

run:
	@go run ./cmd/...
