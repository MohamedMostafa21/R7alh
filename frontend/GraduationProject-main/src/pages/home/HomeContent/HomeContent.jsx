import ChooseYourPlan from "./ChooseYourPlan";
import Discover from "./Discover";
import ExploreCities from "./ExploreCities";
import Hotels from "./Hotels";
import Restaurants from "./Restaurants";
import TourGuide from "./TourGuide";

const HomeContent = () => {
  return (
    <div>
      

      <div className=" container mx-auto p-6 mt-16 ">
        <Discover />
        <ExploreCities />
        <Hotels/>
        <Restaurants/>
        <ChooseYourPlan />
        <TourGuide />
      </div>
    </div>
  );
};

export default HomeContent;
