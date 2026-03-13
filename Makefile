# Variables. Yes.
DOCKER=docker
VERSION=local
ORGANISATION=public.ecr.aws/unocha

# The main build recipe.
build:  clean
	$(DOCKER) buildx build \
				--build-arg BRANCH_ENVIRONMENT=$(NODE_ENV) \
				--build-arg VCS_REF=`git rev-parse --short HEAD` \
				--build-arg VCS_URL=`git config --get remote.origin.url | sed 's#git@github.com:#https://github.com/#'` \
				--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
				--build-arg GITHUB_ACTOR=`whoami` \
				--build-arg GITHUB_REPOSITORY=`git config --get remote.origin.url` \
				--build-arg GITHUB_SHA=`git rev-parse --short HEAD` \
			--load --platform linux/arm64,linux/amd64 \
		. --file docker/Dockerfile --tag $(ORGANISATION)/unocha/vrt:$(VERSION) \
		2>&1 | tee buildlog.txt

clean:
	rm -rf ./buildlog.txt

login:
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(ORGANISATION)

# Always build, never claim cache.
.PHONY: build
