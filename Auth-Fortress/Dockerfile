# Используем базовый образ с GCC
FROM gcc:latest

# Устанавливаем базовые зависимости
RUN apt-get clean && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libpqxx-dev \
    cmake \
    make \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*



# Устанавливаем Boost из исходников (с поддержкой Boost.JSON)
WORKDIR /boost
RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.81.0/source/boost_1_81_0.zip && \
    unzip boost_1_81_0.zip && cd boost_1_81_0 && \
    ./bootstrap.sh --with-libraries=system,thread,json && \
    ./b2 install

# Указываем путь к библиотекам Boost
ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
# Копируем исходный код в контейнер

RUN wget https://releases.hashicorp.com/vault/1.17.6/vault_1.17.6_linux_amd64.zip && \
    unzip vault_1.17.6_linux_amd64.zip && \
    mv vault /usr/local/bin/ && \
    rm vault_1.17.6_linux_amd64.zip

RUN mkdir -p /etc/vault /etc/vault/templates /etc/vault/secrets

COPY vault-agent-config.hcl /etc/vault/
COPY templates/ /etc/vault/templates/

WORKDIR /app
COPY . .



# Собираем приложение
RUN g++ -std=c++17 -o app main.cpp -lpqxx -lpq -lboost_system -lboost_thread -lboost_json -pthread

# Открываем порт приложения
EXPOSE 8080

# Запускаем приложение
CMD ["sh", "-c", "vault agent -config=/etc/vault/vault-agent-config.hcl & ./app"]