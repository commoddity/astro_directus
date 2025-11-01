#!/bin/bash

# Script to populate .env file with secure keys and default values
# Usage: ./scripts/populate-local-env.sh

set -e

ENV_FILE=".env"

# Check if .env already exists
if [ -f "${ENV_FILE}" ]; then
    echo "❌ Error: ${ENV_FILE} already exists!"
    echo ""
    echo "To regenerate, first remove the existing file:"
    echo "   rm ${ENV_FILE}"
    echo ""
    echo "Then run this script again."
    exit 1
fi

echo "🔧 Populating ${ENV_FILE} with secure configuration..."

# Generate secure random keys
echo "🔑 Generating secure keys..."
KEY=$(openssl rand -base64 32)
SECRET=$(openssl rand -base64 32)

# Create .env file
cat > "${ENV_FILE}" << EOF
# Directus Security Keys (REQUIRED)
KEY=${KEY}
SECRET=${SECRET}

# Admin Credentials
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=admin123

# Database Configuration
DB_DATABASE=directus
DB_USER=directus
DB_PASSWORD=directus

# Directus Public URL
PUBLIC_DIRECTUS_URL=http://localhost:8055
EOF

echo "✅ ${ENV_FILE} has been created with secure keys!"
echo ""
echo "📝 Configuration:"
echo "   - KEY: Generated securely ✓"
echo "   - SECRET: Generated securely ✓"
echo "   - Admin: admin@example.com / admin123"
echo "   - Database: directus / directus / directus"
echo "   - Directus URL: http://localhost:8055"
echo ""
echo "⚠️  IMPORTANT:"
echo "   - Change ADMIN_PASSWORD before production deployment"
echo "   - Never commit .env to version control"
echo ""
echo "🚀 Next steps:"
echo "   1. Start services: yarn dev:all"
echo "   2. Run setup: yarn setup"
echo "   3. Access Directus: http://localhost:8055"
