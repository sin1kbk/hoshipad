import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { type Recipe } from "@shared/schema";
import { SiYoutube, SiInstagram } from "react-icons/si";
import { Pencil, Trash2, MessageCircle, Book } from "lucide-react";
import { apiRequest, queryClient } from "@/lib/queryClient";
import { useToast } from "@/hooks/use-toast";

const sourceIcons = {
  youtube: SiYoutube,
  instagram: SiInstagram,
  twitter: MessageCircle,
  cookpad: Book,
};

const sourceColors = {
  youtube: "text-red-600",
  instagram: "text-pink-600",
  twitter: "text-blue-400",
  cookpad: "text-orange-600",
};

interface RecipeCardProps {
  recipe: Recipe;
}

export function RecipeCard({ recipe }: RecipeCardProps) {
  const { toast } = useToast();
  const Icon = sourceIcons[recipe.source as keyof typeof sourceIcons];

  const handleDelete = async () => {
    try {
      await apiRequest("DELETE", `/api/recipes/${recipe.id}`);
      queryClient.invalidateQueries({ queryKey: ["/api/recipes"] });
      toast({
        title: "レシピを削除しました",
        description: "レシピの削除が完了しました。",
      });
    } catch (error) {
      toast({
        title: "エラー",
        description: "レシピの削除に失敗しました。",
        variant: "destructive",
      });
    }
  };

  return (
    <Card className="overflow-hidden hover:shadow-lg transition-shadow">
      <div className="aspect-[4/3] relative">
        <img
          src={recipe.imageUrl}
          alt={recipe.title}
          className="object-cover w-full h-full"
        />
        <div className="absolute top-2 right-2 bg-white/90 p-1.5 rounded-full">
          <Icon className={`w-5 h-5 ${sourceColors[recipe.source as keyof typeof sourceColors]}`} />
        </div>
      </div>
      <CardContent className="p-4">
        <h3 className="font-bold text-lg line-clamp-2 mb-2 min-h-[3.5rem]">
          {recipe.title}
        </h3>
        {recipe.notes && (
          <p className="text-sm text-muted-foreground line-clamp-2 min-h-[2.5rem]">
            {recipe.notes}
          </p>
        )}
      </CardContent>
      <CardFooter className="p-4 pt-0 flex justify-between items-center border-t">
        <Button
          variant="default"
          size="sm"
          className="flex-1 max-w-[120px]"
          onClick={() => window.open(recipe.url, "_blank")}
        >
          レシピを見る
        </Button>
        <div className="flex gap-1">
          <Button variant="ghost" size="sm" className="h-8 w-8 p-0">
            <Pencil className="h-4 w-4" />
          </Button>
          <Button 
            variant="ghost" 
            size="sm" 
            onClick={handleDelete}
            className="h-8 w-8 p-0 text-red-500 hover:text-red-600 hover:bg-red-50"
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      </CardFooter>
    </Card>
  );
}