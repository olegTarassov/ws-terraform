FROM registry.access.redhat.com/ubi8/ubi

ARG tfver="0.11.10"
ARG tgver="0.18.7"

ENV TERRAGRUNT_DOWNLOAD /terraform_cache/
ENV HOME /root

# Install Packages
RUN dnf install git python38 unzip gem vim bind-utils iputils diffutils -y \
      && dnf clean all

# bashrc
COPY bashrc $HOME/.bashrc

# Install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
      && unzip awscliv2.zip \
      && ./aws/install \
      && rm -rf aws/ awscliv2.zip

# Install terraform
RUN git clone https://github.com/tfutils/tfenv.git $HOME/.tfenv \
      && echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> $HOME/.bashrc \
      && export PATH="$HOME/.tfenv/bin:$PATH" \
      && tfenv install ${tfver} \
      && tfenv use ${tfver}

# Install terragrunt
RUN git clone https://github.com/cunymatthieu/tgenv.git $HOME/.tgenv \
      && echo 'export PATH="$HOME/.tgenv/bin:$PATH"' >> $HOME/.bashrc \
      && export PATH="$HOME/.tgenv/bin:$PATH" \
      && tgenv install ${tgver} \
      && tgenv use ${tgver}

# install landscape
RUN gem install terraform_landscape

WORKDIR /terraform

ENTRYPOINT ["terraform"]
CMD [--version]

