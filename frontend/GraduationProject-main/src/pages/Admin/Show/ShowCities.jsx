import { useRef } from "react";
import { Link } from "react-router-dom";
import { useCities} from "../../../api/endPints";
// import { FiEdit } from "react-icons/fi";

const Cities = () => {
  const { data: cities = [], isLoading, error } = useCities();
  const scrollContainerRef = useRef(null);

  const handleScroll = (direction) => {
    if (scrollContainerRef.current) {
      const scrollAmount = 200;
      scrollContainerRef.current.scrollLeft += direction * scrollAmount;
    }
  };

  return (
    <section className=" cursor-pointer  ">
      <h2 className="text-start text-2xl font-bold ">
        <Link
          className="main hover:text-[#4f9ed2] font-bold"
          to="/Home/cities"
        >
          Cities
        </Link>
      </h2>

      {isLoading ? (
        <p>Loading...</p>
      ) : error ? (
        <p className="text-red-500">
          {error.message || "Error loading places"}
        </p>
      ) : cities.length > 0 ? (
        <div className="w-full max-w-[1000px] mx-auto">
          <div
            ref={scrollContainerRef}
            className="flex space-x-4 overflow-x-auto scrollbar-hide"
          >
            {cities.map((city) => (
              <Link to={`/Home/City/${city.id}`} key={city.id}>
                <div className="min-w-[180px] h-[130px] relative flex flex-col bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
                  <button
                    onClick={(e) => {
                      e.preventDefault();
                      console.log("Edit place", city.id);
                    }}
                    className="absolute top-2 right-2 z-10 bg-white p-1 rounded-full shadow-md hover:bg-blue-100"
                  >
                     <Link to={`/EditCity/${city.id}`}>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 16 16"
                      width="1em"
                      height="1em"
                    >
                      <path
                        fill="currentColor"
                        d="M15.49 7.3h-1.16v6.35H1.67V3.28H8V2H1.67A1.21 1.21 0 0 0 .5 3.28v10.37a1.21 1.21 0 0 0 1.17 1.25h12.66a1.21 1.21 0 0 0 1.17-1.25z"
                      ></path>
                      <path
                        fill="currentColor"
                        d="M10.56 2.87L6.22 7.22l-.44.44l-.08.08l-1.52 3.16a1.08 1.08 0 0 0 1.45 1.45l3.14-1.53l.53-.53l.43-.43l4.34-4.36l.45-.44l.25-.25a2.18 2.18 0 0 0 0-3.08a2.17 2.17 0 0 0-1.53-.63a2.2 2.2 0 0 0-1.54.63l-.7.69l-.45.44zM5.51 11l1.18-2.43l1.25 1.26zm2-3.36l3.9-3.91l1.3 1.31L8.85 9zm5.68-5.31a.9.9 0 0 1 .65.27a.93.93 0 0 1 0 1.31l-.25.24l-1.3-1.3l.25-.25a.88.88 0 0 1 .69-.25z"
                      ></path>
                    </svg>
                    </Link>
                  </button>

                  <div className="relative w-full h-full">
                    <img
                      src={`http://localhost:5200${city.thumbnailUrl}`}
                      alt={city.name || "Place"}
                      className="w-full h-full object-cover"
                      onError={(e) => {
                        e.target.src = "/default-image.png";
                      }}
                    />
                    <div className="absolute bottom-0 left-0 w-full bg-white bg-opacity-80 text-center text-xs font-semibold py-1 ">
                      {city.name}
                    </div>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>
      ) : (
        <p className="text-gray-500">No cities available.</p>
      )}

       {/* Scroll Buttons Under Images */}
      <div className="flex justify-end mt-1 pr-2">
        <div className="flex space-x-4">
          <button
            className="w-10 h-10 flex justify-center items-center rounded-full border-2 bg-white border-blue-500 text-[#46a0db] shadow-lg hover:bg-blue-100 transition duration-300"
            onClick={() => handleScroll(-1)}
          >
            {"<"}
          </button>
          <button
            className="w-10 h-10 flex justify-center items-center rounded-full bg-[#46a0db] text-white shadow-lg hover:bg-[#275878] transition duration-300"
            onClick={() => handleScroll(1)}
          >
            {">"}
          </button>
        </div>
      </div>
    </section>
  );
};

export default Cities;
