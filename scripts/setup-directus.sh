#!/usr/bin/env bash
set -e

# Load environment variables
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

DIRECTUS_URL="${DIRECTUS_URL:-${PUBLIC_DIRECTUS_URL:-http://localhost:8055}}"
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@example.com}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin123}"

echo "🚀 Setting up Directus chapters collection..."
echo ""

# Login and get access token
echo "📝 Logging in as admin..."
TOKEN=$(curl -s "${DIRECTUS_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${ADMIN_EMAIL}\",\"password\":\"${ADMIN_PASSWORD}\"}" \
  | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ Login failed. Check your credentials in .env"
  exit 1
fi

echo "✅ Logged in successfully"
echo ""

# Create chapters collection
echo "📦 Creating chapters collection..."
COLLECTION_EXISTS=$(curl -s "${DIRECTUS_URL}/collections/chapters" \
  -H "Authorization: Bearer ${TOKEN}" \
  | grep -c '"collection":"chapters"' || echo "0")

if [ "$COLLECTION_EXISTS" -eq "0" ]; then
  curl -s -X POST "${DIRECTUS_URL}/collections" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{
      "collection": "chapters",
      "meta": {
        "icon": "book",
        "note": "Chapter content for the site",
        "display_template": "{{title}}",
        "hidden": false,
        "singleton": false
      },
      "schema": {
        "name": "chapters"
      }
    }' > /dev/null
  echo "✅ Created chapters collection"
else
  echo "ℹ️  Chapters collection already exists"
fi

# Create fields
echo ""
echo "📋 Creating fields..."

# Title field
curl -s -X POST "${DIRECTUS_URL}/fields/chapters" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "field": "title",
    "type": "string",
    "schema": {
      "is_nullable": false
    },
    "meta": {
      "interface": "input",
      "required": true,
      "translations": [{"language": "en-US", "translation": "Title"}]
    }
  }' > /dev/null 2>&1 && echo "✅ Created title field" || echo "ℹ️  Title field exists"

# Slug field
curl -s -X POST "${DIRECTUS_URL}/fields/chapters" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "field": "slug",
    "type": "string",
    "schema": {
      "is_nullable": false,
      "is_unique": true
    },
    "meta": {
      "interface": "input",
      "special": ["slug"],
      "required": true,
      "translations": [{"language": "en-US", "translation": "Slug"}]
    }
  }' > /dev/null 2>&1 && echo "✅ Created slug field" || echo "ℹ️  Slug field exists"

# Content field
curl -s -X POST "${DIRECTUS_URL}/fields/chapters" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "field": "content",
    "type": "text",
    "schema": {
      "is_nullable": false
    },
    "meta": {
      "interface": "input-rich-text-html",
      "required": true,
      "translations": [{"language": "en-US", "translation": "Content"}]
    }
  }' > /dev/null 2>&1 && echo "✅ Created content field" || echo "ℹ️  Content field exists"

# Order field
curl -s -X POST "${DIRECTUS_URL}/fields/chapters" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "field": "order",
    "type": "integer",
    "schema": {
      "is_nullable": false,
      "default_value": 0
    },
    "meta": {
      "interface": "input",
      "required": true,
      "options": {"min": 0},
      "translations": [{"language": "en-US", "translation": "Order"}]
    }
  }' > /dev/null 2>&1 && echo "✅ Created order field" || echo "ℹ️  Order field exists"

# Images field (many-to-many with directus_files)
curl -s -X POST "${DIRECTUS_URL}/fields/chapters" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "field": "images",
    "type": "alias",
    "meta": {
      "interface": "files",
      "special": ["files"],
      "translations": [{"language": "en-US", "translation": "Images"}]
    }
  }' > /dev/null 2>&1 && echo "✅ Created images field" || echo "ℹ️  Images field exists"

# Setup public permissions
echo ""
echo "🔓 Configuring public permissions..."

# Chapters read permission
curl -s -X POST "${DIRECTUS_URL}/permissions" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "collection": "chapters",
    "action": "read",
    "role": null,
    "permissions": {},
    "fields": ["*"]
  }' > /dev/null 2>&1 && echo "✅ Configured chapters read permissions" || echo "ℹ️  Chapters permissions exist"

# Files read permission
curl -s -X POST "${DIRECTUS_URL}/permissions" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "collection": "directus_files",
    "action": "read",
    "role": null,
    "permissions": {},
    "fields": ["*"]
  }' > /dev/null 2>&1 && echo "✅ Configured files read permissions" || echo "ℹ️  Files permissions exist"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Visit ${DIRECTUS_URL}/admin"
echo "2. Login with your credentials"
echo "3. Navigate to Content → Chapters"
echo "4. Create your first chapter"
echo ""

