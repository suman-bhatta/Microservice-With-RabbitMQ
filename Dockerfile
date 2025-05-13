FROM python:3.13.3-slim

# Set environment variables to avoid prompts during installation
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Create and set the working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file and install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the rest of the project
COPY . /app/

# Expose the port the app runs on
EXPOSE 8000

# Set the entrypoint to the entrypoint.prod.sh script
ENTRYPOINT ["/bin/bash", "/app/entrypoint.prod.sh"]