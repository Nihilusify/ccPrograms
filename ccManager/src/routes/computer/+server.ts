import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { computer } from '$lib/server/db/schema';

// Get a list of computers
export const GET: RequestHandler = async () => {
	const computers = await db.query.computer.findMany();
	return json(computers);
};

// Insert a new computer
export const POST: RequestHandler = async ({ request }) => {
	const { computerId, label, type } = await request.json();
	await db
		.insert(computer)
		.values({
			computerId,
			label,
			type
		})
		.returning();
	return new Response('Computer added successfully', { status: 201 });
};
