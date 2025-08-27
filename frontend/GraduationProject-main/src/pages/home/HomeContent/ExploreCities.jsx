import { useRef } from "react";
import { Link } from "react-router-dom";
import { useCities } from "../../../api/endPints";

export default function ExploreCities() {
  const scrollContainerRef = useRef(null);

  const handleScroll = (direction) => {
    if (scrollContainerRef.current) {
      const scrollAmount = 200;
      scrollContainerRef.current.scrollLeft += direction * scrollAmount;
    }
  };

  const { data, isLoading, error } = useCities();

  if (isLoading) return <p>Loading cities...</p>;
  if (error) return <p>Error: {error.message || "Error loading cities."}</p>;

  return (
    <section className="mb-12">
      <h2 className="text-start text-2xl font-bold mb-6">
        <Link className="main hover:text-[#4f9ed2] font-bold" to="/Home/cities">
          Explore Cities
        </Link>
      </h2>

      <div
        ref={scrollContainerRef}
        className="flex space-x-4 overflow-x-auto scrollbar-hide"
      >
        {data.map((city) => (
          <div
            key={city.id}
            to={`/Home/City/${city.id}`}
            className="min-w-[250px] bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
          >
            <div className="relative">
               <Link to={`/Home/City/${city.id}`}>
              <img
                src={`http://localhost:5200${city.thumbnailUrl}`}
                alt={city.name}
                className="w-full h-40 object-cover"
              />
              </Link>
            </div>
            <div className="p-4 text-center">
              <h3 className="text-lg font-semibold text-gray-800">
                {city.name}
              </h3>
            </div>
          </div>
        ))}
      </div>

      <div className="flex flex-col items-end mt-4">
        <div className="flex space-x-4">
          <button
            className="w-12 h-12 flex justify-center items-center rounded-full border-2 bg-white border-blue-500 text-[#46a0db] shadow-lg hover:bg-blue-100 transition duration-300"
            style={{ boxShadow: "0 4px 6px rgba(70, 160, 219, 0.5)" }}
            onClick={() => handleScroll(-1)}
          >
            {"<"}
          </button>
          <button
            className="w-12 h-12 flex justify-center items-center rounded-full bg-[#46a0db] text-white shadow-lg hover:bg-[#275878] transition duration-300"
            style={{ boxShadow: "0 4px 16px rgba(70, 160, 219, 0.5)" }}
            onClick={() => handleScroll(1)}
          >
            {">"}
          </button>
        </div>
      </div>
    </section>
  );
}
