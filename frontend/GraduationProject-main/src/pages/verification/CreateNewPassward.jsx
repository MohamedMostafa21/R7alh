import CreateNewPasswardL from "../../assets/CreateNewPassward.jpg";
import Logo from "../../assets/Logo.jpg";

const CreateNewPassward = () => {
  return (
    <div className="flex flex-col h-screen w-full bg-white">
      {/* Logo Section */}
      <div className="flex gap-2 mb-4 ml-4 mt-4">
        <img src={Logo} alt="Logo" className="w-8 h-8" />
        <h1 className="text-3xl font-bold text-[#4f9ed2]">Guide To Egypt</h1>
      </div>

      <div className="p-8 w-full max-w-7xl flex flex-col md:flex-row md:m-10">
        {/* Left Section */}
        <div className="flex-1 flex flex-col items-start justify-center md:mr-12">
          <h1 className="text-3xl font-bold mb-4">Create new Password</h1>
          <p className="mb-6 text-[#a8a1a3]">Create your new password to login</p>
          <form className="flex flex-col w-full">
            <div className="mb-4 flex flex-col items-start">
              <label htmlFor="password" className="block text-gray-700 font-medium mb-2">
                Password
              </label>
              <input
                type="password"
                id="password"
                name="password"
                className="border border-gray-300 rounded-md px-4 py-3 w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Password"
              />
            </div>

            <div className="mb-4 flex flex-col items-start">
              <label htmlFor="confirm-password" className="block text-gray-700 font-medium mb-2">
                Confirm Password
              </label>
              <input
                type="password"
                id="confirm-password"
                name="confirm-password"
                className="border border-gray-300 rounded-md px-4 py-3 w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Password"
              />
            </div>

            <button
              type="submit"
              className="bg-[#46a0db] hover:bg-blue-600 text-white font-medium py-3 px-4 rounded-md w-full mt-6"
            >
              Submit
            </button>
          </form>
        </div>

        {/* Right Section */}
        <div className="flex-1 hidden md:flex items-center justify-center">
          <img src={CreateNewPasswardL} alt="Placeholder" className="h-auto object-contain " />
        </div>
      </div>
    </div>
  );
};

export default CreateNewPassward;
