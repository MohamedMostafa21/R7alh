import { useState } from "react";
import { usePlaces } from "../../api/endPints"
import { Link } from "react-router-dom";
const ContentDiscover = () => {
  const { data = [], isLoading, error } = usePlaces();

  const [searchTerm, setSearchTerm] = useState("");
  const [likedPlaces, setLikedPlaces] = useState({});
  const [ratings, setRatings] = useState({});

  const baseUrl = "http://localhost:5200";

  const cleanedPlaces = data.map((place) => ({
    id: place.id || Math.random().toString(36).substr(2, 9),
    name: place.name?.replace(/\\|"/g, "") || "Unknown Place",
    type: place.type?.replace(/\\|"/g, "") || "Unknown Type",
    location: place.location?.replace(/\\|"/g, "") || "Unknown Location",
    rating: place.rating || 0,
    thumbnailUrl: place.thumbnailUrl?.startsWith("http")
      ? place.thumbnailUrl
      : `${baseUrl}${place.thumbnailUrl}` || "/default-image.png",
    latitude: place.latitude,
    longitude: place.longitude,
  }));

  const toggleLike = (id) => {
    setLikedPlaces((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const handleStarClick = (id, stars) => {
    setRatings((prev) => ({ ...prev, [id]: stars }));
  };

  const renderStars = (id, stars) => {
    return (
      <div className="flex gap-1">
        {[...Array(5)].map((_, index) => (
          <span
            key={index}
            onClick={() => handleStarClick(id, index + 1)}
            className={`cursor-pointer text-xl transition ${
              index < (ratings[id] || stars) ? "text-yellow-400" : "text-gray-300"
            }`}
          >
            ★
          </span>
        ))}
      </div>
    );
  };

  const filteredItems = cleanedPlaces.filter((item) =>
    item.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <section className="mb-12 p-10">
      <div className="flex items-center justify-between mb-6">
        <h2 className="main text-2xl font-bold hover:text-[#4f9ed2] cursor-pointer">
          Discover
        </h2>
        <input
          type="text"
          placeholder="Search by name..."
          className="px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      {isLoading ? (
        <p className="text-center">Loading...</p>
      ) : error ? (
        <p className="text-center text-red-500">{error.message}</p>
      ) : filteredItems.length === 0 ? (
        <p className="text-center text-gray-500">No places found.</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {filteredItems.map((item) => (
               <div key={item.id}>
            <div
              key={item.id}
              className="bg-white rounded-xl shadow-md hover:shadow-xl transform hover:scale-105 transition duration-300 overflow-hidden"
            >
              <div className="relative">
                   <Link to={`/Home/Place/${item.id}`}>
                <img
                  src={item.thumbnailUrl}
                  alt={item.name}
                  onError={(e) => {
                    e.target.src = "/default-image.png";
                  }}
                  className="w-full h-40 object-cover"
                />
                </Link>
                <a
                  href={`https://www.google.com/maps?q=${item.latitude},${item.longitude}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="absolute bottom-2 left-2 text-white bg-black bg-opacity-50 px-3 py-1 rounded text-sm flex items-center gap-1 hover:text-blue-300"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    className="w-4 h-4"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="white"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M12 11c1.104 0 2-.896 2-2s-.896-2-2-2-2 .896-2 2 .896 2 2 2z"
                    />
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M12 2C8.134 2 5 5.134 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.866-3.134-7-7-7z"
                    />
                  </svg>
                  {item.location}
                </a>
              </div>

              <div className="p-4">
                <div className="flex items-center justify-between mb-2">
                  {renderStars(item.id, item.rating)}
                  <button
                    className="w-9 h-9 flex items-center justify-center text-xl bg-white p-2 rounded-full shadow-md"
                    onClick={() => toggleLike(item.id)}
                  >
                    <span className={likedPlaces[item.id] ? "text-red-500" : "text-gray-400"}>
                      ♥
                    </span>
                  </button>
                </div>
                <h3 className="text-lg font-semibold text-center text-gray-800">
                  {item.name}
                </h3>
                <p className="text-center text-sm text-gray-500">{item.type}</p>
              </div>
            </div>
            </div>
          ))}
        </div>
      )}
    </section>
  );
};

export default ContentDiscover;
