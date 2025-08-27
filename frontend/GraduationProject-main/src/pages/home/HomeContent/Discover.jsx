import { useRef } from "react";
import { Link } from "react-router-dom";
import { usePlaces } from "../../../api/endPints";

const Discover = () => {
  const { data: places = [], isLoading, error } = usePlaces();
  const scrollContainerRef = useRef(null);

  const toggleLike = (id) => {
    console.log("Toggled like for:", id);
  };

  const handleStarClick = (id, stars) => {
    console.log("Set stars for:", id, stars);
  };

  const renderStars = (id) => {
    return (
      <div className="flex">
        {[...Array(5)].map((_, index) => (
          <span
            key={index}
            className={index < places.stars ? "text-yellow-400" : "text-gray-300"}
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
        <Link className="main hover:text-[#4f9ed2] font-bold" to="/Home/discover">
          Discover
        </Link>
      </h2>

      {isLoading ? (
        <p>Loading...</p>
      ) : error ? (
        <p className="text-red-500">{error.message || "Error loading places"}</p>
      ) : places.length > 0 ? (
        <div
          ref={scrollContainerRef}
          className="flex space-x-4 overflow-x-auto scrollbar-hide"
        >
          {places.map((place) => (
            <div key={place.id}>
              <div className="min-w-[200px] h-[370px] flex flex-col justify-between bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
                <div className="relative">
                   <Link to={`/Home/place/${place.id}`}>
                  <img
                    src={`http://localhost:5200${place.thumbnailUrl}`}
                    alt={place.name || "Place"}
                    className="w-full h-48 object-cover"
                    onError={(e) => {
                      e.target.src = "/default-image.png";
                    }}
                  />
                  </Link>
                  <a
                    href={`https://www.google.com/maps?q=${place.latitude},${place.longitude}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="absolute bottom-2 left-2 text-white px-3 py-1 rounded text-md flex items-center space-x-2 hover:text-blue-200"
                  >
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
                    <span>{place.location || "Unknown"}</span>
                  </a>
                </div>

                <div className="p-4 flex flex-col justify-between flex-grow">
                  <div className="flex items-center justify-between mb-2">
                    {renderStars(place.id, place.stars)}
                    <button
                      className="bg-white p-2 rounded-full shadow-md"
                      onClick={(e) => {
                        e.preventDefault(); 
                        toggleLike(place.id);
                      }}
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        fill={place.isLiked ? "red" : "none"}
                        viewBox="0 0 24 24"
                        stroke="red"
                        className="w-5 h-5"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth="2"
                          d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5
                            2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 
                            14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 
                            6.86-8.55 11.54L12 21.35z"
                        />
                      </svg>
                    </button>
                  </div>
                  <h3 className="text-lg font-semibold text-gray-800 text-center">
                    {place.name || "Unknown Place"}
                  </h3>
                  <p className="text-sm text-gray-500 text-center">{place.type}</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <p className="text-gray-500">No places available.</p>
      )}

      <div className="flex justify-end mt-4">
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
