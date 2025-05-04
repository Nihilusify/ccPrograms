import { db } from '$lib/server/db';
import { count, eq } from 'drizzle-orm';
import { list, listItem } from '$lib/server/db/schema';
import type { RequestHandler } from '../../api/util/$types';

export const GET: RequestHandler = async (event) => {
	if (!('func' in event.params)) {
		return new Response('Invalid function name', { status: 400 });
	}

	if (event.params?.func === 'generateName') {
		const name = await getRandomName();
		return new Response(JSON.stringify(name));
	}

	return new Response('Invalid function name', { status: 400 });
};

// Get list of names from db, randomly select one and return it
// This will be used by the computer to generate a random name
const getRandomName = async () => {
	const namesListIdRes = await db.query.list.findFirst({
		where: eq(list.name, 'names'),
		columns: {
			id: true
		}
	});

	const namesListId = namesListIdRes?.id;

	if (!namesListId) {
		throw new Error('Names list not found');
	}

	const namesCount = await db
		.select({ count: count() })
		.from(listItem)
		.where(eq(listItem.listId, namesListId));

	const name = await db.query.listItem.findFirst({
		columns: { name: true },
		where: eq(listItem.listId, namesListId),
		offset: Math.floor(Math.random() * namesCount[0].count)
	});

	return name;
};
