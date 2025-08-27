import { NavLink } from "react-router-dom";
import {
  Search,
  Building,
  Hotel,
  Route,
  UtensilsCrossed,
  Settings,
  Menu,
  X,
} from "lucide-react";

import { useState } from "react";

export default function Dashboard() {
  const [sidebarOpen, setSidebarOpen] = useState(true);

  const toggleSidebar = () => {
    setSidebarOpen(!sidebarOpen);
  };

  return (
    <div className="min-h-screen bg-gray-100 flex">
      {/* Toggle Button */}
      <button
        onClick={toggleSidebar}
        className="fixed top-4 left-4 z-50  bg-white rounded-md shadow-lg hover:bg-gray-50 transition-colors"
      >
        {sidebarOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
      </button>

      {/* Sidebar */}
      <div
        className={`fixed z-40 top-0 left-0 h-full bg-slate-200 shadow-lg transform ${
          sidebarOpen ? "translate-x-0" : "-translate-x-full"
        } transition-transform duration-300 w-80`}
      >
        {/* Header */}
        <div className="p-6 border-b border-gray-200 mt-20">
        

          <h1 className="text-2xl font-bold text-gray-900 mb-6">Dashboard</h1>

          {/* Search Bar */}
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
            <input
              type="text"
              placeholder="Search"
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
        </div>

        {/* Menu Items */}
        <div className="p-4 space-y-2">
          <NavLink
            to="/CreateNewPlace"
            onClick={() => setSidebarOpen(false)}
            className={({ isActive }) =>
              `w-full flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${
                isActive
                  ? "text-white bg-[#275878]"
                  : "text-gray-700 hover:bg-gray-100"
              }`
            }
          >
            <Building className="w-5 h-5" />
            <span className="font-medium">Create Place</span>
          </NavLink>

          <NavLink
            to="/CreateNewCity"
            onClick={() => setSidebarOpen(false)}
            className={({ isActive }) =>
              `w-full flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${
                isActive
                  ? "text-white bg-[#275878]"
                  : "text-gray-700 hover:bg-gray-100"
              }`
            }
          >
            <Hotel className="w-5 h-5" />
            <span className="font-medium">Create City</span>
          </NavLink>

          <NavLink
            to="/CreateNewHotel"
            onClick={() => setSidebarOpen(false)}
            className={({ isActive }) =>
              `w-full flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${
                isActive
                  ? "text-white bg-[#275878]"
                  : "text-gray-700 hover:bg-gray-100"
              }`
            }
          >
            <Hotel className="w-5 h-5" />
            <span className="font-medium">Create Hotel</span>
          </NavLink>

          <NavLink
            to="/CreateNewPlan"
            onClick={() => setSidebarOpen(false)}
            className={({ isActive }) =>
              `w-full flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${
                isActive
                  ? "text-white bg-[#275878]"
                  : "text-gray-700 hover:bg-gray-100"
              }`
            }
          >
            <Route className="w-5 h-5" />
            <span className="font-medium">Create Plan</span>
          </NavLink>

          <NavLink
            to="/CreateNewRestuarant"
            onClick={() => setSidebarOpen(false)}
            className={({ isActive }) =>
              `w-full flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${
                isActive
                  ? "text-white bg-[#275878]"
                  : "text-gray-700 hover:bg-gray-100"
              }`
            }
          >
            <UtensilsCrossed className="w-5 h-5" />
            <span className="font-medium">Create Restaurant</span>
          </NavLink>
        </div>

        {/* Settings at bottom */}
        <div className="w-fit absolute bottom-6 left-4 right-4">
          <NavLink
            to="/settings"
            onClick={() => setSidebarOpen(false)}
            className={({ isActive }) =>
              `w-full flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${
                isActive ? "text-white bg-[#275878]" : "text-gray-700 "
              }`
            }
          >
            <div className="flex items-center space-x-2 w-fit">
              <Settings className="w-5 h-5" />
              <span className="font-medium">Settings</span>
            </div>
          </NavLink>
        </div>
      </div>
    </div>
  );
}
