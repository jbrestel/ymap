FROM nimmis/apache-php5

MAINTAINER John Brestelli <jbrestell@gmail.com>

#  docker run --rm -it --mac-address $MAC_ADDRESS -v $YMAP_CONFIG:/var/www/public/config.sh -v $YMAP_DATA:/var/www/public/users -p 80:80 -v "$MATLAB_ROOT":/usr/local/MATLAB/from-host jbrestel/ymap
# - `MATLAB_ROOT` is your matlab installation on the Docker host, Exampple: `/usr/local/MATLAB/R2016a`.
# - `YMAP_DATA` is your directory for your data on your host
# - `YMAP_CONFIG` config file where you specify how many threads etc
# - `MAC_ADDRESS` for your local machine which has MATLAB installed
# - the webapplication will be available from localhost:80

RUN apt-get update \
&& apt-get -y install build-essential libpq-dev libssl-dev openssl libtbb-dev libffi-dev zlib1g-dev libbz2-dev libncurses5-dev libncursesw5-dev liblzma-dev python3-pip python3-dev openjdk-7-jdk openjdk-6-jdk ant git \
&& python3 -m pip install numpy==1.8.0 \
&& wget --no-check-certificate -O GenomeAnalysisTK-2.8-1.tar.bz2 "https://software.broadinstitute.org/gatk/download/auth?package=GATK-archive&version=2.8-1-g932cd3a" \
&& tar xjf GenomeAnalysisTK-2.8-1.tar.bz2 \
&& git clone https://github.com/broadinstitute/picard.git \
&& cd picard \
&& git checkout 1.105  \
&& ant -Djava6.home=/usr/lib/jvm/java-6-openjdk-amd64 -lib lib/ant package-commands \
&& cd .. \
&& git clone https://github.com/lh3/seqtk.git \
&& cd seqtk \
&& git checkout 08b3625 \
&& make \
&& cd .. \
&& wget -O bowtie.zip https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.1.0/bowtie2-2.1.0-source.zip/download \
&& unzip bowtie.zip \
&& cd bowtie2-2.1.0 \
&& make && cd .. \                        
&& wget https://sourceforge.net/projects/samtools/files/samtools/1.3.1/samtools-1.3.1.tar.bz2/download -O samtools-1.3.1.tar.bz2 \
&& tar -vxjf samtools-1.3.1.tar.bz2 \
&& cd samtools-1.3.1 \
&& make && cd .. \
&& wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.10.1.zip \
&& unzip fastqc_v0.10.1.zip \
&& update-java-alternatives --set java-1.6.0-openjdk-amd64 \
&& mkdir /ymap_software \
&& mv /root/* /ymap_software/ \
&& chmod guo+x /ymap_software/FastQC/*fastqc* \
&& chmod guo+x /ymap_software/bowtie2-2.1.0/bowtie2* \
&& chmod guo+x /ymap_software/samtools-1.3.1/samtools \
&& curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" \
&& python get-pip.py \
&& pip install numpy

ENV PATH="/usr/local/MATLAB/from-host/bin:${PATH}"

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

COPY . /var/www/public/

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

