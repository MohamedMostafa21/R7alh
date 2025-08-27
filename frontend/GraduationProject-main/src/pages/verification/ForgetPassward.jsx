import ForgetPassward from "../../assets/ForgetPassward.jpg";
import Logo from "../../assets/Logo.jpg";

const ForgotPasswordForm = () => {
  return (
    <div className="flex flex-col mt-2 mb-2 h-screen w-full">
      {/* Logo Section */}
      <div className="flex gap-2 mb-2 ml-0 ">
        <img src={Logo} alt="Logo" className="w-6 h-8" />
        <h1 className="text-3xl font-bold text-[#4f9ed2]">Guide To Egypt</h1>
      </div>
      <div className="  p-8 w-full max-w-7xl flex md:m-10 md:mt-6 md:ml-20">
        <div className="flex-1  flex flex-col items-start justify-center">
          <h1 className="text-2xl font-bold mb-4">Forgot Password</h1>
          <p className="mb-6 text-[#a8a1a3]">Please enter your email account to reset your password.</p>
          <form className="flex flex-col w-full">
            <div className="mb-4 flex flex-col items-start">
              <label htmlFor="email" className="block text-gray-700 font-medium mb-2">
                Email
              </label>
              <input
                type="email"
                id="email"
                name="email"
                className="border border-gray-300 rounded-md px-4 py-3 w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Email@.com"
              />
            </div>
            <button
              type="submit"
              className="bg-[#46a0db] hover:bg-blue-600 text-white font-medium py-3 px-4 rounded-md w-full mt-12"
            >
              Reset Password
            </button>
          </form>
        </div>
        <div className="flex-1 pl-8 hidden md:block ">
          <img src={ForgetPassward} alt="placeholder" className="h-full object-contain" />
        </div>
      </div>
    </div>
  );
};

export default ForgotPasswordForm;
