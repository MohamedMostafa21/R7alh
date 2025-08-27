import { useRef, useState } from "react";
import { Link } from "react-router-dom";
import { usePlans } from "../../../api/endPints";

const ChooseYourPlan = () => {
  const { data: plans, isLoading, error } = usePlans();
  const scrollContainerRef = useRef(null);
  const [likes, setLikes] = useState({});
  const [stars, setStars] = useState({});

  if (isLoading) return <p>Loading plans...</p>;
  if (error) return <p>Error: {error.message || "Error loading plans."}</p>;

  const handleScroll = (direction) => {
    if (scrollContainerRef.current) {
      const scrollAmount = 200;
      scrollContainerRef.current.scrollLeft += direction * scrollAmount;
    }
  };

  const toggleLike = (id) => {
    setLikes((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const handleStarClick = (id, starValue) => {
    setStars((prev) => ({ ...prev, [id]: starValue }));
  };

  const renderStars = (id) => {
    const totalStars = 5;
    const currentStars = stars[id] || 0;
    return (
      <div className="flex">
        {[...Array(totalStars)].map((_, index) => (
          <span
            key={index}
            className={index < currentStars ? "text-yellow-400" : "text-gray-300"}
            onClick={() => handleStarClick(id, index + 1)}
            style={{ cursor: "pointer" }}
          >
            ★
          </span>
        ))}
      </div>
    );
  };

  return (
    <section className="mb-12">
      <h2 className="text-start text-2xl font-bold mb-6">
        <Link className="main hover:text-[#4f9ed2] font-bold" to="/Home/plans">
          Choose Your Plan
        </Link>
      </h2>

      <div ref={scrollContainerRef} className="flex space-x-4 overflow-x-auto scrollbar-hide">
        {plans.map((plan) => (
          <div
            key={plan.id}
            className="min-w-[300px] bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
          >
            <div className="relative">
                <Link to={`/Home/Plan/${plan.id}`}>
              <img
                src={`http://localhost:5200${plan.thumbnailUrl}`}
                alt={plan.name}
                className="w-full h-48 object-cover"
              />
              </Link>
              <button
                className="absolute top-2 right-2 bg-white p-2 rounded-full shadow-md"
                onClick={() => toggleLike(plan.id)}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill={likes[plan.id] ? "red" : "none"}
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
              <h3 className="text-lg font-semibold text-gray-800">{plan.name}</h3>
              {/* <p className="text-gray-600 text-sm mb-2">{plan.description}</p> */}
              {renderStars(plan.id)}
            </div>
          </div>
        ))}
      </div>

      <div className="flex justify-end mt-4">
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

export default ChooseYourPlan;
