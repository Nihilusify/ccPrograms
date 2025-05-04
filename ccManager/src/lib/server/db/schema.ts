import { pgTable, serial, text, integer, timestamp } from 'drizzle-orm/pg-core';

export const user = pgTable('user', {
	id: text('id').primaryKey(),
	username: text('username').notNull().unique(),
	passwordHash: text('password_hash').notNull()
});

export const session = pgTable('session', {
	id: text('id').primaryKey(),
	userId: text('user_id')
		.notNull()
		.references(() => user.id),
	expiresAt: timestamp('expires_at', { withTimezone: true, mode: 'date' }).notNull()
});

// Table to store which user has access to which resources/table (e.g. computer, etc.)
export const userAccess = pgTable('user_access', {
	id: serial('id').primaryKey(),
	userId: text('user_id')
		.notNull()
		.references(() => user.id),
	resourceId: text('resource_id').notNull(), // e.g. computer id, etc.
	resourceType: text('resource_type').notNull(), // e.g.computer, etc.
	accessLevel: integer('access_level').notNull(), // e.g. 0 = read, 1 = write, 2 = admin
	createdAt: timestamp('created_at', { withTimezone: true, mode: 'date' }).notNull(),
	updatedAt: timestamp('updated_at', { withTimezone: true, mode: 'date' }).notNull()
});

// Instructions for computers to download
export const instructions = pgTable('instructions', {
	id: serial('id').primaryKey(),
	version: text('version').notNull(), // version of the instructions
	body: text('body').notNull(), // instructions to download
	updatedAt: timestamp('updated_at', { withTimezone: true, mode: 'date' }).notNull().defaultNow()
});

export const computer = pgTable('computer', {
	id: serial('id').primaryKey(),
	computerId: text('computer_id').notNull(), // assigned by CC (os.getComputerID())
	label: text('label').notNull(), // computer label (os.getComputerLabel())
	type: text('type').notNull(), // e.g. computer, turtle, advanced turtle, etc.
	instructionsId: integer('instructions_id').references(() => instructions.id) // instructions to download.  If null, latest instructions will be downloaded
	// createdBy: text('created_by')
	// 	.notNull()
	// 	.references(() => user.id),
	// createdAt: timestamp('created_at', { withTimezone: true, mode: 'date' }).notNull(),
	// updatedBy: text('updated_by')
	// 	.notNull()
	// 	.references(() => user.id),
	// updatedAt: timestamp('updated_at', { withTimezone: true, mode: 'date' }).notNull()
});

// Generic list table of lists.  E.g. list of names to generate random names from
export const list = pgTable('list', {
	id: serial('id').primaryKey(),
	name: text('name').notNull(), // name of the list
	description: text('description').notNull() // description of the list (e.g. names, items, etc.)
});

// Generic list item table.  E.g. list of names to generate random names from
export const listItem = pgTable('list_item', {
	id: serial('id').primaryKey(),
	listId: integer('list_id')
		.notNull()
		.references(() => list.id),
	name: text('name').notNull() // name of the list item
});

export type Session = typeof session.$inferSelect;
export type User = typeof user.$inferSelect;
export type UserAccess = typeof userAccess.$inferSelect;
export type Instructions = typeof instructions.$inferSelect;
export type Computer = typeof computer.$inferSelect;
export type List = typeof list.$inferSelect;
export type ListItem = typeof listItem.$inferSelect;
