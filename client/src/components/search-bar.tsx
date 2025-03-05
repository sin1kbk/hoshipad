import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Search } from "lucide-react";
import { sources, categories } from "@shared/schema";

interface SearchBarProps {
  search: string;
  onSearchChange: (value: string) => void;
  source: string;
  onSourceChange: (value: string) => void;
  category: string;
  onCategoryChange: (value: string) => void;
}

export function SearchBar({ 
  search, 
  onSearchChange, 
  source, 
  onSourceChange,
  category,
  onCategoryChange 
}: SearchBarProps) {
  return (
    <div className="flex flex-col sm:flex-row gap-3">
      <div className="relative flex-1">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
        <Input
          placeholder="レシピを検索..."
          value={search}
          onChange={(e) => onSearchChange(e.target.value)}
          className="pl-10"
        />
      </div>
      <div className="flex gap-2">
        <Select value={category} onValueChange={onCategoryChange}>
          <SelectTrigger className="w-[140px]">
            <SelectValue placeholder="カテゴリー" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">全てのカテゴリー</SelectItem>
            {categories.map((c) => (
              <SelectItem key={c} value={c}>{c}</SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select value={source} onValueChange={onSourceChange}>
          <SelectTrigger className="w-[140px]">
            <SelectValue placeholder="ソースで絞り込み" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">全てのソース</SelectItem>
            {sources.map((s) => (
              <SelectItem key={s} value={s}>
                {s === 'youtube' ? 'YouTube' :
                 s === 'instagram' ? 'Instagram' :
                 s === 'twitter' ? 'Twitter' :
                 'クックパッド'}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
    </div>
  );
}