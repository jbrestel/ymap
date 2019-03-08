FROM nimmis/apache-php5

MAINTAINER John Brestelli <jbrestell@gmail.com>

#  docker run --rm -it -v $YMAP_DATA:/var/www/public/users -p 80:80 -v "$MATLAB_ROOT":/usr/local/MATLAB/from-host jbrestel/ymap
# - `MATLAB_ROOT` is your matlab installation on the Docker host, Exampple: `/usr/local/MATLAB/R2016a`.
# - `YMAP_DATA` is your directory for your data on your host
# - the webapplication will be available from localhost:80


RUN apt-add-repository ppa:webupd8team/java \
 && apt-get update \
 && apt-get -y install software-properties-common \
 && add-apt-repository -y ppa:webupd8team/java \
 && echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections \
 && apt-get update \
 && apt-get -y install build-essential libpq-dev libssl-dev openssl libtbb-dev libffi-dev zlib1g-dev libbz2-dev libncurses5-dev libncursesw5-dev liblzma-dev python3-pip python3-dev oracle-java8-installer \
 && wget -O bowtie.zip https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.4.3/bowtie2-2.3.4.3-source.zip/download \
 && unzip bowtie.zip \
 && cd bowtie2-2.3.4.3 \
 && make && cd .. \
 && wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 \
 && tar -vxjf samtools-1.9.tar.bz2 \
 && cd samtools-1.9 \
 && make && cd ..

ENV PATH="/usr/local/MATLAB/from-host/bin:${PATH}"

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

COPY . /var/www/public/

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

