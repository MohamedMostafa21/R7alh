import Img from "../../assets/place.jpg";
import Description from "./Description";
import Gallary from "./Gallary";

import Reviews from "./Reviews";
import RelatedHotels from "./RelatedHotels";
import { useParams } from "react-router-dom";
import { useFetchPlaceDetails } from "../../api/endPints"; 
import Activity from "./Activities";

function Hotel() {
  const { id } = useParams();

  const {
    data: place,
    isLoading,
    error,
  } = useFetchPlaceDetails(id); 

  if (isLoading) return <p>Loading place details...</p>;
  if (error) return <p>Error: {error.message || "Error loading place details."}</p>;

  return (
    <div className="mb-16">
      <div className="relative h-screen">
        <img
          src={Img}
          alt=""
          className="absolute inset-0 w-full h-full object-cover z-0"
        />
        <div className="absolute inset-0 bg-black/70 z-10"></div>
        <div className="absolute inset-0 flex flex-col items-center justify-center text-center text-white z-20 px-4">
          <h1 className="text-4xl md:text-5xl font-bold mb-4">
            {place.name?.split("").map((char, i) => (
              <span
                key={i}
                className="opacity-0 animate-fade-in"
                style={{
                  animationDelay: `${i * 0.1}s`,
                  animationFillMode: "forwards",
                }}
              >
                {char}
              </span>
            ))}
          </h1>
          <p className="max-w-xl text-sm md:text-base mb-6">
            {place.description || "Experience a great stay at our hotel."}
          </p>
          <div className="flex gap-4">
            <button className="text-2xl bg-[#2f6d9f] shadow-lg hover:bg-[#24577f] text-white px-10 py-2 rounded-md flex items-center gap-4">
              Book now
            </button>
            <a
              href={`https://www.google.com/maps?q=${place.latitude},${place.longitude}`}
              target="_blank"
              rel="noopener noreferrer"
              className="bg-transparent relative text-2xl border border-white text-white px-10 py-2 rounded-md flex items-center gap-4 overflow-hidden group"
            >
              <span className="absolute bottom-0 left-[-10%] w-[120%] h-full bg-[#24577f] transform -skew-x-12 scale-x-0 origin-bottom-left transition-transform duration-700 ease-out group-hover:scale-x-100 z-0"></span>
              <span className="relative z-10">Location</span>
            </a>
          </div>
        </div>
      </div>

      <Description place={place} />
      <Gallary place={place} />
      <Activity place={place} />
      <Reviews place={place} />
      <RelatedHotels place={place} />
    </div>
  );
}

export default Hotel;
