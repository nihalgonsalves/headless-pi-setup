FROM debian:stretch

ENV SETUP_DIR /home/setup
RUN mkdir -p $SETUP_DIR
WORKDIR $SETUP_DIR

ENV IMG_DIR /home/images
RUN mkdir -p $IMG_DIR

ADD ./src/ .

ENV PI_BOOT_MOUNT /mnt/pi/boot
ENV PI_OS_MOUNT /mnt/pi/os
RUN mkdir -p $PI_BOOT_MOUNT
RUN mkdir -p $PI_OS_MOUNT

CMD bash
