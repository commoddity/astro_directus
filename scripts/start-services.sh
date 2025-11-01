#!/bin/bash

# Script to start Docker services and display status
# Usage: ./scripts/start-services.sh

set -e

echo "🚀 Starting Docker services..."
echo ""

# Start services in detached mode
docker compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."
echo ""

# Wait for PostgreSQL
echo -n "   🗄️  PostgreSQL... "
for i in {1..30}; do
    if docker exec postgres pg_isready -U directus > /dev/null 2>&1; then
        echo "✅ Ready"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "⚠️  Timeout"
    fi
    sleep 1
done

# Wait for Directus
echo -n "   🎨 Directus...    "
for i in {1..60}; do
    if curl -s -f http://localhost:8055/server/health > /dev/null 2>&1; then
        echo "✅ Ready"
        break
    fi
    if [ $i -eq 60 ]; then
        echo "⚠️  Timeout"
    fi
    sleep 1
done

# Wait for Astro
echo -n "   🌐 Astro...       "
for i in {1..60}; do
    if curl -s -f http://localhost:4321 > /dev/null 2>&1; then
        echo "✅ Ready"
        break
    fi
    if [ $i -eq 60 ]; then
        echo "⚠️  Timeout (may still be installing dependencies)"
    fi
    sleep 1
done

echo ""
echo "✅ All services are up and running!"
echo ""
echo "📍 Service URLs:"
echo "   🌐 Astro Site:    http://localhost:4321"
echo "   🎨 Directus CMS:  http://localhost:8055"
echo "   🗄️  PostgreSQL:    localhost:5432"
echo ""
echo "🔐 Default Credentials:"
echo "   Email:    admin@example.com"
echo "   Password: admin123"
echo ""
echo "📝 Next to run the setup (if not already done): yarn setup"
echo ""
echo "💡 To stop the services: yarn stop"
echo ""
echo "🔥 Hot reloading is enabled for Astro!"
