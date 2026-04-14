docker-build:
	git pull
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 739561048503.dkr.ecr.us-east-1.amazonaws.com
	docker build -t 739561048503.dkr.ecr.us-east-1.amazonaws.com/portfolio-service:$(image_tag) .
	docker push 739561048503.dkr.ecr.us-east-1.amazonaws.com/portfolio-service:$(image_tag)

eks-deploy:
	aws eks update-kubeconfig --name dev
	helm upgrade -i portfolio-service helm -f helm/values/portfolio-service.yml --set image_tag=$(image_tag)


