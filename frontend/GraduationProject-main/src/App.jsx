import "./App.css";
import "./index.css";
import { Routes, Route, Outlet } from "react-router-dom";
import Login from "./pages/login/Login";
import SignUp from "./pages/signup/SignUpTour";
import ForgetPassward from "./pages/verification/ForgetPassward";
import CreateNewPassward from "./pages/verification/CreateNewPassward";
import VerificationPage from "./pages/verification/Verify";
import Header from "./utils/layout/Header";
import Footer from "./utils/layout/Footer";
import ContentDiscover from "./pages/home/ContentDiscover";
import ContentExploreCities from "./pages/home/ContentExploreCities";
import ContentChooseYourPlan from "./pages/home/ContentChooseYourPlan";
import ContentTourGuide from "./pages/home/ContentTourGuide";
import HomeContent from "./pages/home/HomeContent/HomeContent";
import ContentHotels from "./pages/home/ContentHotels";
import ContentRestaurants from "./pages/home/ContentRestaurants";
import Hotels from "./pages/Hotels/Hotel";
import AnotherHead from "./utils/layout/AnotherHead";
import TourGuide from "./pages/TourGuide/TourGuide";
import Places from "./pages/Places/Place";
import MainAdmin from "./pages/Admin/MainAdmin";
import HeaderAdmin from "./utils/layout/HeaderAdmin";
import CreateHotel from "./pages/Admin/CreateHotel";
import CreatePlace from "./pages/Admin/CreatePlace";
import CreateRestaurant from "./pages/Admin/CreateRestaurant";
import CreatePlan from "./pages/Admin/CreatePlan";
import CreateCity from "./pages/Admin/CreateCity"
import EditPlace from "./pages/Admin/EditPlace"
import EditCity from "./pages/Admin/EditCity"
import EditPlan from "./pages/Admin/EditPlan"
import EditRestaurant from "./pages/Admin/EditRestaurant"
import EditHotel from "./pages/Admin/EditHotel"
import ApplayAsTourGuide from "./pages/home/HomeContent/ApplyAsTourGuide"
function LayoutWithHeaderFooter() {
  return (
    <>
      <Header />
      <main className="mt-20 min-h-[100vh]">
        <Outlet />
      </main>
      <Footer />
    </>
  );
}
function LayoutAdminWithanotherHeaderFooter() {
  return (
    <>
      <div
        style={{ display: "flex", flexDirection: "column", minHeight: "100vh" }}
      >
        <div style={{ display: "flex", flex: 1 }}>
          <HeaderAdmin />

          <div style={{ flex: 1}}>
            <Outlet />
          </div>
        </div>

        <Footer />
      </div>
    </>
  );
}

function LayoutWithanotherHeaderFooter() {
  return (
    <>
      <AnotherHead />
      <main className="min-h-[100vh]">
        <Outlet />
      </main>
      <Footer />
    </>
  );
}

function App() {
  return (
    <Routes>
      <Route path="/" element={<Login />} />

      <Route path="SignUp" element={<SignUp />} />
      <Route path="ForgetPassward" element={<ForgetPassward />} />
      <Route path="CreateNewPassward" element={<CreateNewPassward />} />
      <Route path="Verify" element={<VerificationPage />} />

      <Route element={<LayoutWithHeaderFooter />}>
        <Route path="/Home" element={<HomeContent />} />
        <Route path="/Home/discover" element={<ContentDiscover />} />
        <Route path="/Home/cities" element={<ContentExploreCities />} />
        <Route path="/Home/Hotels" element={<ContentHotels />} />
        <Route path="/Home/plans" element={<ContentChooseYourPlan />} />
        <Route path="/Home/Restaurants" element={<ContentRestaurants />} />
        <Route path="/Home/tour-guide" element={<ContentTourGuide />} />
        <Route path="/Home/ApplayAsTourGuide" element={<ApplayAsTourGuide />} />
      </Route>
      <Route element={<LayoutWithanotherHeaderFooter />}>
        <Route path="/Home/Hotel" element={<Hotels />} />
        <Route path="/Home/Place/:id" element={<Places />} />
        <Route path="/Home/TourGuide/:id" element={<TourGuide />} />
      </Route>
      <Route element={<LayoutAdminWithanotherHeaderFooter />}>
        <Route path="/Admin" element={<MainAdmin />} />
        <Route path="/CreateNewHotel" element={<CreateHotel />} />
        <Route path="/CreateNewPlace" element={<CreatePlace />} />
        <Route path="/CreateNewPlan" element={<CreatePlan />} />
        <Route path="/CreateNewCity" element={<CreateCity />} />
        <Route path="/CreateNewRestuarant" element={<CreateRestaurant />} />
        <Route path="/EditCity/:id" element={<EditCity/>}/>
          <Route path="/EditPlan/:id" element={<EditPlan/>}/>
            <Route path="/EditRestaurant/:id" element={<EditRestaurant/>}/>
              <Route path="/EditHotel/:id" element={<EditHotel/>}/>
                <Route path="/EditPlace/:id" element={<EditPlace/>}/>
                  
      </Route>
    </Routes>
  );
}

export default App;
