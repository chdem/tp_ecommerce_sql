FROM python:3.12-slim


WORKDIR /app


COPY script/ .
COPY docker/.env .env

RUN ls -a
RUN cat .env

RUN pip install psycopg[binary]
RUN pip install dotenv


CMD ["python", "main.py"]