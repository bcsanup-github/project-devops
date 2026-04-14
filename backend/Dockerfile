FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update && apt-get install -y netcat-openbsd && rm -rf /var/lib/apt/lists/*

# Install python dependencies
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of the code
COPY . .

# CRITICAL: Fix permissions for the entrypoint script
RUN chmod +x /usr/src/app/entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]