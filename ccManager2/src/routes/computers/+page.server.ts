import { db } from "$lib/server/db";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async () => {
  const allComputers = await db.query.computer.findMany({
    orderBy: (comp, { desc }) => [desc(comp.lastSeen)],
  });

  return {
    computers: allComputers,
  };
};
