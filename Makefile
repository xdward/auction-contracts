PROTO_FILES=pb/*.proto
PROTO_PATH=pb
GO_OUT=pb
GO_OPT=module=github.com/xdward/auction-contracts/pb

.PHONY: proto-compile
proto-compile:
	protoc $(PROTO_FILES) \
	    --proto_path=$(PROTO_PATH) \
        --go_out=$(GO_OUT) --go_opt=$(GO_OPT) \
        --go-grpc_out=$(GO_OUT) --go-grpc_opt=$(GO_OPT)

.PHONY: clean
clean:
	rm -rf $(GO_OUT)/message
	rm -rf $(GO_OUT)/service
