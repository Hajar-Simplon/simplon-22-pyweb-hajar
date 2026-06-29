IMAGE_NAME = pyweb-app
CONTAINER_NAME = pyweb-container
VOLUME_NAME = pyweb-data
HOST_PORT = 8080
CONTAINER_PORT = 8080

.PHONY: build
build:
	@echo "=== Building image ==="
	@docker build -t $(IMAGE_NAME) .

.PHONY: run
run:
	@echo "=== Creating volume ==="
	@docker volume create $(VOLUME_NAME) || true
	@echo "=== Removing old container if exists ==="
	@docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	@echo "=== Starting container ==="
	@docker run -d \
		-p $(HOST_PORT):$(CONTAINER_PORT) \
		-v $(VOLUME_NAME):/app/data \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME)

.PHONY: restart
restart:
	@echo "=== Stopping container ==="
	@docker stop $(CONTAINER_NAME)
	@echo "=== Starting container ==="
	@docker start $(CONTAINER_NAME)

.PHONY: kill
kill:
	@echo "=== Removing container ==="
	@docker rm -f $(CONTAINER_NAME)
	@echo "=== Removing volume ==="
	@docker volume rm $(VOLUME_NAME)
	@echo "=== Cleanup completed ==="