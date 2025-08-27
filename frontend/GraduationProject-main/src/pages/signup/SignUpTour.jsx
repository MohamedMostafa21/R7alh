import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Logo from "../../assets/Logo-removebg-preview (1).png";
import { registerApi } from "../../api/endPints";
import BackgroundVideo from "../../assets/BackgroundVideo.mp4";

function SignUpTour() {
  const [formData, setFormData] = useState({
    FirstName: "",
    LastName: "",
    Email: "",
    Password: "",
    DateOfBirth: "",
    Gender: "",
    Country: "",
    PhoneNumber: "",
    ProfilePicture: null,
  });
  const navigate = useNavigate();
  const [message, setMessage] = useState("");

  const handleChange = (e) => {
    const { name, value, files } = e.target;
    if (files) {
      setFormData((prevData) => ({
        ...prevData,
        [name]: files[0],
      }));
    } else {
      setFormData((prevData) => ({
        ...prevData,
        [name]: value,
      }));
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const data = new FormData();
      Object.keys(formData).forEach((key) => {
        data.append(key, formData[key]);
      });

      const response = await registerApi(data);
      setMessage(response.message);

      navigate("/");
    } catch (error) {
      const errorMessage = error.data[0];

      setMessage(errorMessage);
    }
  };

  return (
    <div className="relative flex justify-center items-center min-h-screen">
      <video
        className="absolute top-0 left-0 w-full h-screen object-cover -z-10"
        autoPlay
        loop
        muted
      >
        <source src={BackgroundVideo} type="video/mp4" />
      </video>

      <div className="absolute top-0 left-0 w-full h-screen bg-black opacity-50"></div>

      <div className="absolute top-6 left-6 flex items-center gap-3 z-10">
        <img src={Logo} alt="Logo" className="w-16 h-16" />
        <h1 className="text-3xl font-bold text-white">R7alh</h1>
      </div>

      <div
        className="bg-white bg-opacity-25 backdrop-blur-lg shadow-lg rounded-xl p-6 md:p-8 flex flex-col items-center w-full max-w-xl relative z-10"
        style={{ maxHeight: "95vh", minHeight: "75vh" }}
      >
        <div className="bg-opacity-25 rounded-xl flex flex-col items-center w-full max-w-xl relative z-10">
          <h2 className="text-4xl font-bold text-white mb-3 text-center">
            Create an Account
          </h2>
          <p className="text-gray-200 text-center mb-5 text-lg">
            Enter details to sign up Guide to Egypt
          </p>
        </div>
        <form className="w-full" onSubmit={handleSubmit}>
          <div className="mb-5 flex items-center gap-4">
            <div className="bg-white rounded-full w-14 h-14 overflow-hidden">
              {formData.ProfilePicture && (
                <img
                  src={URL.createObjectURL(formData.ProfilePicture)}
                  alt="Profile"
                  className="w-full h-full object-cover"
                />
              )}
            </div>
            <div className="relative border border-gray-300 rounded-lg bg-opacity-80 cursor-pointer bg-[#46a0db]">
              <input
                type="file"
                accept="image/*"
                name="ProfilePicture"
                onChange={handleChange}
                className="w-full h-full opacity-0 absolute top-0 left-0 cursor-pointer"
              />
              <div className="flex px-3 py-2 rounded-full text-white text-center justify-center hover:bg-[#3694c7]">
                Upload Photo
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <input
              type="text"
              name="FirstName"
              value={formData.FirstName}
              onChange={handleChange}
              required
              placeholder="First Name"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300"
            />
            <input
              type="text"
              name="LastName"
              value={formData.LastName}
              onChange={handleChange}
              required
              placeholder="Last Name"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300"
            />
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <input
              type="tel"
              name="PhoneNumber"
              value={formData.PhoneNumber}
              onChange={handleChange}
              placeholder="Phone Number"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300"
            />
            <input
              type="date"
              name="DateOfBirth"
              value={formData.DateOfBirth}
              onChange={handleChange}
              placeholder="Date of Birth"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300"
            />
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <input
              type="text"
              name="Country"
              value={formData.Country}
              onChange={handleChange}
              placeholder="Country"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300"
            />
            <select
              name="Gender"
              value={formData.Gender}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300"
            >
              <option value="" disabled>
                Gender
              </option>
              <option value="Male">Male</option>
              <option value="Female">Female</option>
            </select>
          </div>

          <input
            type="email"
            name="Email"
            value={formData.Email}
            onChange={handleChange}
            required
            placeholder="Email"
            className="w-full px-4 py-2 mb-4 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300"
          />
          <input
            type="text"
            name="city"
            value={formData.City}
            onChange={handleChange}
            required
            placeholder="City"
            className="w-full px-4 py-2 mb-4 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300"
          />
          <input
            type="password"
            name="Password"
            value={formData.Password}
            onChange={handleChange}
            required
            placeholder="Password"
            className="w-full px-4 py-2 mb-5 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300"
          />

          <button
            type="submit"
            className="w-full rounded-full bg-[#46a0db] text-white py-3 shadow-md hover:bg-[#3694c7] transition text-lg"
          >
            Sign up
          </button>

          {message && (
            <p className="mt-3 text-center text-white">{message.description}</p>
          )}
          <span className="text-white"> Already have an account? </span>
          <a href="/" className="text-[#cce7ff] hover:underline">
            Log in
          </a>
        </form>
      </div>
    </div>
  );
}

export default SignUpTour;
