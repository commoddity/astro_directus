#!/bin/bash

# Script to stop Docker services and display status
# Usage: ./scripts/stop-services.sh

set -e

echo "🛑 Stopping Docker services..."
echo ""

# Stop and remove containers, networks
docker compose down

echo ""
echo "✅ All services have been stopped!"
echo ""
echo "📊 Status:"
echo "   - Containers: Stopped and removed"
echo "   - Network: Removed"
echo "   - Volumes: Preserved (in ./tmp/)"
echo ""
echo "💡 To start services again:"
echo "   yarn start"
echo ""
echo "🗑️  To completely clean up (including data):"
echo "   rm -rf tmp/"

