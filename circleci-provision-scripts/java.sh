#!/bin/bash

function install_oraclejdk8() {
    echo '>>> Installing Java 8'

    # Install java
    add-apt-repository -y ppa:webupd8team/java
    apt-get update
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
    apt-get install oracle-java8-installer
}

function install_java() {
    install_oraclejdk8
}


function install_maven() {
    echo '>>> Installing Maven'

    # Install Maven
    MAVEN_VERSION=3.2.5
    curl -sSL -o /tmp/maven.tar.gz http://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
    tar -xz -C /usr/local -f /tmp/maven.tar.gz
    ln -sf /usr/local/apache-maven-${MAVEN_VERSION} /usr/local/apache-maven

    as_user mkdir -p ${CIRCLECI_HOME}/.m2

    echo 'export M2_HOME=/usr/local/apache-maven' >> ${CIRCLECI_HOME}/.circlerc
    echo 'export MAVEN_OPTS=-Xmx2048m' >> ${CIRCLECI_HOME}/.circlerc
    echo 'export PATH=$M2_HOME/bin:$PATH' >> ${CIRCLECI_HOME}/.circlerc
}

function install_gradle() {
    echo '>>> Installing Gradle'

    GRADLE_VERSION=1.10
    URL=http://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip


    curl -sSL -o /tmp/gradle.zip $URL
    unzip -d /usr/local /tmp/gradle.zip

    echo 'export PATH=$PATH:/usr/local/gradle-1.10/bin' >> ${CIRCLECI_HOME}/.circlerc
    rm -rf /tmp/gradle.zip
}