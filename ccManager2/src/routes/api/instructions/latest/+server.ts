import { db } from "$lib/server/db";
import { json } from "@sveltejs/kit";
import type { RequestHandler } from "./$types";

export const GET: RequestHandler = async () => {
  const latestInstructions = await db.query.instructions.findFirst({
    orderBy: (instr, { desc }) => [desc(instr.updatedAt)],
  });

  if (!latestInstructions) {
    return json({ error: "No instructions found" }, { status: 404 });
  }

  return json(latestInstructions);
};
