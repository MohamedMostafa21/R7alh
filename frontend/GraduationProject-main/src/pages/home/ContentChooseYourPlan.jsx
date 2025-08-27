import { useState } from "react";
import { usePlans } from "../../api/endPints";
import { Link } from "react-router-dom";
const ContentChooseYourPlan = () => {
  const { data = [], isLoading, error } = usePlans(); 

  const [price, setPrice] = useState(500);
  const [searchTerm, setSearchTerm] = useState("");
  const [likedPlans, setLikedPlans] = useState([]);

  if (isLoading) return <p className="text-center">Loading...</p>;
  if (error) return <p className="text-center text-red-500">Error: {error.message}</p>;

  // Toggle like
  const toggleLike = (id) => {
    setLikedPlans((prev) =>
      prev.includes(id) ? prev.filter((pid) => pid !== id) : [...prev, id]
    );
  };

  const filteredPlans = data.filter((plan) => {
    const matchesCategory = searchTerm === "" || plan.category === searchTerm;
    const matchesPrice = plan.price <= price;
    return matchesCategory && matchesPrice;
  });

  return (
    <section className="mb-12 p-10">
      <div className="flex justify-between items-center mb-6">
        <h2 className="main cursor-pointer text-2xl hover:text-[#4f9ed2] font-bold">
          Choose Your Plan
        </h2>
        <div className="flex items-center gap-4">
          <span>Price</span>
          <input
            type="range"
            min="100"
            max="1000"
            value={price}
            onChange={(e) => setPrice(Number(e.target.value))}
            className="cursor-pointer"
          />
          <span>{price}$</span>
        </div>
        <select
          className="border rounded-lg p-2"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        >
          <option value="">Category</option>
          <option value="Travel">Travel</option>
          <option value="Luxury">Luxury</option>
        </select>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 overflow-y-auto">
        {filteredPlans.length > 0 ? (
          filteredPlans.map((plan) => (
            <div
              key={plan.id}
              className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
            >
              <div className="relative">
                  <Link to={`/Home/Plan/${plan.id}`}>
                <img
                  src={`http://localhost:5200${plan.thumbnailUrl}`}
                  alt={plan.title}
                  className="w-full h-48 object-cover"
                />
                </Link>
                <button
                  className="absolute top-2 right-2 bg-white p-2 rounded-full shadow-md"
                  onClick={() => toggleLike(plan.id)}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill={likedPlans.includes(plan.id) ? "red" : "none"}
                    viewBox="0 0 24 24"
                    stroke="red"
                    className="w-6 h-6"
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
              <div className="p-4">
                <h3 className="text-lg font-semibold">{plan.title}</h3>
                <p className="text-gray-600 text-sm mb-2">
                  🕒{plan.days}-Days  TourGuide {plan.tourGuideName}
                </p>
                <span className="text-lg font-bold">{plan.price}$</span>
              </div>
            </div>
          ))
        ) : (
          <p className="text-center text-gray-500 col-span-4">
            No plans available within this price range.
          </p>
        )}
      </div>
    </section>
  );
};

export default ContentChooseYourPlan;
