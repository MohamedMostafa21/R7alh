// import { useState } from 'react';
import { Plus } from "lucide-react";

const ReviewsComponent = () => {
  //   const [sortBy, setSortBy] = useState('Most Recent');
  //   const [rateFilter, setRateFilter] = useState('Rate');

  const reviews = [
    {
      id: 1,
      name: "Arlene McCoy",
      date: "2 October 2012",
      rating: 4,
      title: "Good Tour, Really Well Organised",
      content:
        "The tour was very well organised. One minus is that you get completely bombarded with information. You also have to stand up for too long at the private entrance to the Tower of London, which leads to a lack of time later. Lunch was the same, too stress, the quality was great but you couldn't enjoy it. I'd like to ask the organisers: please",
      verified: true,
      helpful: "Yes",
      avatar: "/api/placeholder/40/40",
    },
    {
      id: 2,
      name: "Arlene McCoy",
      date: "2 October 2012",
      rating: 4,
      title: "Good Tour, Really Well Organised",
      content:
        "The tour was very well organised. One minus is that you get completely bombarded with information. You also have to stand up for too long at the private entrance to the Tower of London, which leads to a lack of time later. Lunch was the same, too stress, the quality was great but you couldn't enjoy it. I'd like to ask the organisers: please",
      verified: true,
      helpful: "Yes",
      avatar: "/api/placeholder/40/40",
    },
    {
      id: 3,
      name: "Arlene McCoy",
      date: "2 October 2012",
      rating: 4,
      title: "Good Tour, Really Well Organised",
      content:
        "The tour was very well organised. One minus is that you get completely bombarded with information. You also have to stand up for too long at the private entrance to the Tower of London, which leads to a lack of time later. Lunch was the same, too stress, the quality was great but you couldn't enjoy it. I'd like to ask the organisers: please",
      verified: true,
      helpful: "Yes",
      avatar: "/api/placeholder/40/40",
    },
    {
      id: 4,
      name: "Arlene McCoy",
      date: "2 October 2012",
      rating: 4,
      title: "Good Tour, Really Well Organised",
      content:
        "The tour was very well organised. One minus is that you get completely bombarded with information. You also have to stand up for too long at the private entrance to the Tower of London, which leads to a lack of time later. Lunch was the same, too stress, the quality was great but you couldn't enjoy it. I'd like to ask the organisers: please",
      verified: true,
      helpful: "Yes",
      avatar: "/api/placeholder/40/40",
    },
  ];

  //   const StarRating = ({ rating }) => {
  //     return (
  //       <div className="flex items-center gap-1">
  //         {[1, 2, 3, 4, 5].map((star) => (
  //           <svg
  //             key={star}
  //             className="w-4 h-4"
  //             viewBox="0 0 24 24"
  //             fill={star <= rating ? '#fb923c' : '#d1d5db'}
  //           >
  //             <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
  //           </svg>
  //         ))}
  //       </div>
  //     );
  //   };

  //   const DropdownButton = ({ value, options, onChange }) => {
  //     const [isOpen, setIsOpen] = useState(false);

  //     return (
  //       <div className="relative">
  //         <button
  //           onClick={() => setIsOpen(!isOpen)}
  //           className="flex items-center justify-between px-4 py-2 border border-gray-300 rounded-lg bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 min-w-[140px]"
  //         >
  //           <span className="text-gray-700">{value}</span>
  //           <ChevronDown className="w-4 h-4 ml-2 text-gray-400" />
  //         </button>

  //         {isOpen && (
  //           <div className="absolute top-full left-0 mt-1 w-full bg-white border border-gray-300 rounded-lg shadow-lg z-10">
  //             {options.map((option) => (
  //               <button
  //                 key={option}
  //                 onClick={() => {
  //                   onChange(option);
  //                   setIsOpen(false);
  //                 }}
  //                 className="w-full px-4 py-2 text-left text-gray-700 hover:bg-gray-50 first:rounded-t-lg last:rounded-b-lg"
  //               >
  //                 {option}
  //               </button>
  //             ))}
  //           </div>
  //         )}
  //       </div>
  //     );
  //   };

  return (
    <div className="max-w-8xl mx-auto p-7  min-h-screen">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Reviews</h1>

        {/* <div className="flex items-center gap-4">
          <DropdownButton
            value={sortBy}
            options={['Most Recent', 'Oldest First', 'Highest Rating', 'Lowest Rating']}
            onChange={setSortBy}
          />
          
          <DropdownButton
            value={rateFilter}
            options={['Rate', '5 Stars', '4 Stars', '3 Stars', '2 Stars', '1 Star']}
            onChange={setRateFilter}
          />
        </div> */}
      </div>

      {/* Reviews List */}
      <div className="space-y-6 mb-8">
        {reviews.map((review) => (
          <div key={review.id} className="bg-white rounded-lg p-6  ">
            <div className="flex items-start gap-4">
              {/* Avatar */}
              <div className="w-12 h-12 rounded-full bg-gray-300 flex-shrink-0 overflow-hidden">
                <img
                  src="https://i.pinimg.com/736x/93/31/67/9331676bb16bb8a56d4a8b4435eddd21.jpg"
                  className="w-full h-full"
                  alt=""
                />
              </div>

              {/* Review Content */}
              <div className="flex-1  text-left">
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-2">
                    <h3 className="font-semibold text-gray-900">
                      {review.name}
                    </h3>
                    {review.verified && (
                      <svg
                        className="w-4 h-4 text-blue-500"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                      >
                        <path
                          fillRule="evenodd"
                          d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                          clipRule="evenodd"
                        />
                      </svg>
                    )}
                  </div>

                  <div className="flex items-center gap-4">
                    <span className="text-sm text-gray-500">Helpful?</span>
                    <span className="text-sm  font-medium">
                      {review.helpful}
                    </span>
                  </div>
                </div>

                <div className="flex items-center gap-2 mb-2">
                  {/* <StarRating rating={review.rating} /> */}
                  <span className="text-sm text-gray-500">{review.date}</span>
                </div>

                <h4 className="font-semibold text-gray-900 mb-3">
                  {review.title}
                </h4>

                <p className="text-gray-700 leading-relaxed">
                  {review.content}
                </p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Add Review Button */}
      <div className="flex justify-end">
        <button className="flex items-center gap-2 px-6 py-3 bg-[#275878] text-white rounded-lg hover:bg-[#1e4660] focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
          <span>Add Reviews</span>
          <Plus className="w-5 h-5" />
        </button>
      </div>
    </div>
  );
};

export default ReviewsComponent;
