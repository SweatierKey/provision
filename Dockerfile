FROM registry.access.redhat.com/ubi7/ubi

RUN yum install -y openssh-server openssh-clients passwd && \
    ssh-keygen -A && \
    echo "root:password" | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
