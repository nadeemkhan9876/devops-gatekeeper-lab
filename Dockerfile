# SECURE: Using modern, maintained Python image
FROM python:3.11-slim

# Minimal command to keep the container valid
CMD ["python", "--version"]
