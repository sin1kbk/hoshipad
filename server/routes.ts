import type { Express } from "express";
import { createServer } from "http";
import { storage } from "./storage";
import { insertRecipeSchema } from "@shared/schema";
import { z } from "zod";

export async function registerRoutes(app: Express) {
  // 既存のルート
  app.get("/api/recipes", async (_req, res) => {
    const recipes = await storage.getAllRecipes();
    res.json(recipes);
  });

  app.get("/api/recipes/search", async (req, res) => {
    const query = req.query.q as string;
    const source = req.query.source as string;
    const category = req.query.category as string;

    const recipes = await storage.searchRecipes(query, {
      source: source !== 'all' ? source : undefined,
      category: category !== 'all' ? category : undefined
    });
    res.json(recipes);
  });

  app.post("/api/recipes", async (req, res) => {
    try {
      const recipe = insertRecipeSchema.parse(req.body);
      const created = await storage.createRecipe(recipe);
      res.status(201).json(created);
    } catch (e) {
      if (e instanceof z.ZodError) {
        res.status(400).json({ error: e.errors });
      } else {
        res.status(500).json({ error: "Internal server error" });
      }
    }
  });

  app.patch("/api/recipes/:id", async (req, res) => {
    const id = parseInt(req.params.id);
    if (isNaN(id)) {
      return res.status(400).json({ error: "Invalid ID" });
    }

    try {
      const updates = insertRecipeSchema.partial().parse(req.body);
      const updated = await storage.updateRecipe(id, updates);
      if (!updated) {
        return res.status(404).json({ error: "Recipe not found" });
      }
      res.json(updated);
    } catch (e) {
      if (e instanceof z.ZodError) {
        res.status(400).json({ error: e.errors });
      } else {
        res.status(500).json({ error: "Internal server error" });
      }
    }
  });

  app.delete("/api/recipes/:id", async (req, res) => {
    const id = parseInt(req.params.id);
    if (isNaN(id)) {
      return res.status(400).json({ error: "Invalid ID" });
    }

    const deleted = await storage.deleteRecipe(id);
    if (!deleted) {
      return res.status(404).json({ error: "Recipe not found" });
    }
    res.status(204).end();
  });

  return createServer(app);
}