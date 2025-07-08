FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
COPY main.py .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["python3", "main.py"]