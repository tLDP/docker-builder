# (C) Serge Victor 2020-2024

#################################################################################################
# STAGE 1/2
#################################################################################################

# we always try to operate on recent ubuntu LTS
FROM ubuntu:jammy

LABEL maintainer="ser@gnu.org"
LABEL version="0.3"
LABEL description="LDP Builder as a Docker image"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# installing required packages and cleaning up after
RUN apt-get -y install texlive-font-utils linuxdoc-tools-text linuxdoc-tools-latex docbook-dsssl docbook-xsl docbook-utils htmldoc htmldoc-common docbook-xsl html2text docbook5-xml docbook-xsl-ns jing asciidoc libxml2-utils python3-stdeb fakeroot python3-all python3-networkx python3-nose fop ldp-docbook-xsl ldp-docbook-dsssl docbook opensp dh-python git python-all

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

RUN apt-get install -y rsync asciidoc docbook docbook-xsl-ns docbook5-xml fop html2text htmldoc jing ldp-docbook-dsssl ldp-docbook-xsl linuxdoc-tools-latex linuxdoc-tools-text python3 python3-networkx python3-nose sgml2x texlive-font-utils xsltproc

COPY --from=0 python-tldp/deb_dist/python3-tldp_*_all.deb .
RUN apt-get install ./python3-tldp_*_all.deb --fix-broken -y

RUN apt-get clean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

# we are done?
RUN ldptool --dump-cfg

# the happy end.
