FROM python:3.13-slim

WORKDIR /app

# 先装依赖再拷代码: 源码变动时依赖层走缓存
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app

# 会话密钥/自有库/缓存统一落到 /app/data, 便于挂卷持久化
# (MYHOME_SECRET_FILE 是应用认可的会话密钥路径环境变量)
ENV MYHOME_SECRET_FILE=/app/data/.session_secret \
    MYTESLA_DB=sqlite:////app/data/mytesla.db \
    TZ_NAME=Asia/Shanghai

RUN mkdir -p /app/data

EXPOSE 8500

CMD ["python", "-m", "app"]
