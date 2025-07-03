FROM python:3.9-slim

WORKDIR /app

COPY ./api/requirements.txt .
COPY ./api/main.py .
COPY src/notebooks/ ./notebooks/
COPY gcp.secrets.json .

ENV GOOGLE_APPLICATION_CREDENTIALS="/app/gcp.secrets.json"

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]