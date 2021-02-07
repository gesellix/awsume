FROM python:3.7

ENV NODE_VERSION=node_12.x
ENV DISTRO=buster
#ENV DISTRO="$(lsb_release -s -c)"
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN sh -c 'echo "deb https://deb.nodesource.com/${NODE_VERSION} ${DISTRO} main" | tee /etc/apt/sources.list.d/nodesource.list' \
    sh -c 'echo "deb-src https://deb.nodesource.com/${NODE_VERSION} ${DISTRO} main" | tee -a /etc/apt/sources.list.d/nodesource.list'

RUN apt-get update \
    && apt-get install -y nodejs build-essential curl vim groff less \
    && pip3 install --upgrade pip

COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt --upgrade

#RUN python3 -m pipx ensurepath
ENV PATH=/root/.local/bin:$PATH

# awsume won't set AWS_* env variables when installed via pip
RUN pipx install awscli \
    && pipx install awsume \
    && pipx inject awsume awsume-console-plugin \
    && awsume-configure --shell bash --autocomplete-file ~/.bashrc --alias-file ~/.bashrc

ENTRYPOINT ["bash"]
CMD []
