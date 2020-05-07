FROM ubuntu:18.04

COPY . /work

WORKDIR /work

ENV ANDROID_NDK /opt/android-ndk
ENV ANDROID_NDK_VERSION r19c

# ------------------------------------------------------
# --- Install required tools

RUN apt-get update -qq && \
    apt-get -y install wget unzip build-essential && \
    apt-get clean

# ------------------------------------------------------
# --- Android NDK

# download
RUN mkdir /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && \
    wget -q https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
# uncompress
    unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
# move to its final location
    mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK} && \
# remove temp dir
    cd ${ANDROID_NDK} && \
    rm -rf /opt/android-ndk-tmp

# add to PATH
ENV PATH ${PATH}:${ANDROID_NDK}

# ------------------------------------------------------
# --- build openssl for android

RUN cd ./tools

ENV MACHINE "Linux"

RUN sh ./build-openssl_111_4android.sh
