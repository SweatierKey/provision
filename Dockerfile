FROM registry.access.redhat.com/ubi7/ubi

RUN yum install -y openssh-server openssh-clients passwd && \
    ssh-keygen -A && \
    echo "root:password" | chpasswd

ENV TERM="xterm"

# Copia la chiave pubblica del tuo host
COPY .id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
