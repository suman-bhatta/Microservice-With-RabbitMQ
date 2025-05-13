#!/bin/bash
set -e

# Function to wait for the database
wait_for_db() {
  echo "⏳ Waiting for database at $DB_HOST:$DB_PORT..."
  while ! nc -z "$DB_HOST" "$DB_PORT"; do
    sleep 0.5
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
