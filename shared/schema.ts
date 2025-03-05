import { pgTable, text, serial, varchar } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod";

export const recipes = pgTable("recipes", {
  id: serial("id").primaryKey(),
  title: text("title").notNull(),
  url: text("url").notNull(),
  imageUrl: text("image_url").notNull(),
  notes: text("notes"),
  source: varchar("source", { length: 20 }).notNull(), // 'youtube', 'instagram', 'twitter', 'cookpad'
  category: varchar("category", { length: 30 }).notNull(),
});

export const insertRecipeSchema = createInsertSchema(recipes).pick({
  title: true,
  url: true,
  imageUrl: true,
  notes: true,
  source: true,
  category: true,
}).extend({
  source: z.enum(['youtube', 'instagram', 'twitter', 'cookpad']),
  category: z.enum([
    '肉料理',
    '魚介料理',
    '野菜料理',
    'サラダ',
    'ご飯もの',
    '麺類',
    'スープ・汁物',
    'お菓子',
    'デザート',
    'パン',
    'お弁当',
    'その他'
  ])
});

export type InsertRecipe = z.infer<typeof insertRecipeSchema>;
export type Recipe = typeof recipes.$inferSelect;

export const sources = ['youtube', 'instagram', 'twitter', 'cookpad'] as const;
export const categories = [
  '肉料理',
  '魚介料理',
  '野菜料理',
  'サラダ',
  'ご飯もの',
  '麺類',
  'スープ・汁物',
  'お菓子',
  'デザート',
  'パン',
  'お弁当',
  'その他'
] as const;