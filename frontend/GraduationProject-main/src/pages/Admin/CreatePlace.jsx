import { useState, useEffect } from "react";
import { Home, Check, Loader2, X } from "lucide-react";
import { Link } from "react-router-dom";
import { useUpdatePlace } from "../../api/endPints";

export default function AddPlaceForm() {
  const createPlaceMutation = useUpdatePlace();

  const [formData, setFormData] = useState({
    name: "",
    type: "",
    description: "",
    city: "",
    country: "",
    location: "",
    latitude: "",
    longitude: "",
    averagePrice: "",
  });

  const [thumbnail, setThumbnail] = useState(null);
  const [images, setImages] = useState([]);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    return () => {
      if (thumbnail?.preview) {
        URL.revokeObjectURL(thumbnail.preview);
      }
      images.forEach((img) => {
        if (img.preview) {
          URL.revokeObjectURL(img.preview);
        }
      });
    };
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleThumbnailChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      if (thumbnail?.preview) {
        URL.revokeObjectURL(thumbnail.preview);
      }

      setThumbnail({
        file,
        preview: URL.createObjectURL(file),
      });
    }
  };

  const handleDeleteThumbnail = () => {
    if (thumbnail?.preview) {
      URL.revokeObjectURL(thumbnail.preview);
    }
    setThumbnail(null);
  };

  const handleImagesAdd = (e) => {
    const files = Array.from(e.target.files);
    const newImgs = files.map((file) => ({
      id: Date.now() + Math.random(),
      file,
      preview: URL.createObjectURL(file),
    }));
    setImages((prev) => [...prev, ...newImgs]);
  };

  const handleRemoveImage = (idToRemove) => {
    const imageToRemove = images.find((img) => img.id === idToRemove);
    if (imageToRemove?.preview) {
      URL.revokeObjectURL(imageToRemove.preview);
    }
    setImages((prev) => prev.filter((img) => img.id !== idToRemove));
  };

  const handleSubmit = async () => {
    setIsSubmitting(true);
    try {
      const fd = new FormData();
      Object.entries(formData).forEach(([key, val]) => {
        fd.append(key, val || "");
      });

      if (thumbnail?.file) {
        fd.append("Thumbnail", thumbnail.file);
      }

      images.forEach((img) => {
        fd.append("Images", img.file);
      });

      await createPlaceMutation.mutateAsync(fd);
      alert("Place added successfully!");
    } catch (error) {
      console.error("Create error:", error);
      alert("Error while adding place: " + (error.message || "Unknown error"));
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="w-full min-h-screen bg-slate-100">
     <div className="bg-slate-200 py-4 px-6 flex justify-around items-center shadow-lg">
        <div className="flex items-center gap-2">
         
          <h1 className="text-xl font-bold text-gray-800">Add New Place</h1>
        </div>
         <div className="">
         
        <Link
          to="/Admin"
          className="flex gap-2 items-center bg-[#275878] text-white px-4 py-2 rounded hover:bg-[#133348]"
        >
          <Home className="w-5 h-5 text-gray-700" />
      <span> Home</span> 
        </Link>
         </div>
      </div>

      <div className="max-w-6xl mx-auto bg-white p-6 mt-6 shadow rounded space-y-4">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <input name="name" value={formData.name} onChange={handleChange} placeholder="Name" className="p-2 border rounded focus:ring-2 focus:ring-blue-500" />
          <input name="type" value={formData.type} onChange={handleChange} placeholder="Type" className="p-2 border rounded focus:ring-2 focus:ring-blue-500" />
        </div>

        <textarea name="description" value={formData.description} onChange={handleChange} rows={4} placeholder="Description" className="w-full p-2 border rounded focus:ring-2 focus:ring-blue-500" />

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <input name="city" value={formData.city} onChange={handleChange} placeholder="City" className="p-2 border rounded focus:ring-2 focus:ring-blue-500" />
          <input name="country" value={formData.country} onChange={handleChange} placeholder="Country" className="p-2 border rounded focus:ring-2 focus:ring-blue-500" />
          <input name="location" value={formData.location} onChange={handleChange} placeholder="Location" className="p-2 border rounded focus:ring-2 focus:ring-blue-500" />
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <input name="latitude" type="number" step="any" value={formData.latitude} onChange={handleChange} placeholder="Latitude" className="p-2 border rounded focus:ring-2 focus:ring-blue-500" />
          <input name="longitude" type="number" step="any" value={formData.longitude} onChange={handleChange} placeholder="Longitude" className="p-2 border rounded focus:ring-2 focus:ring-blue-500" />
          <input name="averagePrice" type="number" step="any" value={formData.averagePrice} onChange={handleChange} placeholder="Average Price" className="p-2 border rounded focus:ring-2 focus:ring-blue-500" />
        </div>

        <div>
          <label className="block mb-2 font-medium text-gray-700">Thumbnail</label>
          {thumbnail?.preview ? (
            <div className="relative w-fit">
              <img src={thumbnail.preview} alt="Thumbnail preview" className="w-40 h-24 object-cover mb-2 rounded border" />
              <button onClick={handleDeleteThumbnail} className="absolute -top-2 -right-2 bg-red-600 text-white p-1 rounded-full hover:bg-red-700" type="button">
                <X className="w-4 h-4" />
              </button>
            </div>
          ) : (
            <div className="w-40 h-24 border-2 border-dashed border-gray-300 rounded flex items-center justify-center mb-2">
              <span className="text-sm text-gray-500">No thumbnail</span>
            </div>
          )}
          <label className="cursor-pointer bg-[#275878] text-white px-4 py-2 rounded hover:bg-[#133348] inline-block">
            Add Thumbnail
            <input type="file" accept="image/*" onChange={handleThumbnailChange} className="hidden" />
          </label>
        </div>

        <div>
          <label className="block font-medium mt-6 mb-2">Images</label>
          <div className="flex flex-wrap gap-3 mb-4">
            {images.map((img) => (
              <div key={img.id} className="relative group">
                <img src={img.preview} alt="Image preview" className="w-24 h-24 object-cover rounded border" />
                <button onClick={() => handleRemoveImage(img.id)} className="absolute -top-2 -right-2 bg-red-600 text-white p-1 rounded-full hover:bg-red-700 opacity-0 group-hover:opacity-100" type="button">
                  <X className="w-3 h-3" />
                </button>
              </div>
            ))}
          </div>
          <label className="cursor-pointer bg-[#275878] text-white px-4 py-2 rounded hover:bg-[#133348] inline-block">
            Add Images
            <input type="file" accept="image/*" onChange={handleImagesAdd} multiple className="hidden" />
          </label>
        </div>

        <div className="flex gap-4 pt-4">
          <button onClick={handleSubmit} disabled={isSubmitting || !formData.name.trim()} className="bg-[#275878] hover:bg-[#143b55] disabled:bg-gray-400 disabled:cursor-not-allowed text-white px-6 py-2 rounded flex items-center gap-2 transition-colors" type="button">
            {isSubmitting ? <Loader2 className="w-4 h-4 animate-spin" /> : <Check className="w-4 h-4" />}
            {isSubmitting ? "Creating..." : "Add Place"}
          </button>
          <Link to="/Admin" className="bg-gray-600 hover:bg-gray-700 text-white px-6 py-2 rounded">Cancel</Link>
        </div>
      </div>
    </div>
  );
}
