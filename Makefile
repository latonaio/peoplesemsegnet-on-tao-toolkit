# Self-Documented Makefile
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

tao-docker-run: ## TAO用コンテナを建てる
	docker-compose -f docker-compose.yaml up -d

tao-docker-build: ## TAO用コンテナをビルド
	docker-compose -f docker-compose.yaml build

tao-convert:
	docker exec -it peoplesemsegnet-tao-toolkit tao-converter -k tlt_encode -t fp16 \
		-p input_1,1x3x544x960,1x3x544x960,1x3x544x960 -e /app/src/peoplesemsegnet.etlt_b1_gpu0_fp16.engine /app/src/peoplesemsegnet.etlt

tao-docker-login: ## TAO用コンテナにログイン
	docker exec -it peoplesemsegnet-tao-toolkit bash

