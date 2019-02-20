FROM ruby:2.1

ENV FLUTTER_CHANNEL=stable
ENV FLUTTER_VERSION=1.0.0-${FLUTTER_CHANNEL}
ENV ANDROID_COMPILE_SDK='28'
ENV ANDROID_BUILD_TOOLS='28.0.1'
ENV ANDROID_SDK_TOOLS='4333796'

# install java
RUN echo "deb http://http.debian.net/debian jessie-backports main" | tee -a /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y -t jessie-backports openjdk-8-jdk
RUN java -version

# install android tools
RUN apt-get install -y unzip
ENV ANDROID_HOME=$HOME/android-sdk-linux
RUN wget -q https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_TOOLS.zip -O android-sdk-tools.zip
RUN unzip -q android-sdk-tools.zip -d ${ANDROID_HOME}
RUN rm android-sdk-tools.zip
ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
RUN mkdir -p ~/.android
RUN touch ~/.android/repositories.cfg
RUN yes | sdkmanager --licenses
RUN yes | sdkmanager "platform-tools" "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null
RUN sdkmanager --list | head -15

# install pre-compiled flutter
RUN wget --quiet --output-document=flutter.tar.xz https://storage.googleapis.com/flutter_infra/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_v${FLUTTER_VERSION}.tar.xz && tar xf flutter.tar.xz > /dev/null && rm flutter.tar.xz
ENV PATH="$PATH":"$HOME/.pub-cache/bin"
ENV PATH=$PWD/flutter/bin:$PWD/flutter/bin/cache/dart-sdk/bin:$PATH
RUN apt-get install -y lib32stdc++6
RUN flutter doctor -v

# install latest dart
RUN apt-get install -y apt-transport-https
RUN sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
RUN sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get update && apt-get install -y dart
