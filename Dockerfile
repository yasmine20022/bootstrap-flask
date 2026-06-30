FROM python:3-slim
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*
COPY . ./
RUN pip install --no-cache-dir . || pip install flask gunicorn
COPY . /app/
RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser
EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD curl --fail http://localhost:5000 || exit 1
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:5000"]