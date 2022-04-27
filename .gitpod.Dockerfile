FROM gitpod/workspace-base:latest
  
RUN sudo apt update && \
    sudo apt install -y kafkacat sed jq

# Install opensearch-cli
RUN wget https://artifacts.opensearch.org/opensearch-clients/opensearch-cli/opensearch-cli-1.1.0-linux-x64.zip && \
    unzip opensearch-cli-1.1.0-linux-x64.zip && \
    sudo mv opensearch-cli /usr/local/bin/opensearch-cli && \
    rm opensearch-cli-1.1.0-linux-x64.zip
