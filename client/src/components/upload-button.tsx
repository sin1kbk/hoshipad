import { Button } from "@/components/ui/button";
import { UploadDropzone } from "@uploadthing/react";
import { generateComponents } from "@uploadthing/react";
import type { OurFileRouter } from "../../../server/uploadthing";

const { UploadButton: UTUploadButton } = generateComponents<OurFileRouter>();

interface UploadButtonProps {
  onUploadComplete: (url: string) => void;
}

export function UploadButton({ onUploadComplete }: UploadButtonProps) {
  return (
    <UTUploadButton
      endpoint="imageUploader"
      onClientUploadComplete={(res) => {
        if (res?.[0]) {
          onUploadComplete(res[0].url);
        }
      }}
      onUploadError={(error: Error) => {
        console.error("Error uploading file:", error);
      }}
      appearance={{
        button: "bg-primary text-primary-foreground hover:bg-primary/90",
      }}
    />
  );
}

interface UploadDropzoneProps {
  onUploadComplete: (url: string) => void;
}

export function ImageUploadDropzone({ onUploadComplete }: UploadDropzoneProps) {
  return (
    <UploadDropzone
      endpoint="imageUploader"
      onClientUploadComplete={(res) => {
        if (res?.[0]) {
          onUploadComplete(res[0].url);
        }
      }}
      onUploadError={(error: Error) => {
        console.error("Error uploading file:", error);
      }}
      appearance={{
        container: "border-2 border-dashed border-gray-300 p-8 rounded-lg",
        label: "text-gray-500",
      }}
    />
  );
}
