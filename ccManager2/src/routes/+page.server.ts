import { db } from "$lib/server/db";
import { computer, instructions } from "$lib/server/db/schema";
import { count, eq, gt } from "drizzle-orm";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async () => {
  const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000);

  const [stats] = await db
    .select({
      total: count(computer.id),
    })
    .from(computer);

  const onlineStats = await db
    .select({
      online: count(computer.id),
    })
    .from(computer)
    .where(gt(computer.lastSeen, fiveMinutesAgo));

  const latestInstr = await db.query.instructions.findFirst({
    orderBy: (instr, { desc }) => [desc(instr.updatedAt)],
  });

  const recentComputers = await db.query.computer.findMany({
    limit: 5,
    orderBy: (comp, { desc }) => [desc(comp.lastSeen)],
  });

  return {
    stats: {
      total: stats.total,
      online: onlineStats[0].online,
      latestVersion: latestInstr?.version || "N/A",
    },
    recentComputers,
  };
};
