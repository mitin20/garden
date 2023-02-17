# Base, including any build dependencies
FROM python:3.11.2-alpine3.17 as builder

COPY requirements.txt .
RUN pip install --user -r requirements.txt

FROM python:3.11.2-alpine3.17 as production

# Create a non-root user to prevent container escape
RUN adduser -S appuser -h /home/appuser

# Copy the user site-packages from the builder image
COPY --from=builder	/root/.local /home/appuser/.local

# Set PYTHONPATH and PATH to include the user site-packages
ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONPATH=/home/appuser/.local/lib/python4.11/site-packages:$PYTHONPATH

# Copy our app source files
COPY app /home/appuser/app/

WORKDIR /home/appuser/app/
USER appuser

# Run web server
CMD [ "python", "-m", "main"]

FROM gardendev/garden:0.12.51-buster as devcontainer