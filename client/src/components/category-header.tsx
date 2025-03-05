import { Button } from "@/components/ui/button";
import { ChevronLeft } from "lucide-react";

interface CategoryHeaderProps {
  category: string;
  onBack: () => void;
}

export function CategoryHeader({ category, onBack }: CategoryHeaderProps) {
  return (
    <div className="py-6 bg-white border-b">
      <div className="container mx-auto px-4">
        <Button
          variant="ghost"
          size="sm"
          onClick={onBack}
          className="mb-2"
        >
          <ChevronLeft className="h-4 w-4 mr-1" />
          戻る
        </Button>
        <h2 className="text-2xl font-bold text-gray-900">{category}</h2>
      </div>
    </div>
  );
}
