import { useState } from "react";
import Img from "../../assets/ImageHotel.jpg";
const Description = () => {
  const [isLiked, setIsLiked] = useState(false);
  const handleClick = () => {
    setIsLiked(!isLiked);
  };
  return (
    <div className="max-w-8xl mx-auto bg-white rounded-lg p-7 flex flex-col md:flex-row ">
      {/* Left Side: Image */}
      <div className="w-full md:w-1/2 ">
        <div className="">
          <img
            src={Img}
            alt="restaurant"
            className="w-3/4 h-80 object-cover rounded-md"
          />
        </div>
        {/* Info Bar */}
        <div className="flex gap-10 items-center mt-4 text-sm text-gray-700 px-1">
          <div className="flex items-center gap-1">
            {/* <FaMapMarkerAlt className="text-blue-500" /> */}
            <span>Google Maps Location</span>
          </div>
          <div className="flex items-center gap-1">
            {/* <FaDollarSign className="text-green-500" /> */}
            <span>Entry Fee: 20$</span>
          </div>
          <div className="flex items-center gap-1">
            {/* <FaClock className="text-yellow-500" /> */}
            <span>Time: 09:11</span>
          </div>
        </div>
      </div>

      {/* Right Side: Text */}
      <div className="w-full md:w-1/2 flex flex-col justify-around text-left">
        <div>
          <h2 className=" text-2xl font-bold text-[#275878] mb-2">
            Grand Nile Tower Hotel
          </h2>
          <p className="text-gray-800 mb-2">
            Nestled along the stunning banks of the Nile River in Cairo, the
            Grand Nile Tower Hotel offers a luxurious retreat with breathtaking
            views and world-class amenities. This iconic 5-star hotel features
            elegantly designed rooms, a revolving restaurant on the 41st floor
            providing panoramic vistas, and a wellness center overlooking the
            river. Guests can indulge in a variety of dining experiences, from
            international cuisine to authentic Egyptian dishes, and even enjoy a
            private yacht for unique adventures. Ideal for both leisure and
            business travelers, the hotel boasts state-of-the-art conference
            facilities.
          </p>
          
        </div>

        {/* Button and Like */}
        <div className="flex items-center gap-4 mt-4">
          <button className="bg-[#275878] text-white px-6 py-2 rounded-md hover:bg-[#1e4660] transition">
            Book now
          </button>

          <button
            onClick={handleClick}
            className="w-16 h-10 bg-blue-100 border-2 border-blue-300 rounded-lg flex items-center justify-center hover:bg-blue-200 transition-colors duration-200"
          >
            <svg
              className={`w-8 h-8 transition-all duration-200 ${
                isLiked
                  ? "text-blue-300 fill-white"
                  : "text-[#275878] fill-[#275878]"
              }`}
              stroke="currentColor"
              strokeWidth="2"
              viewBox="0 0 24 24"
            >
              <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
            </svg>
          </button>
        </div>
      </div>
    </div>
  );
};

export default Description;
