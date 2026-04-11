import { pgTable, serial, integer, text, timestamp } from "drizzle-orm/pg-core";

// Instructions for computers to download
export const instructions = pgTable("instructions", {
  id: serial("id").primaryKey(),
  version: text("version").notNull(), // version of the instructions
  body: text("body").notNull(), // instructions to download
  updatedAt: timestamp("updated_at", { withTimezone: true, mode: "date" }).notNull().defaultNow(),
});

export const computer = pgTable("computer", {
  id: serial("id").primaryKey(),
  computerId: integer("computer_id").notNull(), // assigned by CC (os.getComputerID())
  label: text("label").notNull(), // computer label (os.getComputerLabel())
  type: text("type").notNull(), // e.g. computer, turtle, advanced turtle, etc.
  instructionsId: integer("instructions_id").references(() => instructions.id), // instructions to download. If null, latest instructions will be downloaded
  lastSeen: timestamp("last_seen", { withTimezone: true, mode: "date" }).notNull().defaultNow(),
});

// Generic list table of lists. E.g. list of names to generate random names from
export const list = pgTable("list", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(), // name of the list
  description: text("description").notNull(), // description of the list (e.g. names, items, etc.)
});

// Generic list item table. E.g. list of names to generate random names from
export const listItem = pgTable("list_item", {
  id: serial("id").primaryKey(),
  listId: integer("list_id")
    .notNull()
    .references(() => list.id),
  name: text("name").notNull(), // name of the list item
});
