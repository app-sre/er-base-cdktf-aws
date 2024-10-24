
FROM quay.io/app-sre/er-base-cdktf:0.1.0

ENV TF_PROVIDER_AWS_VERSION="5.60.0"
ENV TF_PLUGIN_CACHE="${HOME}/.terraform.d/plugin-cache"
ENV TF_PROVIDER_AWS_PATH="${TF_PLUGIN_CACHE}/registry.terraform.io/hashicorp/aws/${TF_PROVIDER_AWS_VERSION}/linux_amd64"

RUN mkdir -p ${TF_PROVIDER_AWS_PATH} && \
    curl -sfL https://releases.hashicorp.com/terraform-provider-aws/${TF_PROVIDER_AWS_VERSION}/terraform-provider-aws_${TF_PROVIDER_AWS_VERSION}_linux_amd64.zip \
    -o /tmp/package-aws-${TF_PROVIDER_AWS_VERSION}.zip && \
    unzip /tmp/package-aws-${TF_PROVIDER_AWS_VERSION}.zip -d ${TF_PROVIDER_AWS_PATH}/ && \
    rm /tmp/package-aws-${TF_PROVIDER_AWS_VERSION}.zip

WORKDIR ${HOME}
COPY requirements.txt ./
RUN python3 -m pip install --user -r requirements.txt

COPY entrypoint.sh ./
ENTRYPOINT [ "bash", "entrypoint.sh" ]
