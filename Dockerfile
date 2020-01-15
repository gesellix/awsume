FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install -y build-essential curl python-dev \
    && curl https://bootstrap.pypa.io/get-pip.py | python \
    && pip install awsume

ENTRYPOINT ["awsume"]
CMD ["-h"]
