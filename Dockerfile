FROM centos

RUN yum update -y \
    && curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" \
    && yum install python3 -y \
    && python3 get-pip.py \
    && pip install flask

COPY . /src

EXPOSE 80

CMD cd /src && python home.py