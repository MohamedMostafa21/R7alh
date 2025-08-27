import { useState } from 'react';
import { Heart } from 'lucide-react';
import {  Star, ChevronLeft, ChevronRight } from 'lucide-react';

const RoomsComponent = () => {
  const [favorites, setFavorites] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);

  const rooms = [
    {
      id: 1,
      image: "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80",
      price: "500 EGP",
      title: "Room",
      type: "Single",
      rating: 4.6
    },
    {
      id: 2,
      image: "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80",
      price: "500 EGP",
      title: "Room",
      type: "Double",
      rating: 4.6
    },
    {
      id: 3,
      image: "https://images.unsplash.com/photo-1618773928121-c32242e63f39?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80",
      price: "500 EGP",
      title: "Room",
      type: "Single",
      rating: 4.6
    },
    {
      id: 4,
      image: "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80",
      price: "500 EGP",
      title: "Room",
      type: "Double",
      rating: 4.6
    },
    {
      id: 5,
      image: "https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80",
      price: "600 EGP",
      title: "Room",
      type: "Single",
      rating: 4.8
    },
    {
      id: 6,
      image: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80",
      price: "650 EGP",
      title: "Room",
      type: "Double",
      rating: 4.7
    }
  ];

  const toggleFavorite = (roomId) => {
    setFavorites(prev => 
      prev.includes(roomId) 
        ? prev.filter(id => id !== roomId)
        : [...prev, roomId]
    );
  };

  const nextSlide = () => {
    setCurrentIndex((prev) => 
      prev + 4 >= rooms.length ? 0 : prev + 1
    );
  };

  const prevSlide = () => {
    setCurrentIndex((prev) => 
      prev === 0 ? Math.max(0, rooms.length - 4) : prev - 1
    );
  };

  const visibleRooms = rooms.slice(currentIndex, currentIndex + 4);

  return (
    <div className="bg-slate-200 p-7 h-auto">
      {/* Header */}
      <div className="flex justify-between items-center ">
        <h1 className="text-3xl font-bold text-black">Rooms</h1>
          <button className="bg-slate-200 text-gray-700 hover:text-gray-900 font-medium text-lg transition-colors">
          See all
        </button>
      </div>

      {/* Slider Container */}
      <div className="relative">
        {/* Navigation Buttons */}
        {currentIndex > 0 && (
          <button
            onClick={prevSlide}
            className="absolute left-0 top-1/2 -translate-y-1/2 z-10 w-10 h-10 bg-white rounded-full shadow-lg flex items-center justify-center hover:bg-gray-50 transition-colors -ml-5"
          >
            <ChevronLeft size={20} className="text-gray-600" />
          </button>
        )}

        {currentIndex + 4 < rooms.length && (
          <button
            onClick={nextSlide}
            className="absolute right-0 top-1/2 -translate-y-1/2 z-10 w-10 h-10 bg-white rounded-full shadow-lg flex items-center justify-center hover:bg-gray-50 transition-colors -mr-5"
          >
            <ChevronRight size={20} className="text-gray-600" />
          </button>
        )}

        {/* Rooms Grid */}
        <div className="overflow-hidden">
          <div 
            className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-transform duration-300 ease-in-out"
          >
            {visibleRooms.map((room) => (
              <div key={room.id} className="bg-white rounded-2xl overflow-hidden shadow-sm">
                {/* Image Container */}
                <div className="relative">
                  <img 
                    src={room.image} 
                    alt={room.title}
                    className="w-full h-44 object-cover"
                  />
                  
                  {/* Heart Icon - Top Left */}
                  <button
                    onClick={() => toggleFavorite(room.id)}
                    className="absolute top-3 left-3 w-7 h-7 bg-white bg-opacity-80 rounded-full flex items-center justify-center shadow-sm hover:bg-opacity-100 transition-all"
                  >
                    <Heart 
                      size={14} 
                      className={`${
                        favorites.includes(room.id) 
                          ? 'fill-red-500 text-red-500' 
                          : 'text-gray-600'
                      }`}
                    />
                  </button>

                  {/* Price Badge - Bottom Left */}
                  <div className="absolute bottom-3 left-3 bg-slate-800 text-white px-2.5 py-1 rounded-md text-xs font-medium">
                    {room.price}
                  </div>
                </div>

                {/* Content Section */}
                <div className="p-3">
                  {/* Title and Rating Row */}
                  <div className="flex justify-between items-center mb-1">
                    <h3 className="text-base font-medium text-black">
                      {room.title}
                    </h3>
                    <div className="flex items-center gap-0.5">
                      <Star size={14} className="fill-amber-400 text-amber-400" />
                      <span className="text-xs text-gray-600">({room.rating})</span>
                    </div>
                  </div>
                  
                  {/* Room Type */}
                  <p className={`text-sm font-medium ${
                    room.type === 'Single' ? 'text-sky-500' : 'text-sky-500'
                  }`}>
                    {room.type}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Dots Indicator */}
        <div className="flex justify-center mt-6 gap-2">
          {Array.from({ length: Math.ceil(rooms.length / 4) }).map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentIndex(index * 4)}
              className={`w-2 h-2 rounded-full transition-colors ${
                Math.floor(currentIndex / 4) === index 
                  ? 'bg-slate-800' 
                  : 'bg-slate-400'
              }`}
            />
          ))}
        </div>
      </div>
    </div>
  );
};

export default RoomsComponent;