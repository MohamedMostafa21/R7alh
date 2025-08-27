import ShowPlaces from "./Show/ShowPlaces";
import ShowHotels from "./Show/ShowHotels";
import ShowPlans from "./Show/ShowPlans";
import ShowRestaurants from "./Show/ShowRestaurant";
import ShowCities from "./Show/ShowCities"
const MainAdmin = () => {
  return (
    <div className="flex-1  h-screen">
      <div className="bg-slate-200 rounded-lg shadow-sm h-full overflow-hidden">
        <div className="max-h-[95vh] overflow-y-auto ">
          <ShowPlaces />
          <ShowHotels />
          <ShowPlans />
          <ShowCities/>
          <ShowRestaurants />
        </div>
      </div>
    </div>
  );
};

export default MainAdmin;
