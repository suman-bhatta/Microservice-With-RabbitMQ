#!/bin/bash
set -e

# Function to wait for the database
wait_for_db() {
  echo "⏳ Waiting for database at $DB_HOST:$DB_PORT..."
  TIMEOUT=30  # Maximum wait time in seconds
  elapsed_time=0
  while ! nc -z "$DB_HOST" "$DB_PORT"; do
    sleep 0.5
    elapsed_time=$((elapsed_time + 1))
    if [ "$elapsed_time" -ge "$TIMEOUT" ]; then
      echo "❌ Timeout reached: Unable to connect to database at $DB_HOST:$DB_PORT."
      exit 1
    fi
  done
  echo "✅ Database is up."
}

# Run Django management tasks
run_migrations() {
  echo "🔄 Running migrations..."
  python manage.py migrate --noinput
}

collect_static() {
  echo "📦 Collecting static files..."
  python manage.py collectstatic --noinput
}

start_app() {
  echo "🚀 Starting Gunicorn server..."
  exec gunicorn user_service.wsgi:application --bind 0.0.0.0:8000 --workers 3
}

# Main flow
wait_for_db
run_migrations
collect_static
start_app
