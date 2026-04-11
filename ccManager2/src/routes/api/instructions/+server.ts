import { db } from "$lib/server/db";
import { instructions } from "$lib/server/db/schema";
import { json } from "@sveltejs/kit";
import type { RequestHandler } from "./$types";

export const GET: RequestHandler = async () => {
  const allInstructions = await db.query.instructions.findMany({
    orderBy: (instr, { desc }) => [desc(instr.updatedAt)],
  });
  return json(allInstructions);
};

export const POST: RequestHandler = async ({ request }) => {
  const { version, body } = await request.json();

  if (!version || !body) {
    return json({ error: "Missing version or body" }, { status: 400 });
  }

  const newInstructions = await db
    .insert(instructions)
    .values({
      version,
      body,
      updatedAt: new Date(),
    })
    .returning();

  return json(newInstructions[0], { status: 201 });
};
