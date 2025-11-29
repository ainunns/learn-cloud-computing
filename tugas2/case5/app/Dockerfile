FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .
COPY simulate_data.sh .
RUN chmod +x simulate_data.sh

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "main:app", "--workers", "2", "--threads", "4"]

