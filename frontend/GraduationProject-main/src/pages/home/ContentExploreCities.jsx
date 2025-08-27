import { useState } from "react";
import { useCities } from "../../api/endPints";
import { Link } from "react-router-dom";

const ContentExploreCities = () => {
  const [searchTerm, setSearchTerm] = useState("");
  const [likedCities, setLikedCities] = useState({});

  const { data, isLoading, error } = useCities();

  if (isLoading) return <p>Loading cities...</p>;
  if (error) return <p>Error: {error.message || "Error loading cities."}</p>;

  const filteredCities = data?.filter((city) =>
    city.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const toggleLike = (cityName) => {
    setLikedCities((prev) => ({
      ...prev,
      [cityName]: !prev[cityName],
    }));
  };

  return (
    <section className="mb-12 p-12">
      <div className="flex items-center justify-between mb-6">
        <h2 className="main cursor-pointer text-2xl hover:text-[#4f9ed2] font-bold">
          Explore Cities
        </h2>
        <input
          type="text"
          placeholder="Search cities..."
          className="px-6 py-3 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-6">
        {filteredCities?.map((city, index) => (
          <div key={index} className="relative">
            <Link
              to={`/Home/City/${city.id}`}
              className="block h-48 bg-cover bg-center rounded-lg flex items-center justify-center font-semibold text-lg text-white shadow-md"
              style={{
                backgroundImage: `url("http://localhost:5200${city.thumbnailUrl}")`,
              }}
            >
              {city.name}
            </Link>

            <button
              onClick={(e) => {
                e.stopPropagation();
                e.preventDefault();
                toggleLike(city.name);
              }}
              className="absolute top-2 right-2 bg-white p-2 rounded-full shadow-md"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill={likedCities[city.name] ? "red" : "none"}
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
        ))}
      </div>
    </section>
  );
};

export default ContentExploreCities;
