
FROM quay.io/redhat-services-prod/app-sre-tenant/er-base-cdktf-main/er-base-cdktf-main:0.2.0 AS prod

LABEL konflux.additional-tags="0.2.0"

ENV TF_PROVIDER_AWS_VERSION="5.60.0"
ENV TF_PLUGIN_CACHE="${HOME}/.terraform.d/plugin-cache"
ENV TF_PROVIDER_AWS_PATH="${TF_PLUGIN_CACHE}/registry.terraform.io/hashicorp/aws/${TF_PROVIDER_AWS_VERSION}/linux_amd64"

RUN mkdir -p ${TF_PROVIDER_AWS_PATH} && \
    curl -sfL https://releases.hashicorp.com/terraform-provider-aws/${TF_PROVIDER_AWS_VERSION}/terraform-provider-aws_${TF_PROVIDER_AWS_VERSION}_linux_amd64.zip \
    -o /tmp/package-aws-${TF_PROVIDER_AWS_VERSION}.zip && \
    unzip /tmp/package-aws-${TF_PROVIDER_AWS_VERSION}.zip -d ${TF_PROVIDER_AWS_PATH}/ && \
    rm /tmp/package-aws-${TF_PROVIDER_AWS_VERSION}.zip

COPY requirements.txt ./
RUN uv pip install -r requirements.txt

COPY entrypoint.sh ./
ENTRYPOINT [ "bash", "entrypoint.sh" ]

FROM prod AS test
COPY Makefile ./
RUN make test
