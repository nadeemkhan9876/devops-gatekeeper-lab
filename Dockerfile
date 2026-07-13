# VULNERABLE: Using old, end-of-life Python image
FROM python:3.6

# Minimal command to keep the container valid
CMD ["python", "--version"]
