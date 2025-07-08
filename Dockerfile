FROM python:3.9-slim

WORKDIR /app

COPY ./api/requirements.txt .
COPY ./api/main.py .
COPY src/notebooks/ ./notebooks/
COPY gcp.secrets.json .

ENV GOOGLE_APPLICATION_CREDENTIALS="/app/gcp.secrets.json"

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    mkdir /app/notebooks/output

EXPOSE 8080

CMD ["python3", "main.py"]