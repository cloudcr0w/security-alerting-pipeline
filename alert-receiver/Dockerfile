# Use official Python slim image
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Copy only requirements first to leverage Docker layer caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files
COPY . .

# Expose the Flask app port
EXPOSE 5000

# Add a basic health check for the container
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD curl --fail http://localhost:5000 || exit 1

# Set the default command to run the app
CMD ["python", "main.py"]
