# Use official Python 3.9 slim image
FROM python:3.9-slim

LABEL maintainer="Amazon AI <sage-learner@amazon.com>"

# Install OS packages (nginx & required build tools)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx \
        build-essential \
        gcc \
        libatlas-base-dev \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install updated Python packages with versions compatible with Python 3.9
RUN pip install --no-cache-dir \
    numpy==1.23.5 \
    scipy==1.9.3 \
    scikit-learn==1.2.2 \
    pandas \
    flask \
    gevent \
    gunicorn

# Set environment variables
ENV PYTHONUNBUFFERED=TRUE \
    PYTHONDONTWRITEBYTECODE=TRUE \
    PATH="/opt/program:${PATH}"

# Copy your application code into the container
COPY decision_trees /opt/program

# Set the working directory
WORKDIR /opt/program

# Expose port your Flask app runs on (default: 5000)
EXPOSE 5000

# Optional: HEALTHCHECK for Docker/K8s
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD curl -f http://localhost:8080/ping || exit 1


# Command to run your Flask app via Gunicorn
# Replace 'app:app' with the actual module:app_name if different
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
