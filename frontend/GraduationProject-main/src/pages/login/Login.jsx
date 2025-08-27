import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { loginApi } from "../../api/endPints";
import Logo from "../../assets/Logo-removebg-preview (1).png";
import BackgroundVideo from "../../assets/BackgroundVideo.mp4";

function Login() {
  const [Email, setEmail] = useState("");
  const [Password, setPassword] = useState("");
  const [RememberMe, setRememberMe] = useState(false);
  const [message, setMessage] = useState("");
  const navigate = useNavigate();


  // const handleSubmit = async (e) => {
  //   e.preventDefault();
  //   try {
  //     const loginData = { Email, Password, RememberMe };
  //     const response = await loginApi(loginData);
  //     setMessage(response.message || "Login successful");
  //     if (response) navigate("Home");
  //   }catch (error) {
  //     const errorMessage = error ; 
     

  //     setMessage(errorMessage);
    
  //   }
    
  // };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const loginData = { Email, Password, RememberMe };
      const response = await loginApi(loginData);
  
      if (response && response.token) {
        setMessage("Login successful");
  
        
        localStorage.setItem("user", JSON.stringify({
          firstname: response.user.firstName,
          lastname: response.user.lastName,
          photo: response.user.profilePictureUrl || "https://th.bing.com/th/id/R.ba8fe1a0fc14ceffe284896f1ecb6ab7?rik=EPoQwKIZoZbTEQ&pid=ImgRaw&r=0",
          token: response.token,
      
        
        }));
  
        setTimeout(() => navigate("/Home"), 1000); 
      } else {
        throw new Error(response.message || "Login failed. Please try again.");
      }
    } catch (error) {
      setMessage(error.message || "Something went wrong. Please try again.");
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

      <div className="absolute top-6 left-6 flex items-center gap-2">
        <img src={Logo} alt="Logo" className="w-16 h-16" />
        <h1 className="text-3xl font-bold text-white">R7alh</h1>
      </div>

      <div className="bg-white bg-opacity-20 backdrop-blur-md shadow-lg rounded-2xl p-8 md:p-10 flex flex-col items-center w-full max-w-lg">
        <h2 className="text-3xl font-bold text-white mb-4 text-center">Welcome</h2>
        <p className="text-gray-200 mb-4 text-center text-lg">Log in to continue</p>

        <div className="flex gap-4 w-full max-w-md mb-6">
          <button className="flex-1 bg-white text-black py-2 rounded-lg shadow hover:scale-100 transition text-lg">
            <span className="flex items-center justify-center gap-2">
              <img
                src="https://img.icons8.com/color/50/000000/google-logo.png"
                alt="Google"
              />
              Google
            </span>
          </button>
          <button className="flex-1 bg-white text-black py-2 rounded-lg shadow hover:scale-100 transition text-lg">
            <span className="flex items-center justify-center gap-2">
              <img
                src="https://img.icons8.com/ios-filled/50/3b5998/facebook-new.png"
                alt="Facebook"
              />
              Facebook
            </span>
          </button>
        </div>

        <div className="flex items-center w-full max-w-md mb-4">
          <hr className="border-gray-400 flex-grow" />
          <span className="mx-4 text-gray-200 text-lg">Or</span>
          <hr className="border-gray-400 flex-grow" />
        </div>

        <form className="w-full max-w-md" onSubmit={handleSubmit}>
          <input
            type="email"
            value={Email}
            onChange={(e) => setEmail(e.target.value)}
            required
            placeholder="Your email"
            className="w-full px-4 py-3 mb-4 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300 text-lg"
          />
          <input
            type="password"
            value={Password}
            onChange={(e) => setPassword(e.target.value)}
            required
            placeholder="Password"
            className="w-full px-4 py-3 mb-4 border border-gray-300 rounded-lg bg-white bg-opacity-80 focus:ring-2 focus:ring-blue-300 text-lg"
          />

          <div className="flex items-center mb-4">
            <input
              type="checkbox"
              checked={RememberMe}
              onChange={(e) => setRememberMe(e.target.checked)}
              id="remember"
              className="w-4 h-4 text-blue-600 focus:ring-blue-500 border-blue-500 bg-blue-400 rounded"
            />
            <label htmlFor="remember" className="ml-2 text-gray-200 text-base select-none">
              Remember me?
            </label>
          </div>

          <a href="/ForgetPassward" className="text-[#cce7ff] text-base block text-right hover:underline mb-4">
            Forgot password?
          </a>

          <button type="submit" className="w-full bg-[#46a0db] text-white py-4 rounded-lg shadow-lg hover:bg-[#3694c7] transition text-lg">
            Log in
          </button>
        </form>

        {message && <p className="mt-4 text-white text-center text-lg">{message==="Invalid credentials"?"Invaild Email or Password":""}</p>}

        <p className="text-gray-200 mt-4 text-lg text-center">
          Don’t have an account?{" "}
          <a href="/SignUp" className="text-[#cce7ff] hover:underline">
            Sign up
          </a>
        </p>
      </div>
    </div>
  );
}

export default Login;
