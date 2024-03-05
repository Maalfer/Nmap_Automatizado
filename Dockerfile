FROM ubuntu:latest

RUN apt update && \
    apt install -y nmap iputils-ping

WORKDIR /home

COPY script.sh .
RUN chmod +x script.sh

CMD ./script.sh
