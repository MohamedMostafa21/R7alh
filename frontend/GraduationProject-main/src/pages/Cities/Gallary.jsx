import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { useFetchPlaceDetails } from "../../api/endPints"; 

export default function HotelGallery() {
  const { id } = useParams();
  const { data: place, isLoading, error } = useFetchPlaceDetails(id);

  const [currentIndex, setCurrentIndex] = useState(0);
  const [isAutoPlaying, setIsAutoPlaying] = useState(true);

  const overlays = [
    "linear-gradient(135deg, rgba(99, 102, 241, 0.3), rgba(168, 85, 247, 0.3))",
    "linear-gradient(135deg, rgba(16, 185, 129, 0.3), rgba(5, 150, 105, 0.3))",
    "linear-gradient(135deg, rgba(75, 85, 99, 0.4), rgba(55, 65, 81, 0.4))",
    "linear-gradient(135deg, rgba(245, 158, 11, 0.3), rgba(217, 119, 6, 0.3))",
    "linear-gradient(135deg, rgba(107, 114, 128, 0.4), rgba(75, 85, 99, 0.4))",
  ];

  const images = place?.imageUrls || []; 

  const nextSlide = () => {
    setCurrentIndex((prev) => (prev + 1) % images.length);
  };

  const prevSlide = () => {
    setCurrentIndex((prev) => (prev - 1 + images.length) % images.length);
    setIsAutoPlaying(false);
  };

  const goToSlide = (index) => {
    setCurrentIndex(index);
    setIsAutoPlaying(false);
  };

  useEffect(() => {
    if (!isAutoPlaying) return;
    const interval = setInterval(() => {
      setCurrentIndex((prev) => (prev + 1) % images.length);
    }, 3000);
    return () => clearInterval(interval);
  }, [isAutoPlaying, images.length]);

  useEffect(() => {
    if (isAutoPlaying) return;
    const timer = setTimeout(() => {
      setIsAutoPlaying(true);
    }, 100);
    return () => clearTimeout(timer);
  }, [isAutoPlaying]);

  if (isLoading) return <p>Loading place details...</p>;
  if (error)
    return <p>Error: {error.message || "Error loading place details."}</p>;

  return (
    <div className="max-w-8xl mx-auto p-7 mb-16">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-4xl font-bold text-black">Gallery</h1>
        <button className="bg-white text-gray-700 hover:text-gray-900 font-medium text-lg transition-colors">
          See all
        </button>
      </div>

      <div
        className="relative"
        onMouseEnter={() => setIsAutoPlaying(false)}
        onMouseLeave={() => setIsAutoPlaying(true)}
      >
        <button
          onClick={prevSlide}
          className="absolute left-4 top-1/2 transform -translate-y-1/2 z-10 bg-white/90 hover:bg-white rounded-full p-3 shadow-lg transition-all duration-200 hover:scale-110"
        >
          ←
        </button>

        <button
          onClick={() => {
            nextSlide();
            setIsAutoPlaying(false);
          }}
          className="absolute right-4 top-1/2 transform -translate-y-1/2 z-10 bg-white/90 hover:bg-white rounded-full p-3 shadow-lg transition-all duration-200 hover:scale-110"
        >
          →
        </button>

        <div className="flex gap-6 overflow-hidden">
          <div
            className="flex gap-6 transition-transform duration-500 ease-in-out"
            style={{
              transform: `translateX(-${currentIndex * (288 + 24)}px)`,
            }}
          >
            {images.map((imgUrl, index) => (
              <div
                key={index}
                className="relative flex-shrink-0 w-72 h-80 rounded-2xl overflow-hidden shadow-xl hover:shadow-2xl transition-all duration-300 hover:scale-105 cursor-pointer group"
              >
                <div
                  className="absolute inset-0 bg-cover bg-center transition-transform duration-700 group-hover:scale-110"
                  style={{
                    backgroundImage: `url(http://localhost:5200${imgUrl})`,
                  }}
                />

                <div
                  className="absolute inset-0 opacity-60 group-hover:opacity-40 transition-opacity duration-300"
                  style={{
                    background: overlays[index % overlays.length],
                  }}
                />

                <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />

                <div className="absolute bottom-6 left-6 text-white">
                  <div className="flex items-center space-x-2 bg-black/30 backdrop-blur-sm rounded-full px-4 py-2">
                    {/* <span className="font-semibold">
                      Room. <span className="font-normal">Category</span>
                    </span> */}
                  </div>
                </div>

                <div className="absolute inset-0 bg-white/0 group-hover:bg-white/10 transition-all duration-300" />
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="flex justify-center mt-8 space-x-2">
        {images.map((_, index) => (
          <button
            key={index}
            onClick={() => goToSlide(index)}
            className={`h-3 rounded-full transition-all duration-200 ${
              index === currentIndex
                ? "bg-gray-800 w-8"
                : "bg-gray-300 hover:bg-gray-400 w-3"
            }`}
          />
        ))}
      </div>
    </div>
  );
}
