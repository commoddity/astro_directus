import { createDirectus, rest, readItems, readItem } from '@directus/sdk';

// Chapter collection schema
export interface Chapter {
    id: number;
    status?: 'published' | 'draft' | 'archived';
    sort: number | null;
    date_created: string;
    date_updated: string;
    title: string;
    slug: string;
    content: string;
    order: number;
    images: any[];
    translations?: ChapterTranslation[];
}

export interface ChapterTranslation {
    id: number;
    chapters_id: number;
    languages_code: string;
    title: string;
    slug: string;
    content: string;
}

interface DirectusSchema {
    chapters: Chapter[];
}

const DIRECTUS_URL = import.meta.env.PUBLIC_DIRECTUS_URL || 'http://localhost:8055';
const directus = createDirectus<DirectusSchema>(DIRECTUS_URL).with(rest());

/**
 * Fetch all chapters, sorted by order
 */
export async function getChapters(): Promise<Chapter[]> {
    try {
        const chapters = await directus.request(
            readItems('chapters', {
                sort: ['order'],
                fields: ['*'],
            })
        );
        return chapters;
    } catch (error) {
        console.error('Error fetching chapters:', error);
        return [];
    }
}

/**
 * Fetch a single chapter by slug
 */
export async function getChapterBySlug(slug: string): Promise<Chapter | null> {
    try {
        const chapters = await directus.request(
            readItems('chapters', {
                filter: { slug: { _eq: slug } },
                limit: 1,
                fields: ['*'],
            })
        );
        return chapters[0] || null;
    } catch (error) {
        console.error(`Error fetching chapter with slug ${slug}:`, error);
        return null;
    }
}

/**
 * Fetch a single chapter by ID
 */
export async function getChapterById(id: number): Promise<Chapter | null> {
    try {
        const chapter = await directus.request(
            readItem('chapters', id, {
                fields: ['*'],
            })
        );
        return chapter;
    } catch (error) {
        console.error(`Error fetching chapter with id ${id}:`, error);
        return null;
    }
}

/**
 * Get the Directus assets URL for uploaded files
 */
export function getAssetUrl(fileId: string): string {
    return `${DIRECTUS_URL}/assets/${fileId}`;
}

/**
 * Get all chapter slugs for static path generation
 */
export async function getChapterSlugs(): Promise<string[]> {
    try {
        const chapters = await directus.request(
            readItems('chapters', {
                fields: ['slug'],
            })
        );
        return chapters.map((chapter) => chapter.slug);
    } catch (error) {
        console.error('Error fetching chapter slugs:', error);
        return [];
    }
}
