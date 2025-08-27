import { useState, useEffect } from 'react';
// import { ChevronLeft, ChevronRight, MapPin } from 'lucide-react';

export default function RelatedHotels() {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isAutoPlaying, setIsAutoPlaying] = useState(true);
  
  const rooms = [
    {
      id: 1,
      image: 'https://i.onthebeach.co.uk/v1/hotel_images/40f7d760-abe0-46f9-ae8f-ff90aee1b860/contain/1000/600/high/1.0/melas-lara-hotel',
      type: 'Room',
      category: 'Single',
      overlay: 'linear-gradient(135deg, rgba(99, 102, 241, 0.3), rgba(168, 85, 247, 0.3))'
    },
    {
      id: 2,
      image: 'https://tse4.mm.bing.net/th/id/OIP.wdRcdYO5W4OTBgsHojYl1AHaE8?cb=thvnextc2&rs=1&pid=ImgDetMain',
      type: 'Room',
      category: 'Double',
      overlay: 'linear-gradient(135deg, rgba(16, 185, 129, 0.3), rgba(5, 150, 105, 0.3))'
    },
    {
      id: 3,
      image: 'https://i.onthebeach.co.uk/v1/hotel_images/40f7d760-abe0-46f9-ae8f-ff90aee1b860/contain/1000/600/high/1.0/melas-lara-hotel',
      type: 'Room',
      category: 'Single',
      overlay: 'linear-gradient(135deg, rgba(75, 85, 99, 0.4), rgba(55, 65, 81, 0.4))'
    },
    {
      id: 4,
      image: 'https://tse4.mm.bing.net/th/id/OIP.wdRcdYO5W4OTBgsHojYl1AHaE8?cb=thvnextc2&rs=1&pid=ImgDetMain',
      type: 'Room',
      category: 'Double',
      overlay: 'linear-gradient(135deg, rgba(245, 158, 11, 0.3), rgba(217, 119, 6, 0.3))'
    },
    {
      id: 5,
      image: 'https://images.unsplash.com/photo-1540518614846-7eded47432f5?w=400&h=300&fit=crop',
      type: 'Room',
      category: 'Single',
      overlay: 'linear-gradient(135deg, rgba(107, 114, 128, 0.4), rgba(75, 85, 99, 0.4))'
    }
  ];

  const nextSlide = () => {
    setCurrentIndex((prev) => (prev + 1) % rooms.length);
  };

  const prevSlide = () => {
    setCurrentIndex((prev) => (prev - 1 + rooms.length) % rooms.length);
    setIsAutoPlaying(false);
  };

  const goToSlide = (index) => {
    setCurrentIndex(index);
    setIsAutoPlaying(false);
  };


  useEffect(() => {
    if (!isAutoPlaying) return;

    const interval = setInterval(() => {
      setCurrentIndex((prev) => (prev + 1) % rooms.length);
    }, 1500);

    return () => clearInterval(interval);
  }, [isAutoPlaying, rooms.length]);


  useEffect(() => {
    if (isAutoPlaying) return;

    const timer = setTimeout(() => {
      setIsAutoPlaying(true);
    }, 5000);

    return () => clearTimeout(timer);
  }, [isAutoPlaying]);

  return (
    <div className="max-w-8xl mx-auto p-7 mb-16">
      {/* Header */}
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-4xl font-bold text-black">Related Hotels</h1>
        <button className="bg-white text-gray-700 hover:text-gray-900 font-medium text-lg transition-colors">
          See all
        </button>
      </div>

      {/* Gallery Container */}
      <div className="relative" 
           onMouseEnter={() => setIsAutoPlaying(false)}
           onMouseLeave={() => setIsAutoPlaying(true)}>
        {/* Navigation Buttons */}
        <button 
          onClick={prevSlide}
          className="absolute left-4 top-1/2 transform -translate-y-1/2 z-10 bg-white/90 hover:bg-white rounded-full p-3 shadow-lg transition-all duration-200 hover:scale-110"
        >
          {/* <ChevronLeft className="w-6 h-6 text-gray-700" /> */}
        </button>
        
        <button 
          onClick={() => {
            nextSlide();
            setIsAutoPlaying(false);
          }}
          className="absolute right-4 top-1/2 transform -translate-y-1/2 z-10 bg-white/90 hover:bg-white rounded-full p-3 shadow-lg transition-all duration-200 hover:scale-110"
        >
          {/* <ChevronRight className="w-6 h-6 text-gray-700" /> */}
        </button>

        {/* Gallery Grid */}
        <div className="flex gap-6 overflow-hidden">
          <div 
            className="flex gap-6 transition-transform duration-500 ease-in-out"
            style={{
              transform: `translateX(-${currentIndex * (288 + 24)}px)`
            }}
          >
            {rooms.map((room) => (
              <div
                key={room.id}
                className="relative flex-shrink-0 w-72 h-80 rounded-2xl overflow-hidden shadow-xl hover:shadow-2xl transition-all duration-300 hover:scale-105 cursor-pointer group"
              >
                {/* Background Image */}
                <div
                  className="absolute inset-0 bg-cover bg-center transition-transform duration-700 group-hover:scale-110"
                  style={{
                    backgroundImage: `url(${room.image})`
                  }}
                />
                
                {/* Gradient Overlay */}
                <div
                  className="absolute inset-0 opacity-60 group-hover:opacity-40 transition-opacity duration-300"
                  style={{
                    background: room.overlay
                  }}
                />
                
                {/* Dark Gradient for Text Readability */}
                <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />
                
                {/* Room Info */}
                <div className="absolute bottom-6 left-6 text-white">
                  <div className="flex items-center space-x-2 bg-black/30 backdrop-blur-sm rounded-full px-4 py-2">
                    {/* <MapPin className="w-4 h-4" /> */}
                    <span className="font-semibold">
                      {room.type}.
                      <span className="font-normal">{room.category}</span>
                    </span>
                  </div>
                </div>

                {/* Hover Effect Overlay */}
                <div className="absolute inset-0 bg-white/0 group-hover:bg-white/10 transition-all duration-300" />
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Auto-play indicator */}
      <div className="flex justify-center mt-4">
        <div className={`text-sm px-3 py-1 rounded-full transition-all duration-200 ${
          isAutoPlaying 
            ? '' 
            : ''
        }`}>
        
        </div>
      </div>

      {/* Scroll Indicator Dots */}
      <div className="flex justify-center mt-8 space-x-2">
        {rooms.map((_, index) => (
          <button
            key={index}
            onClick={() => goToSlide(index)}
            className={`h-3 rounded-full transition-all duration-200 ${
              index === currentIndex 
                ? 'bg-gray-800 w-8' 
                : 'bg-gray-300 hover:bg-gray-400 w-3'
            }`}
          />
        ))}
      </div>
    </div>
  );
}