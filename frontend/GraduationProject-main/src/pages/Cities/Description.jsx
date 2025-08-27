import { useState } from "react";
import { useFetchPlaceDetails } from "../../api/endPints";
import { useParams } from "react-router-dom";

const Description = () => {
  const { id } = useParams();

  const { data: place, isLoading, error } = useFetchPlaceDetails(id);

  const [isLiked, setIsLiked] = useState(false);

  const handleClick = () => {
    setIsLiked(!isLiked);
  };

  if (isLoading) return <p>Loading place details...</p>;
  if (error)
    return <p>Error: {error.message || "Error loading place details."}</p>;

  return (
    <div className="max-w-8xl mx-auto bg-white rounded-lg p-7 flex flex-col md:flex-row">
      {/* Left Side: Image */}
      <div className="w-full md:w-1/2">
        <img
          src={`http://localhost:5200${place.thumbnailUrl}`}
          alt={place?.name || "Place"}
          className="w-3/4 h-80 object-cover rounded-md"
        />

        {/* Info Bar */}
        <div className="flex gap-10 items-center mt-4 text-sm text-gray-700 px-1">
          <div className="flex items-center gap-1">
            <a
              href={`https://www.google.com/maps?q=${place.latitude},${place.longitude}`}
              target="_blank"
              rel="noopener noreferrer"
              className="text-gray-700 flex gap-1"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                width="1.5em"
                height="1.5em"
              >
                <path
                  fill="gray-700"
                  fillRule="evenodd"
                  d="M11.906 1.994a8 8 0 0 1 8.09 8.421a8 8 0 0 1-1.297 3.957a1 1 0 0 1-.133.204l-.108.129q-.268.365-.573.699l-5.112 6.224a1 1 0 0 1-1.545 0L5.982 15.26l-.002-.002a18 18 0 0 1-.309-.38l-.133-.163a1 1 0 0 1-.13-.202a7.995 7.995 0 0 1 6.498-12.518ZM15 9.997a3 3 0 1 1-5.999 0a3 3 0 0 1 5.999 0"
                  clipRule="evenodd"
                ></path>
              </svg>
              {place.location}
            </a>
          </div>
          <div className="flex items-center gap-1">
            <span>Entry Fee: {place.averagePrice || 0}$</span>
          </div>
          <div className="flex items-center gap-1">
            <span>
              Time: {place.openTime || "09:00"} - {place.closeTime || "17:00"}
            </span>
          </div>
        </div>
      </div>

      {/* Right Side: Text */}
      <div className="w-full md:w-1/2 flex flex-col justify-around text-left mt-4 md:mt-0">
        <div>
          <h2 className="text-2xl font-bold text-[#275878] mb-2">
            {place.name}
          </h2>
          <p className="text-gray-800 mb-2">{place.description}</p>
        </div>

        {/* Button and Like */}
        <div className="flex items-center gap-4 mt-4">
          <button className="bg-[#275878] text-white px-6 py-2 rounded-md hover:bg-[#1e4660] transition">
            Book now
          </button>

          <button
            onClick={handleClick}
            className="w-16 h-10 bg-blue-100 border-2 border-blue-300 rounded-lg flex items-center justify-center hover:bg-blue-200 transition-colors duration-200"
          >
            <svg
              className={`w-8 h-8 transition-all duration-200 ${
                isLiked
                  ? "text-blue-300 fill-white"
                  : "text-[#275878] fill-[#275878]"
              }`}
              stroke="currentColor"
              strokeWidth="2"
              viewBox="0 0 24 24"
            >
              <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
            </svg>
          </button>
        </div>
      </div>
    </div>
  );
};

export default Description;
