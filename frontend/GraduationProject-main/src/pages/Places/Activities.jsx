import { useState } from 'react';
import { useParams } from 'react-router-dom';
import { Heart, Star, ChevronLeft, ChevronRight } from 'lucide-react';
import { useFetchPlaceActivityDetails } from '../../api/endPints';

const Activity = () => {
  const { id } = useParams();
  const { data: activities = [], isLoading, error } = useFetchPlaceActivityDetails(id);

  const [favorites, setFavorites] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);

  const toggleFavorite = (activityId) => {
    setFavorites((prev) =>
      prev.includes(activityId)
        ? prev.filter((id) => id !== activityId)
        : [...prev, activityId]
    );
  };

  const nextSlide = () => {
    setCurrentIndex((prev) =>
      prev + 4 >= activities.length ? 0 : prev + 1
    );
  };

  const prevSlide = () => {
    setCurrentIndex((prev) =>
      prev === 0 ? Math.max(0, activities.length - 4) : prev - 1
    );
  };

  const visibleActivities = activities.slice(currentIndex, currentIndex + 4);

  if (isLoading) return <p>Loading activities...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <div className="bg-slate-200 p-7 h-auto">
      {/* Header */}
      <div className="flex justify-between items-center mb-4">
        <h1 className="text-3xl font-bold text-black">Activities</h1>
        <button className="bg-slate-200 text-gray-700 hover:text-gray-900 font-medium text-lg transition-colors">
          See all
        </button>
      </div>

      {/* Slider */}
      <div className="relative">
        {currentIndex > 0 && (
          <button
            onClick={prevSlide}
            className="absolute left-0 top-1/2 -translate-y-1/2 z-10 w-10 h-10 bg-white rounded-full shadow-lg flex items-center justify-center hover:bg-gray-50 transition-colors -ml-5"
          >
            <ChevronLeft size={20} className="text-gray-600" />
          </button>
        )}

        {currentIndex + 4 < activities.length && (
          <button
            onClick={nextSlide}
            className="absolute right-0 top-1/2 -translate-y-1/2 z-10 w-10 h-10 bg-white rounded-full shadow-lg flex items-center justify-center hover:bg-gray-50 transition-colors -mr-5"
          >
            <ChevronRight size={20} className="text-gray-600" />
          </button>
        )}

        {/* Activities Grid */}
        <div className="overflow-hidden">
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-transform duration-300 ease-in-out">
            {visibleActivities.map((activity) => (
              <div key={activity.id} className="bg-white rounded-2xl overflow-hidden shadow-sm">
                <div className="relative">
                  <img
                    src={`http://localhost:5200${activity.thumbnailUrl}`}
                    alt={activity.name}
                    className="w-full h-44 object-cover"
                  />
                  <button
                    onClick={() => toggleFavorite(activity.id)}
                    className="absolute top-3 left-3 w-7 h-7 bg-white bg-opacity-80 rounded-full flex items-center justify-center shadow-sm hover:bg-opacity-100 transition-all"
                  >
                    <Heart
                      size={14}
                      className={`${
                        favorites.includes(activity.id)
                          ? 'fill-red-500 text-red-500'
                          : 'text-gray-600'
                      }`}
                    />
                  </button>

                  <div className="absolute bottom-0 right-0 bg-slate-800 text-white px-6 py-1 rounded-md text-xs font-medium">
                    {activity.price || 'Free'}$
                  </div>
                </div>

                <div className="p-3">
                  <div className="flex justify-between items-center mb-1">
                    <h3 className="text-base font-medium text-black">
                      {activity.name || 'No Name'}
                    </h3>
                    <div className="flex items-center gap-0.5">
                      <Star size={14} className="fill-amber-400 text-amber-400" />
                      <span className="text-xs text-gray-600">
                        ({activity.rating })
                      </span>
                    </div>
                  </div>
                  <p className="text-sm font-medium text-sky-500">
                    {activity.category || 'Activity'}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Dots Indicator */}
        <div className="flex justify-center mt-6 gap-2">
          {Array.from({ length: Math.ceil(activities.length / 4) }).map((_, index) => (
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

export default Activity;
