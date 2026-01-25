# Стадия сборки
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Копируем файлы зависимостей
COPY go.mod go.sum ./

# Загружаем зависимости
RUN go mod download

# Копируем исходный код
COPY *.go ./

# Собираем приложение
RUN CGO_ENABLED=0 GOOS=linux go build -o parcel-tracker .

# Финальная стадия
FROM alpine:3.19

WORKDIR /app

# Копируем скомпилированное приложение
COPY --from=builder /app/parcel-tracker .

# Копируем базу данных
COPY tracker.db .

# Запускаем приложение
CMD ["./parcel-tracker"]
