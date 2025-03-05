import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Link } from "wouter";
import { Button } from "@/components/ui/button";
import { Plus, CookingPot } from "lucide-react";
import { RecipeCard } from "@/components/recipe-card";
import { SearchBar } from "@/components/search-bar";
import { categories } from "@shared/schema";
import type { Recipe } from "@shared/schema";
import {
  CakeIcon,
  UtensilsCrossedIcon,
  SaladIcon,
  CookingPotIcon,
  CupSodaIcon,
  Sandwich,
  GalleryThumbnails,
  Beef
} from "lucide-react";

const categoryIcons: { [key: string]: any } = {
  "肉料理": <Beef className="h-8 w-8" />,
  "魚介料理": <UtensilsCrossedIcon className="h-8 w-8" />,
  "野菜料理": <SaladIcon className="h-8 w-8" />,
  "サラダ": <SaladIcon className="h-8 w-8" />,
  "ご飯もの": <CookingPotIcon className="h-8 w-8" />,
  "麺類": <CookingPotIcon className="h-8 w-8" />,
  "スープ・汁物": <CupSodaIcon className="h-8 w-8" />,
  "お菓子": <CakeIcon className="h-8 w-8" />,
  "デザート": <CakeIcon className="h-8 w-8" />,
  "パン": <Sandwich className="h-8 w-8" />,
  "お弁当": <GalleryThumbnails className="h-8 w-8" />,
  "その他": <UtensilsCrossedIcon className="h-8 w-8" />,
};

export default function Home() {
  const [search, setSearch] = useState("");
  const [source, setSource] = useState("all");
  const [category, setCategory] = useState("all");
  const [showCategories, setShowCategories] = useState(true);

  const { data: recipes = [], isLoading } = useQuery<Recipe[]>({
    queryKey: ["/api/recipes/search", search, source, category],
    queryFn: async ({ queryKey }) => {
      const [_, searchTerm, sourceFilter, categoryFilter] = queryKey;
      const params = new URLSearchParams();
      if (searchTerm) params.append("q", searchTerm as string);
      if (sourceFilter !== "all") params.append("source", sourceFilter as string);
      if (categoryFilter !== "all") params.append("category", categoryFilter as string);

      const url = `/api/recipes/search${params.toString() ? `?${params.toString()}` : ""}`;
      const res = await fetch(url);
      if (!res.ok) throw new Error("レシピの取得に失敗しました");
      return res.json();
    },
  });

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="bg-white border-b sticky top-0 z-10">
        <div className="container mx-auto px-4 py-4">
          <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between mb-4">
            <div className="flex items-center gap-2">
              <CookingPot className="h-8 w-8 text-primary animate-bounce" />
              <h1 className="text-2xl font-bold text-gray-900">hoshipad</h1>
            </div>
            <Link href="/add">
              <Button>
                <Plus className="mr-2 h-4 w-4" />
                レシピを追加
              </Button>
            </Link>
          </div>
          <SearchBar
            search={search}
            onSearchChange={setSearch}
            source={source}
            onSourceChange={setSource}
            category={category}
            onCategoryChange={(value) => {
              setCategory(value);
              setShowCategories(false);
            }}
          />
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        {showCategories && category === "all" && !search && (
          <>
            <h2 className="text-2xl font-bold text-gray-900 mb-6">カテゴリーから探す</h2>
            <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-6">
              {categories.map((cat) => (
                <button
                  key={cat}
                  onClick={() => {
                    setCategory(cat);
                    setShowCategories(false);
                  }}
                  className="bg-white p-8 rounded-lg shadow-sm hover:shadow-md transition-all duration-200 flex flex-col items-center gap-4 group relative overflow-hidden"
                >
                  <div className="text-primary group-hover:scale-110 transition-transform duration-200">
                    {categoryIcons[cat]}
                  </div>
                  <span className="text-sm font-medium text-gray-700 text-center">
                    {cat}
                  </span>
                </button>
              ))}
            </div>
          </>
        )}

        {(!showCategories || category !== "all" || search) && (
          <>
            {category !== "all" && (
              <div className="flex items-center gap-4 mb-6">
                <Button
                  variant="ghost"
                  onClick={() => {
                    setCategory("all");
                    setShowCategories(true);
                  }}
                  className="text-primary hover:text-primary/90"
                >
                  ← カテゴリー一覧に戻る
                </Button>
                <h2 className="text-2xl font-bold text-gray-900">{category}</h2>
              </div>
            )}

            {isLoading ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                {[...Array(8)].map((_, i) => (
                  <div
                    key={i}
                    className="h-[360px] bg-white rounded-lg shadow animate-pulse"
                  />
                ))}
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                {recipes.map((recipe) => (
                  <RecipeCard key={recipe.id} recipe={recipe} />
                ))}
                {recipes.length === 0 && (
                  <div className="col-span-full text-center py-12 text-gray-500">
                    レシピが見つかりませんでした
                  </div>
                )}
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}