FROM phusion/baseimage:0.9.15

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.

# ...put your own build instructions here...
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y libmongodb-perl make gcc
RUN curl -L https://cpanmin.us | perl - -M https://cpan.metacpan.org -n Mojolicious
COPY board_app /opt/board_app/

EXPOSE 80

CMD  morbo -l http://\*:80 /opt/board_app/script/board_app

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
