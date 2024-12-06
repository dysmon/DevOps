FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    wget \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libsm6 \
    libfreetype6 \
    libfontconfig1 \
    --no-install-recommends

ARG OPERA_VERSION=11.50
# Set the download URL for Opera
RUN wget --no-check-certificate -O /tmp/opera.tar.gz "https://get.opera.com/pub/opera/linux/1150/opera-${OPERA_VERSION}-1074.x86_64.linux.tar.gz" \
    && tar -xzf /tmp/opera.tar.gz -C /opt/ \
    && ln -fs /opt/opera/opera /usr/bin/opera \
    && rm /tmp/opera.tar.gz \
    && echo -e "\n\n" | /opt/opera*/install

ENTRYPOINT ["/usr/local/bin/opera", "https://www.armorgames.com"]
