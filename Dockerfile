# This Dockerfile provides a Minimum Working Example (MWE) to start developing
# inside a dev-container.
#
# * * It is not meant to be production quality * *

FROM python:3.9
WORKDIR /app


RUN python3 -m pip install --upgrade pip

COPY requirements.txt requirements.txt
RUN python3 -m pip install --no-cache-dir -r requirements.txt

COPY requirements-dev.txt requirements-dev.txt
RUN python3 -m pip install --no-cache-dir -r requirements-dev.txt

COPY . .

RUN pre-commit install
