FROM ubuntu:26.04
LABEL org.opencontainers.image.authors="Kok How, Teh <funcoolgeeek@gmail.com>"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y --fix-missing
RUN apt upgrade -y
RUN apt install -y --no-install-recommends software-properties-common apt-transport-https curl sudo gnupg unzip ca-certificates cmake ninja-build build-essential mysql-client postgresql-client dnsutils wget git python3 python3-pip python3-tk docker-buildx valgrind libgtest-dev
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN curl -sL -o /tmp/awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN unzip /tmp/awscliv2.zip -d /tmp
RUN /tmp/aws/install
RUN curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
ENV DOCKER_CLIENT_VER=29.8.2
RUN curl -sL -o /tmp/docker-$DOCKER_CLIENT_VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLIENT_VER.tgz
RUN tar -xz -C /tmp -f /tmp/docker-$DOCKER_CLIENT_VER.tgz
RUN mv /tmp/docker/* /usr/local/bin
RUN curl -sL -o /tmp/gcloud.tgz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
RUN tar -xf /tmp/gcloud.tgz
RUN ./google-cloud-sdk/install.sh -q
RUN rm -f /tmp/gcloud.tgz
RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
    | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null
    # add signed entry to apt sources and configure the APT client to use Intel repository:
RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list
RUN apt update -y --fix-missing
RUN apt install -y intel-oneapi-toolkit
RUN echo "[ -f \"/opt/intel/oneapi/setvars.sh\" ] && . /opt/intel/oneapi/setvars.sh" >> /etc/profile
#ENTRYPOINT ["bash"]
CMD ["/bin/bash"]
