PORT=8080

.PHONY: build
build:
	@echo "=== Building image ==="
	@docker build -t pyweb-app .

.PHONY: run
run:
	@echo "=== Creating volume ==="
	@docker volume create pyweb-data || true
	@echo "=== Removing old container if exists ==="
	@docker rm -f pyweb-container 2>/dev/null || true
	@echo "=== Starting container ==="
	@docker run -d -p $(PORT):$(PORT) -v pyweb-data:/app/data --name pyweb-container pyweb-app

.PHONY: restart
restart:
	@echo "=== Stopping container ==="
	@docker stop pyweb-container
	@echo "=== Starting container ==="
	@docker start pyweb-container

.PHONY: kill
kill:
	@echo "=== Removing container ==="
	@docker rm -f pyweb-container
	@echo "=== Removing volume ==="
	@docker volume rm pyweb-data
	@echo "=== Cleanup completed ==="