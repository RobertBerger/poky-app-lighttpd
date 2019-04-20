FROM scratch
ADD app-container-image-lighttpd-containerx86-64-20190420170558.rootfs.tar.bz2 /
CMD /etc/init.d/lighttpd start && tail -f /var/log/lighttpd.error.log
