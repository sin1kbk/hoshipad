import { type Recipe, type InsertRecipe } from "@shared/schema";

export interface IStorage {
  getAllRecipes(): Promise<Recipe[]>;
  getRecipe(id: number): Promise<Recipe | undefined>;
  createRecipe(recipe: InsertRecipe): Promise<Recipe>;
  updateRecipe(id: number, recipe: Partial<InsertRecipe>): Promise<Recipe | undefined>;
  deleteRecipe(id: number): Promise<boolean>;
  searchRecipes(query: string, filters?: { source?: string; category?: string }): Promise<Recipe[]>;
}

export class MemStorage implements IStorage {
  private recipes: Map<number, Recipe>;
  private currentId: number;

  constructor() {
    this.recipes = new Map();
    this.currentId = 1;
  }

  async getAllRecipes(): Promise<Recipe[]> {
    return Array.from(this.recipes.values());
  }

  async getRecipe(id: number): Promise<Recipe | undefined> {
    return this.recipes.get(id);
  }

  async createRecipe(insertRecipe: InsertRecipe): Promise<Recipe> {
    const id = this.currentId++;
    const recipe = {
      id,
      ...insertRecipe,
      notes: insertRecipe.notes ?? null
    };
    this.recipes.set(id, recipe);
    return recipe;
  }

  async updateRecipe(id: number, recipe: Partial<InsertRecipe>): Promise<Recipe | undefined> {
    const existing = this.recipes.get(id);
    if (!existing) return undefined;

    const updated = { 
      ...existing,
      ...recipe,
      notes: recipe.notes ?? existing.notes 
    };
    this.recipes.set(id, updated);
    return updated;
  }

  async deleteRecipe(id: number): Promise<boolean> {
    return this.recipes.delete(id);
  }

  async searchRecipes(query: string, filters?: { source?: string; category?: string }): Promise<Recipe[]> {
    let recipes = Array.from(this.recipes.values());

    // フィルター適用
    if (filters?.source && filters.source !== 'all') {
      recipes = recipes.filter(recipe => recipe.source === filters.source);
    }
    if (filters?.category && filters.category !== 'all') {
      recipes = recipes.filter(recipe => recipe.category === filters.category);
    }

    // 検索クエリがある場合のみ検索を実行
    if (query) {
      const lowercaseQuery = query.toLowerCase();
      recipes = recipes.filter(recipe => 
        recipe.title.toLowerCase().includes(lowercaseQuery) ||
        recipe.notes?.toLowerCase().includes(lowercaseQuery) ||
        recipe.source.toLowerCase().includes(lowercaseQuery) ||
        recipe.category.toLowerCase().includes(lowercaseQuery)
      );
    }

    return recipes;
  }
}

export const storage = new MemStorage();