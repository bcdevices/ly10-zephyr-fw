FROM debian:stretch

LABEL "com.github.actions.name"="PLTcloud publish"
LABEL "com.github.actions.description"="Publish to PLTcloud"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/bcdevices/ly10-zephyr-fw"
LABEL "homepage"="https://github.com/bcdevices/ly10-zephyr-fw"
LABEL "maintainer"="Blue Clover Devices"

WORKDIR /usr/src

ADD pltcloud*_amd64.deb .

RUN dpkg -i pltcloud*_amd64.deb

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
