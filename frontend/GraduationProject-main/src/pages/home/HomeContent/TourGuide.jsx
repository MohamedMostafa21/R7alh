import { useRef, useState } from "react";
import { Link } from "react-router-dom";
import { useTourGuides } from "../../../api/endPints";

const TourGuide = () => {
  const { data: Tour = [], isLoading, error } = useTourGuides();
  const scrollContainerRef = useRef(null);

  const [likes, setLikes] = useState({});
  const [stars, setStars] = useState({});

  const handleScroll = (direction) => {
    if (scrollContainerRef.current) {
      const scrollAmount = 200;
      scrollContainerRef.current.scrollLeft += direction * scrollAmount;
    }
  };

  const toggleHeart = (id) => {
    setLikes((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const handleStarClick = (id, value) => {
    setStars((prev) => ({ ...prev, [id]: value }));
  };

  const renderStars = (id) => {
    const total = 5;
    const current = stars[id] || 0;

    return (
      <div className="flex space-x-1">
        {Array.from({ length: total }).map((_, i) => (
          <span
            key={i}
            onClick={() => handleStarClick(id, i + 1)}
            className={`text-lg cursor-pointer ${
              i < current ? "text-yellow-400" : "text-gray-300"
            }`}
          >
            ★
          </span>
        ))}
      </div>
    );
  };

  if (isLoading) return <p>Loading tour guides...</p>;
  if (error) return <p>Error: {error.message || "Error loading data."}</p>;

  return (
    <section className="mb-12">
      <h2 className="text-start text-2xl font-bold mb-6">
        <Link className="main hover:text-[#4f9ed2] font-bold" to="/Home/tour-guide">
          Tour Guide
        </Link>
      </h2>

      <div ref={scrollContainerRef} className="flex space-x-4 overflow-x-auto scrollbar-hide">
        {Tour.map((guide) => (
         
          <div
            key={guide.id}
            className="min-w-[300px] bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
          >
           
            <div className="relative">
               <Link to={`/Home/TourGuide/${guide.id}`}>
              <img
                src={`http://localhost:5200${guide.profilePictureUrl}`}
                alt={guide.name}
                className="w-full h-48 object-cover"
              />
             </Link>

              {/* Like button */}
              <button
                className="absolute top-2 right-2 bg-white p-2 rounded-full shadow-md"
                onClick={() => toggleHeart(guide.id)}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill={likes[guide.id] ? "red" : "none"}
                  viewBox="0 0 24 24"
                  stroke="red"
                  className="w-6 h-6"
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

              {/* Experience badge */}
              <span className="absolute bottom-0 right-0 bg-[#162c58] text-white px-4 py-2 rounded text-sm font-semibold shadow-md">
                {guide.hourlyRate} EGP/Hr
              </span>
            </div>

            <div className="p-4">
              <h3 className="flex text-start text-lg font-semibold text-gray-800">
                {guide.firstName} {guide.lastName}
              </h3>
              <p className="text-gray-600 text-sm mb-2 flex items-center">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 16 16"
                  width="2em"
                  height="1.7em"
                >
                  <path
                    fill="gray"
                    fillRule="evenodd"
                    d="M11 5a.75.75 0 0 1 .688.452l3.25 7.5a.75.75 0 1 1-1.376.596L12.89 12H9.109l-.67 1.548a.75.75 0 1 1-1.377-.596l3.25-7.5A.75.75 0 0 1 11 5m-1.24 5.5h2.48L11 7.636zM5 1a.75.75 0 0 1 .75.75v1.261a25 25 0 0 1 2.598.211a.75.75 0 1 1-.2 1.487q-.33-.045-.662-.08A13 13 0 0 1 5.92 8.058q.356.456.752.873a.75.75 0 0 1-1.086 1.035A13 13 0 0 1 5 9.307a13 13 0 0 1-2.841 2.546a.75.75 0 0 1-.827-1.251A11.6 11.6 0 0 0 4.08 8.057a13 13 0 0 1-.554-.938a.75.75 0 1 1 1.323-.707l.15.271c.388-.68.708-1.405.952-2.164a24 24 0 0 0-4.1.19a.75.75 0 0 1-.2-1.487q1.28-.171 2.598-.211V1.75A.75.75 0 0 1 5 1"
                    clipRule="evenodd"
                  />
                </svg>
                {guide.languages?.join(", ")}
              </p>
              {renderStars(guide.id)}
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

export default TourGuide;
