FROM registry.access.redhat.com/ubi8/ubi

ARG tfver="0.15.5"
ARG tgver="0.35.16"

ARG AWS_DEFAULT_REGION="us-east-1"
ARG AWS_ACCESS_KEY_ID=""
ARG AWS_SECRET_ACCESS_KEY=""

ENV AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
ENV TERRAGRUNT_DOWNLOAD="/terraform_cache/"
ENV HOME="/root"

# Install Packages and Terraform
RUN dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
      && dnf -y install nano git python38 unzip vim bind-utils iputils diffutils dnf-plugins-core nmap-ncat iproute terraform-ls terraform-${tfver}-1 \
      && dnf clean all

# bashrc
COPY bashrc $HOME/.bashrc

# Install aws cli v2
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
        && unzip -q awscliv2.zip \
        && ./aws/install

# Install terragrunt
RUN curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v${tgver}/terragrunt_linux_amd64 -o /usr/bin/terragrunt \
      && chmod +x /usr/bin/terragrunt

WORKDIR /terraform

ENTRYPOINT ["terraform"]
CMD [--version]
