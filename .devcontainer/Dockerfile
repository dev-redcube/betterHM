FROM debian:stable

RUN apt update && apt -y install git curl unzip wget openjdk-17-jdk

RUN mkdir /home/codespace
WORKDIR /home/codespace

ENV PUB_CACHE=/home/codespace/.pub_cache
ENV PATH="/home/codespace/flutter/bin:/home/codespace/android-sdk/cmdline-tools/latest/bin:$PATH"

RUN git clone https://github.com/flutter/flutter

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip && \
    rm commandlinetools-linux-9477386_latest.zip && \
    mkdir -p android-sdk/cmdline-tools/latest && \
    mv cmdline-tools/* android-sdk/cmdline-tools/latest/ && \
    rm -rf cmdline-tools

RUN /home/codespace/android-sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-33" "build-tools;34.0.0" "ndk;25.2.9519653"

RUN flutter config --android-sdk /home/codespace/android-sdk

RUN yes | sdkmanager --licenses

RUN dart --disable-analytics

RUN sh /workspaces/betterHM/setup.sh
