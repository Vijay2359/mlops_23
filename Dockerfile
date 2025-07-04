# Modern base image with Python 3
FROM python:3.9-slim

LABEL maintainer="Amazon AI <sage-learner@amazon.com>"

# Install OS-level packages if needed (keeping minimal set: nginx for serving)
RUN apt-get -y update && apt-get install -y --no-install-recommends \
        nginx \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies directly, pip is already available in python:3 images
RUN pip install numpy==1.16.2 scipy==1.2.1 scikit-learn==0.20.2 pandas flask gevent gunicorn \
    && rm -rf /root/.cache

# Keep existing environment variables
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"

# Copy your program
COPY decision_trees /opt/program

# Set working directory
WORKDIR /opt/program

# Optionally add a default command to run the server
# CMD ["python", "serve"]   # <-- Uncomment or adjust if you have an entrypoint script
