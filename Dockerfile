FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y wget unzip openjdk-8-jdk

ENV ANDROID_SDK=/usr/local/android_tools
RUN mkdir -p /usr/local/android_tools \
    && cd $ANDROID_SDK \
    && wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
    && unzip -q sdk-tools-linux-4333796.zip \
    && rm sdk-tools-linux-4333796.zip

ENV ANDROID_KVM=system-images;android-28;google_apis_playstore;x86_64
ENV ANDROID_ARM=system-images;android-24;default;arm64-v8a

RUN mkdir -p $HOME/.android \
    && touch $HOME/.android/repositories.cfg \
    && yes | $ANDROID_SDK/tools/bin/sdkmanager "platform-tools" "platforms;android-28" "emulator" "build-tools;28.0.2" "tools" "$ANDROID_ARM" "$ANDROID_KVM"

RUN echo "no" | $ANDROID_SDK/tools/bin/avdmanager create avd -n aName -k  "$ANDROID_ARM" -c 300M


EXPOSE 5554

CMD ($ANDROID_SDK/tools/emulator @aName -no-skin -no-audio -no-window)
