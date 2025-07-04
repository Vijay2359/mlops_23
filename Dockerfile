# Use official Python 3 base image with pip pre-installed
FROM python:3.9-slim

LABEL maintainer="Amazon AI <sage-learner@amazon.com>"

# Install OS packages (only if needed — you had nginx)
RUN apt-get -y update && apt-get install -y --no-install-recommends \
        nginx \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages (pip already exists in python:3.9)
RUN pip install numpy==1.16.2 scipy==1.2.1 scikit-learn==0.20.2 pandas flask gevent gunicorn \
    && rm -rf /root/.cache

# Keep your environment variables
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"

# Copy your application code
COPY decision_trees /opt/program

# Set working directory
WORKDIR /opt/program
