FROM jenkins/jenkins

USER root

RUN apt-get update && apt-get install python3-pip -y && \
    pip3 install ansible --upgrade

RUN apt-get update && apt-get install sudo && apt-get install wget

RUN  wget -c https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip


RUN unzip terraform_1.5.6_linux_amd64.zip && mv terraform /usr/local/bin/

RUN apt-get install awscli

USER jenkins