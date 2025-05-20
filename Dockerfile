# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory
WORKDIR /app

# Copy local code to the container image
COPY . .

# Install dependencies
RUN pip install --no-cache-dir fastapi uvicorn

# Command to run the API
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
