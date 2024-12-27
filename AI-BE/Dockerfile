FROM python:3.12.8-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# 設置環境變數，防止 Python 生成 .pyc 文件
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV UV_SYSTEM_PYTHON=1

WORKDIR /opt/AI-BE
COPY ./requirements.txt /opt/AI-BE/requirements.txt

RUN uv pip install --no-cache-dir --upgrade -r requirements.txt

RUN echo "vm.swappiness=10" >> /etc/sysctl.conf

EXPOSE 8000

CMD ["fastapi", "run", "main.py", "--reload", "--host", "0.0.0.0", "--port", "8000"]