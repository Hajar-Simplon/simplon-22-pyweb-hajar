# ==========================================
# Docker Configuration
# ==========================================

IMAGE_NAME      = pyweb-app
IMAGE_TAG       = v1

CONTAINER_NAME  = pyweb-container
VOLUME_NAME     = pyweb-data

HOST_PORT       = 8080
CONTAINER_PORT  = 8080

# ==========================================
# Docker Commands
# ==========================================

.PHONY: build
build:
	@echo "=== Building Docker image ==="
	@docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

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
		$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: restart
restart:
	@echo "=== Restarting container ==="
	@docker restart $(CONTAINER_NAME)

.PHONY: kill
kill:
	@echo "=== Removing container ==="
	@docker rm -f $(CONTAINER_NAME) 2>/dev/null || true

	@echo "=== Removing volume ==="
	@docker volume rm $(VOLUME_NAME) 2>/dev/null || true

	@echo "=== Cleanup completed ==="

# ==========================================
# Azure Infrastructure
# ==========================================

.PHONY: infra-create
infra-create:
	@echo "=== Creating Azure infrastructure ==="
	@pwsh -File ./infra/create.ps1

.PHONY: identity
identity:
	@echo "=== Configuring Azure Managed Identity ==="
	@pwsh -File ./infra/identity.ps1

.PHONY: federation
federation:
	@echo "=== Configuring GitLab OIDC ==="
	@pwsh -File ./infra/federation.ps1
	
.PHONY: infra-destroy
infra-destroy:
	@echo "=== Destroying Azure infrastructure ==="
	@pwsh -File ./infra/destroy.ps1
