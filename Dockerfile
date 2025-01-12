FROM ubuntu:16.04

#Default environment variables
ENV DEBIAN_FRONTEND noninteractive 

#Disable Upstart (not sure if 16.04 still has Upstart but whatever)
RUN dpkg-divert --local --rename --add /sbin/initctl && \
 ln -sf /bin/true /sbin/initctl && \
 ln -sf /bin/false /usr/sbin/policy-rc.d

#Update the OS
RUN apt-get update --yes
RUN apt-get upgrade --yes

#Helper libs for adding PPAs
RUN apt-get install --yes dialog apt-utils software-properties-common wget

#Specifically add the Zandronum repo and install the application
RUN apt-add-repository 'deb http://debian.drdteam.org stable multiverse'
RUN wget -O - http://debian.drdteam.org/drdteam.gpg | apt-key add -
RUN apt-get update --yes 
RUN apt-get upgrade --yes
RUN apt-get install --yes --quiet libsdl-image1.2 zandronum 

#Create a non-privileged user
RUN useradd -ms /bin/bash zandronum
USER zandronum
WORKDIR /home/zandronum

#Build the application directory and add files
RUN mkdir /home/zandronum/config/ && \
  mkdir /home/zandronum/wad/ && \
  mkdir /home/zandronum/iwad/ && \
  mkdir /home/zandronum/bin/
ADD /config/ /home/zandronum/config/
ADD /bin/ /home/zandronum/bin/
ADD /player/ /home/zandronum/player/
ADD /iwad/ /home/zandronum/iwad/
ADD /wad/ /home/zandronum/wad/

CMD ["/home/zandronum/bin/summon.sh"]
ENTRYPOINT ["/home/zandronum/bin/summon.sh"]
EXPOSE 10666
