# (C) Serge Victor 2020-2024

#################################################################################################
# STAGE 1/2
#################################################################################################

# we always try to operate on recent ubuntu LTS
FROM ubuntu:jammy

LABEL maintainer="ser@gnu.org"
LABEL version="0.2"
LABEL description="LDP Builder as a Docker image"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update

# installing required packages and cleaning up after
RUN apt -y install texlive-font-utils linuxdoc-tools-text linuxdoc-tools-latex docbook-dsssl docbook-xsl docbook-utils htmldoc htmldoc-common docbook-xsl html2text docbook5-xml docbook-xsl-ns jing asciidoc libxml2-utils python3-stdeb fakeroot python3-all python3-networkx python3-nose fop ldp-docbook-xsl ldp-docbook-dsssl docbook opensp dh-python git python-all rsync fop && rm -rf /var/lib/apt/lists/* && apt clean

# getting our builder soft
RUN git clone https://github.com/tLDP/python-tldp
RUN cd python-tldp && rm -rf debian && python3 setup.py --command-packages=stdeb.command bdist_deb
RUN dpkg -i python-tldp/deb_dist/python3-tldp_*_all.deb

# we are done?
RUN ldptool --dump-cfg

#################################################################################################
# STAGE 2/2
#################################################################################################

FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

COPY --from=0 python-tldp/deb_dist/python3-tldp_*_all.deb .
RUN apt install ./python3-tldp_*_all.deb --fix-broken -y

# we are done?
RUN ldptool --dump-cfg

# the happy end.
