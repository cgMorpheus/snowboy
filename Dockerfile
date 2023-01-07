FROM ubuntu:16.04

RUN apt update && apt --yes --force-yes install wget unzip build-essential python python-pip python-dev portaudio19-dev python-pyaudio python3-pyaudio sox libatlas-base-dev libpcre3 libpcre3-dev
RUN python -m pip install --upgrade pip==20.3.4
RUN pip install pyaudio
RUN pip install numpy==1.16.6

RUN wget http://downloads.sourceforge.net/swig/swig-3.0.10.tar.gz && \
    tar -xovzf swig-3.0.10.tar.gz && \
    cd swig-3.0.10/ && \
    ./configure --prefix=/usr --without-clisp --without-maximum-compile-warnings && \
    make && \
    make install

RUN wget https://github.com/cgMorpheus/snowboy/archive/refs/heads/master.zip && unzip master.zip

RUN cd snowboy-master/swig/Python/ && \
    make

RUN cd snowboy-master/ && \
    cd examples/Python && \
    pip install -r requirements.txt

RUN apt -y remove wget unzip build-essential portaudio19-dev && rm -fr swig-3.0.10/ && apt -y autoremove && apt clean && rm -rf /var/lib/apt/lists/*

CMD cd snowboy-master/ && \
    cd examples/Python && \
    python generate_pmdl.py -r1=model/record1.wav -r2=model/record2.wav -r3=model/record3.wav -lang=en -n=model/hotword.pmdl
