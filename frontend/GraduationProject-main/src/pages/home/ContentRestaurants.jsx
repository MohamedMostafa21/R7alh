import { useState } from "react";
import { useRestaurants } from "../../api/endPints";
import { Link } from "react-router-dom";
const ContentRestaurants = () => {
  const { data, isLoading, error } = useRestaurants();
  const [searchTerm, setSearchTerm] = useState("");
  const [price, setPrice] = useState(500);
  const [likes, setLikes] = useState({}); // { id: true/false }

  const toggleLike = (id) => {
    setLikes((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  // Get maximum price for slider
  const maxPrice = Math.max(...(data?.map((r) => r.averagePrice) ?? [1000]));

  // Apply filters
  const filteredData = data
    ?.filter((restaurant) => restaurant.averagePrice <= price)
    ?.filter((restaurant) =>
      searchTerm ? restaurant.cuisine.toLowerCase() === searchTerm.toLowerCase() : true
    );

  // Cuisine options manually defined
  const cuisineOptions = ["Egyptian", "Fast Food", "Italian", "Asian", "Grill"];

  if (isLoading) return <p className="text-center">Loading...</p>;
  if (error) return <p className="text-center text-red-500">Error: {error.message}</p>;

  return (
    <section className="mb-12 p-10">
      <div className="flex justify-between items-center mb-6 flex-wrap gap-4">
        <h2 className="main cursor-pointer text-2xl hover:text-[#4f9ed2] font-bold">
          Choose Your Restaurants
        </h2>

        {/* Filter: Price */}
        <div className="flex items-center gap-4">
          <span>Price</span>
          <input
            type="range"
            min="0"
            max={maxPrice}
            value={price}
            onChange={(e) => setPrice(Number(e.target.value))}
            className="cursor-pointer"
          />
          <span>{price}$</span>
        </div>

        {/* Filter: Cuisine */}
        <select
          className="border rounded-lg p-2"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        >
          <option value="">All Cuisines</option>
          {cuisineOptions.map((type) => (
            <option key={type} value={type}>
              {type}
            </option>
          ))}
        </select>
      </div>

      {/* Restaurant Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 overflow-y-auto">
        {filteredData && filteredData.length > 0 ? (
          filteredData.map((restaurant) => (
            <div
              key={restaurant.id}
              className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
            >
              <div className="relative">
                   <Link to={`/Home/Restaurant/${restaurant.id}`}>
                <img
                  src={`http://localhost:5200${restaurant.thumbnailUrl}`}
                  alt={restaurant.name}
                  className="w-full h-48 object-cover"
                />
                </Link>
                <button
                  className="absolute top-2 right-2 bg-white p-2 rounded-full shadow-md"
                  onClick={() => toggleLike(restaurant.id)}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill={likes[restaurant.id] ? "red" : "none"}
                    viewBox="0 0 24 24"
                    stroke="red"
                    className="w-6 h-6"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 
                         2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 
                         4.5 2.09C13.09 3.81 14.76 3 16.5 3 
                         19.58 3 22 5.42 22 8.5c0 3.78-3.4 
                         6.86-8.55 11.54L12 21.35z"
                    />
                  </svg>
                </button>
              </div>
              <div className="p-4">
                <h3 className="text-lg font-semibold">{restaurant.name}</h3>
                <p className="text-sm text-gray-600 mb-2">{restaurant.cuisine}</p>
                <span className="text-lg font-bold">{restaurant.averagePrice}$</span>
              </div>
            </div>
          ))
        ) : (
          <p className="text-center text-gray-500 col-span-4">
            No restaurants available within this price range.
          </p>
        )}
      </div>
    </section>
  );
};

export default ContentRestaurants;
