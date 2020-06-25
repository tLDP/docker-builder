# (C) Serge Victor 2020

# we always try to operate on recent ubuntu LTS
FROM ubuntu:focal

LABEL maintainer="ser@gnu.org"
LABEL version="0.1"
LABEL description="LDP Builder as a Docker image"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update

# installing required packages and cleaning up after
RUN apt -y install texlive-font-utils linuxdoc-tools-text linuxdoc-tools-latex docbook-dsssl docbook-xsl docbook-utils htmldoc htmldoc-common docbook-xsl html2text docbook5-xml docbook-xsl-ns jing asciidoc libxml2-utils python3-stdeb fakeroot python3-all python3-networkx python3-nose fop ldp-docbook-xsl ldp-docbook-dsssl docbook opensp dh-python git python-all && rm -rf /var/lib/apt/lists/* && apt clean

# getting our builder soft
RUN git clone https://github.com/tLDP/python-tldp
RUN cd python-tldp && rm -rf debian && python3 setup.py --command-packages=stdeb.command bdist_deb
RUN dpkg -i python-tldp/deb_dist/python3-tldp_*_all.deb

# we are done?
RUN ldptool --dump-cfg
RUN rm -rf python-tldp
