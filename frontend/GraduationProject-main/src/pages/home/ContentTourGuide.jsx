import { useState } from "react";
import { useTourGuides } from "../../api/endPints"
import { Link } from "react-router-dom";
const ContentTourGuide = () => {
  const { data: Tour = [], isLoading, error } = useTourGuides();
  const [searchTerm, setSearchTerm] = useState("");

  const filteredGuides = Tour.filter((guide) =>
    `${guide.firstName} ${guide.lastName}`.toLowerCase().includes(searchTerm.toLowerCase()) ||
    guide.languages?.join(", ").toLowerCase().includes(searchTerm.toLowerCase())
  );

  if (isLoading) return <p>Loading tour guides...</p>;
  if (error) return <p>Error: {error.message || "Error loading data."}</p>;

  return (
    <section className="pl-12 pr-12 pb-12">
      <div className="flex justify-between items-center mb-6">
        <h2 className="main cursor-pointer text-2xl hover:text-[#4f9ed2] font-bold">All Tour Guides</h2>
        <input
          type="text"
          placeholder="Search for a guide or language..."
          className="p-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#162c58]"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        {filteredGuides.length > 0 ? (
          filteredGuides.map((guide) => (
            <div
              key={guide.id}
              className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
            >
              <div className="relative">
                   <Link to={`/Home/TourGuide/${guide.id}`}>
                <img
                  src={`http://localhost:5200${guide.profilePictureUrl}`}
                  alt={`${guide.firstName} ${guide.lastName}`}
                  className="w-full h-48 object-cover"
                />
                </Link>
                <span className="absolute bottom-0 right-0 bg-[#162c58] text-white px-3 py-1 rounded text-sm font-semibold">
                  {guide.hourlyRate } EGP/Hr
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
              </div>
            </div>
          ))
        ) : (
          <p className="text-gray-600 col-span-full text-center">No guides found.</p>
        )}
      </div>
    </section>
  );
};

export default ContentTourGuide;
