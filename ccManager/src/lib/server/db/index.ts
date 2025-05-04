import { env } from '$env/dynamic/private';
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './schema';

if (!env.DATABASE_URL) throw new Error('DATABASE_URL is not set');

const client = postgres(env.DATABASE_URL);

export const db = drizzle(client, { schema });

// Uncommented the following lines to reset the database and seed it with random data
// TODO: Convert this to a function that can be called by the frontend

// await reset(db, schema);
// // Create list for names and generate/seed some random names
// const insertReturn = await db
// 	.insert(schema.list)
// 	.values([{ name: 'names', description: 'List of names' }])
// 	.returning({ namesListId: schema.list.id });

// const namesListId = insertReturn[0].namesListId;

// await seed(db, { listItem }).refine((f) => ({
// 	listItem: {
// 		count: 1000,
// 		columns: {
// 			listId: f.int({ minValue: namesListId, maxValue: namesListId }),
// 			name: f.firstName()
// 		}
// 	}
// }));
