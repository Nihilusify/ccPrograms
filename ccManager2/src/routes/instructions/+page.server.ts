import { db } from "$lib/server/db";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async () => {
  const allInstructions = await db.query.instructions.findMany({
    orderBy: (instr, { desc }) => [desc(instr.updatedAt)],
  });

  return {
    instructions: allInstructions,
  };
};
