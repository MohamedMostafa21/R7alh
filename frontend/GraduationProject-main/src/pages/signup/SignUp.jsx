import { useEffect, useState, useRef } from "react";
import { DescoverApi } from "../../../api/endPints";
import { Link } from "react-router-dom";

const Discover = () => {
  const [places, setPlaces] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const scrollContainerRef = useRef(null);

  useEffect(() => {
    const fetchPlaces = async () => {
      try {
        const data = await DescoverApi();
        if (data && Array.isArray(data)) {
          const baseUrl = "http://localhost:5201";

          const cleanedData = data.map((place) => ({
            id: place.id,
            name: place.name?.replace(/\\|"/g, "") || "Unknown Place",
            type: place.type?.replace(/\\|"/g, "") || "Unknown Type",
            location:
              place.location?.replace(/\\|"/g, "") || "Unknown Location",
            stars: place.stars || 0,
            thumbnailUrl: place.thumbnailUrl
              ? place.thumbnailUrl.startsWith("http")
                ? place.thumbnailUrl
                : `${baseUrl}${place.thumbnailUrl}`
              : "/default-image.png",
            isLiked: place.isLiked || false,
          }));

          setPlaces(cleanedData);
        } else {
          setPlaces([]);
        }
      } catch (err) {
        setError(err.message || "Something went wrong!");
      } finally {
        setLoading(false);
      }
    };

    fetchPlaces();
  }, []);

  const toggleLike = (id) => {
    setPlaces((prevPlaces) =>
      prevPlaces.map((place) =>
        place.id === id ? { ...place, isLiked: !place.isLiked } : place
      )
    );
  };

  const handleStarClick = (id, stars) => {
    setPlaces((prevPlaces) =>
      prevPlaces.map((place) => (place.id === id ? { ...place, stars } : place))
    );
  };

  const renderStars = (id, stars) => {
    const totalStars = 5;
    return (
      <div className="flex">
        {[...Array(totalStars)].map((_, index) => (
          <span
            key={index}
            className={index < stars ? "text-yellow-400" : "text-gray-300"}
            onClick={() => handleStarClick(id, index + 1)}
          >
            ★
          </span>
        ))}
      </div>
    );
  };

  const handleScroll = (direction) => {
    if (scrollContainerRef.current) {
      const scrollAmount = 200;
      scrollContainerRef.current.scrollLeft += direction * scrollAmount;
    }
  };

  return (
    <section className="mb-12 cursor-pointer">
      <h2 className="text-start text-2xl font-bold mb-6">
        <Link
          className="main hover:text-[#4f9ed2] font-bold"
          to="/Home/discover"
        >
          Discover
        </Link>
      </h2>

      {loading ? (
        <p>Loading...</p>
      ) : error ? (
        <p className="text-red-500">{error}</p>
      ) : places.length > 0 ? (
        <div
          ref={scrollContainerRef}
          className="flex space-x-4 overflow-y-auto scrollbar-hide"
        >
          {places.map((place) => (
            <div
              key={place.id}
              className="min-w-[200px] bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
            >
              <div className="relative">
                <img
                  src={place.thumbnailUrl}
                  alt={place.name || "Place"}
                  className="w-full h-48 object-cover"
                  onError={(e) => {
                    e.target.src = "/default-image.png";
                  }}
                />
                <p className="absolute bottom-2 left-2 text-white px-3 py-1 rounded text-lg flex items-center space-x-2">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    width="1em"
                    height="1em"
                  >
                    <path
                      fill="white"
                      fillRule="evenodd"
                      d="M11.906 1.994a8 8 0 0 1 8.09 8.421a8 8 0 0 1-1.297 3.957a1 1 0 0 1-.133.204l-.108.129q-.268.365-.573.699l-5.112 6.224a1 1 0 0 1-1.545 0L5.982 15.26l-.002-.002a18 18 0 0 1-.309-.38l-.133-.163a1 1 0 0 1-.13-.202a7.995 7.995 0 0 1 6.498-12.518ZM15 9.997a3 3 0 1 1-5.999 0a3 3 0 0 1 5.999 0"
                      clipRule="evenodd"
                    ></path>
                  </svg>
                  <span className="text-lg">
                    {place.location || "Unknown Location"}
                  </span>
                </p>
              </div>
              <div className="p-4">
                <div className="flex items-center justify-between">
                  {renderStars(place.id, place.stars)}
                  <button
                   className="bg-white p-2 rounded-full shadow-md"
                    onClick={() => toggleLike(place.id)}
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill={place.isLiked ? "red" : "none"}
                      viewBox="0 0 24 24"
                      stroke="red"
                      className="flex w-5 h-5 justify-center"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth="2"
                        d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"
                      />
                    </svg>
                  </button>
                </div>
                <h3 className="text-lg font-semibold text-gray-800">
                  {place.name || "Unknown Place"}
                </h3>
                <p className="absolute bottom-2 left-2 text-white px-3 py-1 rounded text-lg flex items-center space-x-2">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    width="1em"
                    height="1em"
                  >
                    <path
                      fill="white"
                      fillRule="evenodd"
                      d="M11.906 1.994a8 8 0 0 1 8.09 8.421a8 8 0 0 1-1.297 3.957a1 1 0 0 1-.133.204l-.108.129q-.268.365-.573.699l-5.112 6.224a1 1 0 0 1-1.545 0L5.982 15.26l-.002-.002a18 18 0 0 1-.309-.38l-.133-.163a1 1 0 0 1-.13-.202a7.995 7.995 0 0 1 6.498-12.518ZM15 9.997a3 3 0 1 1-5.999 0a3 3 0 0 1 5.999 0"
                      clipRule="evenodd"
                    ></path>
                  </svg>
                  <span className="text-lg">
                    {place.location || "Unknown Location"}
                  </span>
                </p>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <p className="text-gray-500">No places available.</p>
      )}

      <div className="flex flex-col items-end mt-4">
        <div className="flex space-x-4">
          <button
            className="w-12 h-12 flex justify-center items-center rounded-full border-2 bg-white border-blue-500 text-[#46a0db] shadow-lg hover:bg-blue-100 transition duration-300"
            onClick={() => handleScroll(-1)}
          >
            &lt;
          </button>
          <button
            className="w-12 h-12 flex justify-center items-center rounded-full bg-[#46a0db] text-white shadow-lg hover:bg-[#275878] transition duration-300"
            onClick={() => handleScroll(1)}
          >
            &gt;
          </button>
        </div>
      </div>
    </section>
  );
};

export default Discover;
