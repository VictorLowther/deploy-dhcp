FROM digitalrebar/managed-service
MAINTAINER Victor Lowther <victor@rackn.com>

# Get Latest Go
RUN apt-get -y update \
  && apt-get -y install cmake openssh-server dhcp3-server \
  && curl -fgL -o '/root/dhcp-4.3.2.tar.gz' 'http://opencrowbar.s3-website-us-east-1.amazonaws.com/dhcp-4.3.2.tar.gz' \
  && cd /root \
  && tar -zxvf /root/dhcp-4.3.2.tar.gz

COPY discover.c '/root/dhcp-4.3.2/common/discover.c'
COPY dhcpd.h '/root/dhcp-4.3.2/includes/dhcpd.h'

RUN cd '/root/dhcp-4.3.2' \
 && ./configure \
      --enable-dhcpv6 \
      --with-srv-lease-file=/var/lib/dhcp/dhcpd.leases \
      --with-srv6-lease-file=/var/lib/dhcp/dhcpd6.leases \
      --with-cli-lease-file=/var/lib/dhclient/dhclient.leases \
      --with-cli6-lease-file=/var/lib/dhclient/dhclient6.leases \
      --with-srv-pid-file=/var/run/dhcpd.pid \
      --with-srv6-pid-file=/var/run/dhcpd6.pid \
      --with-cli-pid-file=/var/run/dhclient.pid \
      --with-cli6-pid-file=/var/run/dhclient6.pid \
      --with-relay-pid-file=/var/run/dhcrelay.pid \
      --with-relay6-pid-file=/var/run/dhcrelay6.pid \
      --enable-paranoia \
 &&  make \
 && cp /usr/sbin/dhcpd /usr/sbin/dhcpd.orig \
 && cp server/dhcpd /usr/sbin/dhcpd

COPY entrypoint.d/*.sh /usr/local/entrypoint.d/

ENV SERVICE_NAME dhcp

ENTRYPOINT ["/sbin/docker-entrypoint.sh"]
