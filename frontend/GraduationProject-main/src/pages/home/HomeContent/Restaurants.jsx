import { useRef, useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { useRestaurants } from "../../../api/endPints";

const Restaurants = () => {
  const { data, isLoading, error } = useRestaurants();
  const scrollContainerRef = useRef(null);
  const [restaurants, setRestaurants] = useState([]);

  useEffect(() => {
    if (data) {
      const enrichedData = data.map((item, index) => ({
        ...item,
        id: item.id || index + 1,
        isLiked: false,
        stars: 0,
        thumbnailUrl: `http://localhost:5200${item.thumbnailUrl || ""}`,
      }));
      setRestaurants(enrichedData);
    }
  }, [data]);

  const handleScroll = (direction) => {
    if (scrollContainerRef.current) {
      const scrollAmount = 200;
      scrollContainerRef.current.scrollLeft += direction * scrollAmount;
    }
  };

  const toggleLike = (id) => {
    setRestaurants((prev) =>
      prev.map((rest) =>
        rest.id === id ? { ...rest, isLiked: !rest.isLiked } : rest
      )
    );
  };

  const handleStarClick = (id, stars) => {
    setRestaurants((prev) =>
      prev.map((rest) => (rest.id === id ? { ...rest, stars } : rest))
    );
  };

  const renderStars = (id, stars) => {
    return (
      <div className="flex">
        {[...Array(5)].map((_, index) => (
          <span
            key={index}
            className={index < stars ? "text-yellow-400" : "text-gray-300"}
            onClick={() => handleStarClick(id, index + 1)}
            style={{ cursor: "pointer" }}
          >
            ★
          </span>
        ))}
      </div>
    );
  };

  if (isLoading) return <p>Loading restaurants...</p>;
  if (error) return <p>Error: {error.message || "Error loading restaurants."}</p>;

  return (
    <section className="mb-12">
      <h2 className="text-start text-2xl font-bold mb-6">
        <Link className="main hover:text-[#4f9ed2] font-bold" to="/Home/Restaurants">
          Restaurants
        </Link>
      </h2>

      <div
        ref={scrollContainerRef}
        className="flex space-x-4 overflow-x-auto scrollbar-hide"
      >
        {restaurants.map((restaurant) => (
          <div
            key={restaurant.id}
            className="min-w-[300px] bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
          >
            <div className="relative">
                <Link to={`/Home/Restaurant/${restaurant.id}`}>
              <img
                src={
                  restaurant.thumbnailUrl ||
                  "https://th.bing.com/th/id/OIP.Vkt8aCQlUwtmQ03vl7h1JgHaFj?rs=1&pid=ImgDetMain"
                }
                alt={restaurant.name || "Restaurant"}
                className="w-full h-48 object-cover"
              />
              </Link>
              <button
                className="absolute top-2 right-2 bg-white p-2 rounded-full shadow-md"
                onClick={() => toggleLike(restaurant.id)}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill={restaurant.isLiked ? "red" : "none"}
                  viewBox="0 0 24 24"
                  stroke="red"
                  className="w-6 h-6"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth="2"
                    d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 
                       2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 
                       3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 
                       3.78-3.4 6.86-8.55 11.54L12 21.35z"
                  />
                </svg>
              </button>
            </div>
            <div className="p-4">
              <h3 className="text-lg font-semibold text-gray-800">
                {restaurant.name || `Restaurant ${restaurant.id}`}
              </h3>
              <p className="text-gray-600 text-sm mb-2">
                {restaurant.description || "An amazing experience."}
              </p>
              {renderStars(restaurant.id, restaurant.stars)}
            </div>
          </div>
        ))}
      </div>

      <div className="flex flex-col items-end mt-4">
        <div className="flex space-x-4">
          <button
            className="w-12 h-12 flex justify-center items-center rounded-full border-2 bg-white border-blue-500 text-[#46a0db] shadow-lg hover:bg-blue-100 transition duration-300"
            onClick={() => handleScroll(-1)}
          >
            {"<"}
          </button>
          <button
            className="w-12 h-12 flex justify-center items-center rounded-full bg-[#46a0db] text-white shadow-lg hover:bg-[#275878] transition duration-300"
            onClick={() => handleScroll(1)}
          >
            {">"}
          </button>
        </div>
      </div>
    </section>
  );
};

export default Restaurants;
