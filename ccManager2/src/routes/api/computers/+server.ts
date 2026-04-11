import { db } from "$lib/server/db";
import { computer } from "$lib/server/db/schema";
import { json } from "@sveltejs/kit";
import { eq } from "drizzle-orm";
import type { RequestHandler } from "./$types";

export const GET: RequestHandler = async () => {
  const allComputers = await db.query.computer.findMany({
    orderBy: (computer, { desc }) => [desc(computer.lastSeen)],
  });
  return json(allComputers);
};

export const POST: RequestHandler = async ({ request }) => {
  const body = await request.json();
  const { computerId, label, type } = body;

  if (computerId === undefined || !label || !type) {
    return json({ error: "Missing required fields" }, { status: 400 });
  }

  // Check if computer already exists
  const existing = await db.query.computer.findFirst({
    where: eq(computer.computerId, computerId),
  });

  if (existing) {
    const updated = await db
      .update(computer)
      .set({
        label,
        type,
        lastSeen: new Date(),
      })
      .where(eq(computer.computerId, computerId))
      .returning();
    return json({ message: "Computer updated", computer: updated[0] });
  } else {
    const inserted = await db
      .insert(computer)
      .values({
        computerId,
        label,
        type,
        lastSeen: new Date(),
      })
      .returning();
    return json({ message: "Computer registered", computer: inserted[0] }, { status: 201 });
  }
};
