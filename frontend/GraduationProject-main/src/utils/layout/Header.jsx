import { useState } from "react";
import { NavLink, useNavigate } from "react-router-dom";
import Logo from "../../assets/Logo-removebg-preview (1).png";

const Header = () => {
  const navigate = useNavigate();
  const [showLogout, setShowLogout] = useState(false);


  const user = JSON.parse(localStorage.getItem("user"));

 
  const handleLogout = () => {
    localStorage.removeItem("user");
    navigate("/");
  };

  return (
    <header className="fixed top-0 left-0 w-full bg-white z-50 shadow-md">
      <div className="container mx-auto px-4 py-3 flex justify-between items-center">
        {/* Logo */}
        <div className="flex items-center gap-4 text-[#4f9ed2] font-bold text-lg">
          <img src={Logo} alt="Logo" className="w-16 h-16" />
          <span>R7alah</span>
        </div>

        {/* Navigation */}
        <nav className="space-x-8 font-medium">
          <NavLink to="/Home" className="main hover:text-[#4f9ed2]">
            Ra7ala
          </NavLink>
          <NavLink to="/Home/discover" className="main hover:text-[#4f9ed2]">
            Discover
          </NavLink>
          <NavLink to="/Home/cities" className="main hover:text-[#4f9ed2]">
            Cities
          </NavLink>

          <NavLink to="/Home/Hotels" className="main hover:text-[#4f9ed2]">
            Hotels
          </NavLink>
          <NavLink to="/Home/Restaurants" className="main hover:text-[#4f9ed2]">
            Restaurants
          </NavLink>
          <NavLink to="/Home/plans" className="main hover:text-[#4f9ed2]">
            Plans
          </NavLink>
          <NavLink to="/Home/tour-guide" className="main hover:text-[#4f9ed2]">
            Tour Guide
          </NavLink>
           <NavLink to="/Home/ApplayAsTourGuide" className="main hover:text-[#4f9ed2]">
            Apply as a TourGuide
          </NavLink>
        </nav>

        {/* User Section */}
        {user ? (
          <div className="relative flex items-center space-x-3">
            <span className="text-gray-600">
              {user.firstname} {user.lastname}
            </span>
            <img
              src={
                user.photo ||
                "https://th.bing.com/th/id/R.ba8fe1a0fc14ceffe284896f1ecb6ab7?rik=EPoQwKIZoZbTEQ&pid=ImgRaw&r=0"
              }
              alt="User"
              className="w-10 h-10 rounded-full border border-gray-300 cursor-pointer"
              onClick={() => setShowLogout(!showLogout)}
            />
            {showLogout && (
              <button
                onClick={handleLogout}
                className="absolute right-0 mt-12  text-white rounded-lg shadow-md "
              >
                Logout
              </button>
            )}
          </div>
        ) : (
          <span className="text-gray-600">Log In</span>
        )}
      </div>
    </header>
  );
};

export default Header;
