FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1


WORKDIR /app

COPY ./api /app/api

RUN pip install --no-cache-dir \
    fastapi \
    uvicorn \
    pydantic \
    requests \
    curl \
    prometheus-fastapi-instrumentator

RUN pip install --no-cache-dir fastapi uvicorn pydantic requests

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8080"]

EXPOSE 8000
