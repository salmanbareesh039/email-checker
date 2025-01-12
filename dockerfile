# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install system dependencies for Rust and the email checker
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Clone the email checker repository and build it
RUN git clone https://github.com/salmanbareesh039/check-if-email-exists.git /app/check-if-email-exists
WORKDIR /app/check-if-email-exists
RUN cargo build --release

# Set the working directory back to /app
WORKDIR /app

# Copy the current directory contents into the container
COPY . .

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]
