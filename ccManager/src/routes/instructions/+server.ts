import { db } from '$lib/server/db';
import { desc, eq } from 'drizzle-orm';
import type { RequestHandler } from './$types';
import { computer, instructions, type Computer } from '$lib/server/db/schema';
import { json } from '@sveltejs/kit';

// Get the instructions for the computer
// This will be used by the computer to download the instructions
// If no computerId is provided, the latest instructions will be downloaded
export const GET: RequestHandler = async (event) => {
	const computerId = event.url.searchParams.get('computerId');
	let _computer: Computer | undefined;
	if (computerId) {
		_computer = await db.query.computer.findFirst({
			where: eq(computer.computerId, computerId)
		});
	}
	const inst = await db.query.instructions.findFirst({
		where: _computer?.instructionsId ? eq(instructions.id, _computer.instructionsId) : undefined,
		orderBy: [desc(instructions.updatedAt)]
	});
	return json(inst);
};

// Insert new instructions
export const POST: RequestHandler = async ({ request }) => {
	const { version, body } = await request.json();
	await db
		.insert(instructions)
		.values({
			version,
			body
		})
		.returning();
	return new Response('Instructions added successfully', { status: 201 });
};
