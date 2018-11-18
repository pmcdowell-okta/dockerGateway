FROM ubuntu

RUN apt-get update -y
RUN apt-get update -y
RUN apt-get install -y curl npm wget vim build-essential python-setuptools python-dev git make ssh zip nginx netcat
RUN rm -rf /var/lib/apt/lists/*

#install golang
ENV GO_VERSION 1.8.6

ADD https://dl.google.com/go/go1.10.linux-amd64.tar.gz /
RUN tar -C /usr/local -vxzf /go1.10.linux-amd64.tar.gz
ENV PATH="/go/bin:/usr/local/go/bin:$PATH" 
ENV GOPATH /go:/go/src/app/_gopath

#RUN apt-get install python-setuptools python-dev curl vim npm git make ssh zip -y
RUN npm config set registry http://registry.npmjs.org/

# Install AWS Stuff
RUN  curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN  unzip awscli-bundle.zip
RUN  ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# Install node.js
RUN curl --silent --location https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --yes nodejs


# Bundle app source
# Trouble with COPY http://stackoverflow.com/a/30405787/2926832
COPY . /src

# Install app dependencies
RUN cd /src; npm install

# Install Angular Components
RUN npm install -g @angular/cli@latest
RUN npm install -g typescript@latest
RUN npm install -g node-gyp@latest

# Install Serverless Framework so Lambdas can run
RUN npm install -g serverless
RUN npm install serverless-offline --save-dev


# Adding Dockertest components

RUN echo "#!/bin/bash\n" > /startscript.sh
RUN echo "mkdir github\n" >> /startscript.sh
RUN echo "cd github\n" >> /startscript.sh
RUN echo "git clone \$github\n" >> /startscript.sh
RUN echo "cd *\n" >> /startscript.sh
RUN echo "make dockertest\n" >> /startscript.sh

RUN chmod +x /startscript.sh

CMD /startscript.sh



