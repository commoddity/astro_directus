# Astro + Directus Template

A modern, self-hosted content management system built with Astro and Directus CMS. Perfect for documentation sites, blogs, or any content-driven website.

## Table of Contents <!-- omit in toc -->

- [Astro + Directus Template](#astro--directus-template)
  - [Features](#features)
  - [Tech Stack](#tech-stack)
  - [🚀 Quick Start for Development](#-quick-start-for-development)
    - [Prerequisites](#prerequisites)
    - [1. Clone and Install](#1-clone-and-install)
    - [2. Configure Environment](#2-configure-environment)
    - [3. Start Development Environment](#3-start-development-environment)
    - [4. Setup Directus Schema](#4-setup-directus-schema)
    - [5. Login to Directus](#5-login-to-directus)
  - [📝 How to Add and Format Chapters](#-how-to-add-and-format-chapters)
    - [Adding a New Chapter](#adding-a-new-chapter)
    - [Formatting Chapter Content](#formatting-chapter-content)
      - [Rich Text Formatting](#rich-text-formatting)
      - [HTML Formatting](#html-formatting)
      - [Markdown Support](#markdown-support)
    - [Adding Images to Chapters](#adding-images-to-chapters)
      - [Method 1: Using the Images Field (Recommended)](#method-1-using-the-images-field-recommended)
      - [Method 2: Inline Images in Content](#method-2-inline-images-in-content)
      - [Image Best Practices](#image-best-practices)
    - [Chapter Ordering](#chapter-ordering)
  - [📁 Project Structure](#-project-structure)
  - [🔧 Configuration](#-configuration)
    - [Environment Variables](#environment-variables)
  - [📚 Documentation](#-documentation)

## Features

- 📝 Chapter-based content with rich text editing
- 🚀 Static site generation for optimal performance
- 🔒 Self-hosted with complete data ownership
- 🌍 Built-in i18n support via Directus
- 🎨 Clean, responsive design
- 🐳 Docker-based deployment

## Tech Stack

- **[Astro](https://astro.build)** - Static site generator
- **[Directus](https://directus.io)** - Headless CMS
- **PostgreSQL** - Database
- **Docker** - Containerization

---

## 🚀 Quick Start for Development

### Prerequisites

- **Node.js 18+** and **Yarn**
- **Docker Desktop** (or Docker Engine + Docker Compose)

### 1. Clone and Install

```bash
git clone git@github.com:commoddity/astro_directus.git
cd astro_directus
yarn install
```

### 2. Configure Environment

```bash
# Automatically generate .env with secure keys
yarn env:init
```

This script (`scripts/populate-local-env.sh`) will:
- Generate secure random keys for `KEY` and `SECRET`
- Create `.env` with all necessary configuration
- Set default admin credentials

**⚠️ WARNING: DO NOT reuse these keys in production.**

### 3. Start Development Environment

```bash
# Start all services with status monitoring
yarn start
```

This script (`scripts/start-services.sh`) will:
- Start Docker services (Directus + PostgreSQL)
- Wait for all services to be ready
- Display service URLs and credentials
- Show helpful next steps

**Example output:**
```
🚀 Starting Docker services...

[+] Running 4/4
 ✔ Network astro-directus-network  Created
 ✔ Container postgres              Healthy
 ✔ Container directus              Started
 ✔ Container astro                 Started

⏳ Waiting for services to be ready...

   🗄️ PostgreSQL... ✅ Ready
   🎨 Directus...    ✅ Ready
   🌐 Astro...       ✅ Ready

✅ All services are up and running!

📍 Service URLs:
   🌐 Astro Site:    http://localhost:4321
   🎨 Directus CMS:  http://localhost:8055
   🗄️ PostgreSQL:    localhost:5432

🔐 Default Credentials:
   Email:    admin@example.com
   Password: admin123

📝 Next to run the setup (if not already done): yarn setup

💡 To stop the services: yarn stop

🔥 Hot reloading is enabled for Astro!
```

### 4. Setup Directus Schema

Open a new terminal and run:

```bash
yarn setup
```

This creates the `chapters` collection and configures permissions.

### 5. Login to Directus

Visit **http://localhost:8055** and login:
- **Email**: `admin@example.com`
- **Password**: `admin123`

**🎉 You're ready to add content!**

---

## 📝 How to Add and Format Chapters

### Adding a New Chapter

1. **Login to Directus** at http://localhost:8055
2. Navigate to **Content → Chapters**
3. Click **"+ Create Item"**
4. Fill in the fields:
   - **Title**: Display name (e.g., "Getting Started")
   - **Slug**: URL-friendly identifier (e.g., "getting-started")
   - **Order**: Number for sorting (1, 2, 3, etc.)
   - **Content**: Your chapter content (see formatting below)
   - **Images**: Optional images (see below)
5. Click **Save**

The chapter will immediately appear on your site at `http://localhost:4321/chapters/[slug]`

### Formatting Chapter Content

Directus supports **rich text** and **HTML** in the content field. You can use:

#### Rich Text Formatting

Use the WYSIWYG editor in Directus:
- **Bold**, *Italic*, ~~Strikethrough~~
- Headings (H2, H3, etc.)
- Bulleted and numbered lists
- Blockquotes
- Code blocks
- Links

#### HTML Formatting

You can also write raw HTML for more control:

```html
<h2>Section Title</h2>
<p>This is a paragraph with <strong>bold text</strong>.</p>

<ul>
  <li>List item 1</li>
  <li>List item 2</li>
</ul>

<blockquote>
  This is a quote
</blockquote>

<pre><code>
// Code block
function example() {
  return "Hello World";
}
</code></pre>
```

#### Markdown Support

If you prefer Markdown, you can:
1. Write in Markdown
2. Convert to HTML using a tool like [Markdown to HTML](https://markdowntohtml.com/)
3. Paste the HTML into the content field

### Adding Images to Chapters

#### Method 1: Using the Images Field (Recommended)

1. In the chapter editor, find the **Images** field
2. Click **"+ Add New"** or **"Select Existing"**
3. Upload your image(s) or choose from library
4. Save the chapter

Images will automatically display below the chapter content.

#### Method 2: Inline Images in Content

1. **Upload image to Directus**:
   - Go to **File Library** in Directus
   - Upload your image
   - Copy the file ID (visible in the URL or file details)

2. **Reference in content**:
   ```html
   <img src="http://localhost:8055/assets/[FILE_ID]" alt="Description" />
   ```

   Or use the WYSIWYG editor's image insert button.

#### Image Best Practices

- **File formats**: Use JPEG for photos, PNG for graphics with transparency
- **Size**: Resize large images before upload (recommended max width: 1200px)
- **Alt text**: Always include descriptive alt text for accessibility
- **File names**: Use descriptive names (e.g., `chapter-1-diagram.png`)

### Chapter Ordering

Chapters are sorted by the **Order** field:
- Set `Order: 1` for the first chapter
- Set `Order: 2` for the second, etc.
- Navigation between chapters respects this order

---

## 📁 Project Structure

```
astro_directus/
├── src/
│   ├── pages/
│   │   ├── index.astro           # Homepage
│   │   └── chapters/
│   │       ├── index.astro       # All chapters list
│   │       └── [slug].astro      # Individual chapter page
│   └── lib/
│       └── directus.ts           # Directus API client
├── public/
│   └── favicon.svg               # Site favicon
├── scripts/
│   ├── populate-local-env.sh     # Generate .env with secure keys
│   ├── start-services.sh         # Start all services with monitoring
│   ├── stop-services.sh          # Stop all services
│   └── setup-directus.sh         # Directus schema setup automation
├── tmp/                          # Docker volumes (gitignored)
│   ├── uploads/                  # Directus uploaded files
│   └── data/                     # PostgreSQL database
├── .env                          # Environment config (gitignored)
├── .env.example                  # Environment template
├── docker-compose.yml            # Docker services config
├── astro.config.mjs              # Astro configuration
├── package.json                  # Dependencies & scripts
└── tsconfig.json                 # TypeScript config
```

---

## 🔧 Configuration

### Environment Variables

Key variables in `.env`:

| Variable              | Description             | Default                   |
| --------------------- | ----------------------- | ------------------------- |
| `KEY`                 | Directus encryption key | *(generate with openssl)* |
| `SECRET`              | Directus session secret | *(generate with openssl)* |
| `ADMIN_EMAIL`         | Initial admin email     | `admin@example.com`       |
| `ADMIN_PASSWORD`      | Initial admin password  | `admin123`                |
| `PUBLIC_DIRECTUS_URL` | Directus API URL        | `http://localhost:8055`   |
| `DB_DATABASE`         | Database name           | `directus`                |
| `DB_USER`             | Database user           | `directus`                |
| `DB_PASSWORD`         | Database password       | `directus`                |

---

## 📚 Documentation

- [Astro Documentation](https://docs.astro.build)
- [Directus Documentation](https://docs.directus.io)
- [Directus SDK Reference](https://docs.directus.io/guides/sdk/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---
