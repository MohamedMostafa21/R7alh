import { useEffect, useState } from "react";
import { Home, Check, Loader2, X } from "lucide-react";
import { Link, useParams } from "react-router-dom";
import {
  useFetchRestaurantsDetails,
  useUpdateRestaurant,
} from "../../api/endPints";

export default function EditRestaurantForm() {
  const { id } = useParams();
  const { data: Restaurant, isLoading, error } = useFetchRestaurantsDetails(id);
  const updateRestaurantMutation = useUpdateRestaurant();

  const [formData, setFormData] = useState({
    name: "",
   cuisine: "",
    description: "",
    city: "",
    country: "",
    location: "",
    latitude: "",
    longitude: "",
    averagePrice: "",
  });

  const [thumbnail, setThumbnail] = useState(null);
  const [thumbnailDeleted, setThumbnailDeleted] = useState(false);
  const [images, setImages] = useState([]);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    return () => {
      if (thumbnail?.preview && !thumbnail?.url) {
        URL.revokeObjectURL(thumbnail.preview);
      }
      images.forEach((img) => {
        if (img.preview && !img.url) {
          URL.revokeObjectURL(img.preview);
        }
      });
    };
  }, []);

  useEffect(() => {
    if (Restaurant) {
      setFormData({
        name: Restaurant.name || "",
       cuisine: Restaurant.cuisine || "",
        description: Restaurant.description || "",
        city: Restaurant.city || "",
        country: Restaurant.country || "",
        location: Restaurant.location || "",
        latitude: Restaurant.latitude?.toString() || "",
        longitude: Restaurant.longitude?.toString() || "",
        averagePrice: Restaurant.averagePrice?.toString() || "",
      });

      if (Restaurant.thumbnailUrl) {
        const fullUrl = `http://localhost:5200${Restaurant.thumbnailUrl}`;
        setThumbnail({
          preview: fullUrl,
          url: Restaurant.thumbnailUrl,
          isExisting: true,
        });
      }

      if (Restaurant.imageUrls && Restaurant.imageUrls.length > 0) {
        const loaded = Restaurant.imageUrls.map((url, i) => ({
          id: `existing-${i}`,
          preview: `http://localhost:5200${url}`,
          url: url,
          isExisting: true,
        }));
        setImages(loaded);
      }
    }
  }, [Restaurant]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleThumbnailChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      if (thumbnail?.preview && !thumbnail?.url) {
        URL.revokeObjectURL(thumbnail.preview);
      }

      setThumbnail({
        file,
        preview: URL.createObjectURL(file),
        isExisting: false,
      });
      setThumbnailDeleted(false);
    }
  };

  const handleDeleteThumbnail = () => {
    if (thumbnail?.preview && !thumbnail?.url) {
      URL.revokeObjectURL(thumbnail.preview);
    }
    setThumbnail(null);
    setThumbnailDeleted(true);
  };

  const handleImagesAdd = (e) => {
    const files = Array.from(e.target.files);
    const newImgs = files.map((file) => ({
      id: Date.now() + Math.random(),
      file,
      preview: URL.createObjectURL(file),
      isExisting: false,
    }));
    setImages((prev) => [...prev, ...newImgs]);
  };

  const handleRemoveImage = (idToRemove) => {
    const imageToRemove = images.find((img) => img.id === idToRemove);
    if (imageToRemove?.preview && !imageToRemove?.url) {
      URL.revokeObjectURL(imageToRemove.preview);
    }
    setImages((prev) => prev.filter((img) => img.id !== idToRemove));
  };

  const handleSubmit = async () => {
    if (!id) {
      alert("Restaurant ID is missing!");
      return;
    }

    setIsSubmitting(true);

    try {
      const fd = new FormData();

      Object.entries(formData).forEach(([key, val]) => {
        fd.append(key, val || "");
      });

      if (thumbnailDeleted) {
        fd.append("Thumbnail", "");
      } else if (thumbnail?.file) {
        fd.append("Thumbnail", thumbnail.file);
      } else if (thumbnail?.url && thumbnail?.isExisting) {
        fd.append("ExistingThumbnailUrl", thumbnail.url);
      }

      const newImages = images.filter((img) => img.file && !img.isExisting);
      newImages.forEach((img) => {
        fd.append("Images", img.file);
      });

      const existingImageUrls = images
        .filter((img) => img.isExisting && img.url)
        .map((img) => img.url);

      existingImageUrls.forEach((url) => {
        fd.append("ExistingImageUrls", url);
      });

      console.log(
        `Sending ${newImages.length} new images and keeping ${existingImageUrls.length} existing images`
      );

      await updateRestaurantMutation.mutateAsync({ id, data: fd });
      alert("Restaurant updated successfully!");
    } catch (error) {
      console.error("Update error:", error);
      alert(
        "Error while updating Restaurant: " + (error.message || "Unknown error")
      );
    } finally {
      setIsSubmitting(false);
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-slate-100 flex items-center justify-center">
        <div className="flex items-center gap-2">
          <Loader2 className="w-6 h-6 animate-spin" />
          <span>Loading Restaurant details...</span>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-slate-100 flex items-center justify-center">
        <div className="text-center">
          <div className="text-red-600 mb-4">
            Error loading Restaurant details
          </div>
          <Link
            to="/Admin"
            className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
          >
            Back to Admin
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="w-full min-h-screen bg-slate-100">
      <div className="bg-slate-200 py-4 px-6 flex justify-between items-center shadow-lg">
        <div className="flex items-center gap-2">
          <Home className="w-5 h-5 text-gray-700" />
          <h1 className="text-xl font-bold text-gray-800">Edit Restaurant</h1>
        </div>
        <Link
          to="/Admin"
          className="bg-[#275878] text-white px-4 py-2 rounded hover:bg-[#275878]"
        >
          Back
        </Link>
      </div>

      <div className="max-w-6xl mx-auto bg-white p-6 mt-6 shadow rounded space-y-4">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <input
            name="name"
            value={formData.name}
            onChange={handleChange}
            placeholder="Name"
            className="p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
          <input
            name="type"
            value={formData.cuisine}
            onChange={handleChange}
            placeholder="Type"
            className="p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <textarea
          name="description"
          value={formData.description}
          onChange={handleChange}
          rows={4}
          placeholder="Description"
          className="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
        />

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <input
            name="city"
            value={formData.city}
            onChange={handleChange}
            placeholder="City"
            className="p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            name="country"
            value={formData.country}
            onChange={handleChange}
            placeholder="Country"
            className="p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            name="location"
            value={formData.location}
            onChange={handleChange}
            placeholder="Location"
            className="p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <input
            name="latitude"
           type="number"
            step="any"
            value={formData.latitude}
            onChange={handleChange}
            placeholder="Latitude"
            className="p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            name="longitude"
          type="number"
            step="any"
            value={formData.longitude}
            onChange={handleChange}
            placeholder="Longitude"
            className="p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            name="averagePrice"
           type="number"
            step="any"
            value={formData.averagePrice}
            onChange={handleChange}
            placeholder="Average Price"
            className="p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <label className=" text-left block mb-2 font-medium text-gray-700">
            Thumbnail
          </label>
          {thumbnail?.preview ? (
            <div className="relative w-fit">
              <img
                src={thumbnail.preview}
                alt="Thumbnail preview"
                className="w-40 h-24 object-cover mb-2 rounded border"
              />
              <button
                onClick={handleDeleteThumbnail}
                className="absolute -top-2 -right-2 bg-red-600 text-white p-1 rounded-full hover:bg-red-700 transition-colors"
               type="button"
              >
                <X className="w-4 h-4" />
              </button>
            </div>
          ) : (
            <div className="w-40 h-24 border-2 border-dashed border-gray-300 rounded flex items-center justify-center mb-2">
              <span className=" block text-sm text-gray-500">No thumbnail</span>
            </div>
          )}
          <label className="absolute right-9 bottom-38 cursor-pointer bg-[#275878] text-white px-4 py-2 rounded hover:bg-[#133348]">
            New Thumbnail
            <input
             type="file"
              accept="image/*"
              onChange={handleThumbnailChange}
              className="hidden file:mr-4 file:py-2 file:px-4 file:rounded file:border-0 file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
            />
          </label>
        </div>

        <div>
          <label className="block text-left font-medium mt-6 mb-6">
            Images
          </label>

          <div className="flex flex-wrap gap-3 mb-4">
            {images.map((img) => (
              <div key={img.id} className="relative group">
                <img
                  src={img.preview}
                  alt="Image preview"
                  className="w-24 h-24 object-cover rounded border"
                />
                <button
                  onClick={() => handleRemoveImage(img.id)}
                  className="absolute -top-2 -right-2 bg-red-600 text-white p-1 rounded-full hover:bg-red-700 transition-colors opacity-0 group-hover:opacity-100"
                type="button"
                >
                  <X className="w-3 h-3" />
                </button>
              </div>
            ))}
          </div>
          <label className="absolute right-9 bottom-38 cursor-pointer bg-[#275878] text-white px-4 py-2 rounded hover:bg-[#133348]">
            New Image
            <input
             type="file"
              accept="image/*"
              onChange={handleImagesAdd}
              className="hidden file:mr-4 file:py-2 file:px-4 file:rounded file:border-0 file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
            />
          </label>
        </div>

        <div className="flex gap-4 pt-4">
          <button
            onClick={handleSubmit}
            disabled={isSubmitting || !formData.name.trim()}
            className="bg-[#275878] hover:bg-[#143b55] disabled:bg-gray-400 disabled:cursor-not-allowed text-white px-6 py-2 rounded flex items-center gap-2 transition-colors"
           type="button"
          >
            {isSubmitting ? (
              <Loader2 className="w-4 h-4 animate-spin" />
            ) : (
              <Check className="w-4 h-4" />
            )}
            {isSubmitting ? "Updating..." : "Update Restaurant"}
          </button>
          <Link
            to="/Admin"
            className="bg-gray-600 hover:bg-gray-700 text-white px-6 py-2 rounded flex items-center gap-2 transition-colors"
          >
            Cancel
          </Link>
        </div>
      </div>
    </div>
  );
}
