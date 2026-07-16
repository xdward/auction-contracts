PROTO_PATH=proto
GO_OUT=gen/go
GO_OPT=module=github.com/xdward/auction-contracts/gen/go

.PHONY: proto-compile
proto-compile:
	mkdir -p $(GO_OUT)
	protoc $(PROTO_PATH)/*.proto \
	--proto_path=$(PROTO_PATH) \
	--go_out=$(GO_OUT) --go_opt=$(GO_OPT) \
	--go-grpc_out=$(GO_OUT) --go-grpc_opt=$(GO_OPT)

.PHONY: clean
clean:
	rm -rf $(GO_OUT)/*.pb.go
