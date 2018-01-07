FROM python:3-alpine

ENV TERRAFORM_VERSION=0.10.8
ENV AWSCLI_VERSION=1.11.162

RUN apk add --no-cache --update ca-certificates openssl curl && \
	wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin/ && \
	rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        pip install awscli==${AWSCLI_VERSION}

ENV PLUGIN_ACME_VERSION="v0.4.0"
ENV PLUGIN_ACME_ZIP="terraform-provider-acme_${PLUGIN_ACME_VERSION}_linux_amd64.zip"
ENV PLUGIN_ACME_URL="https://github.com/paybyphone/terraform-provider-acme/releases/download/${PLUGIN_ACME_VERSION}/${PLUGIN_ACME_ZIP}"

RUN wget ${PLUGIN_ACME_URL} && \
	mkdir -p $HOME/.terraform.d/plugins && \
	unzip ${PLUGIN_ACME_ZIP} -d $HOME/.terraform.d/plugins && \
	rm -f ${PLUGIN_ACME_ZIP}