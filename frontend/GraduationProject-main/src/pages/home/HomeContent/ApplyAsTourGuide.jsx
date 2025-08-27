
import { useState, useEffect } from "react";
import {
  Loader2,
  CheckCircle,
  AlertCircle,
  User,
  Briefcase,
  Code,
  DollarSign,
  FileText,
  Upload,
} from "lucide-react";
import {
  useCreateTourGuideProfile,
  useGetTourGuideStatus,
} from "../../../api/endPints";

export default function ProfileForm() {
  const [formData, setFormData] = useState({
    Bio: "",
    YearsOfExperience: "",
    languages: [],
    hourlyRate: "",
    CV: null,
    ProfilePicture: null,
  });

  const [newLanguage, setNewLanguage] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [applicationStatus, setApplicationStatus] = useState("");
  const [serverMessage, setServerMessage] = useState("");

  const { data: application } =
    useGetTourGuideStatus();

  const {
    mutate: postProfile,
    isLoading,
    isError,
    isSuccess,

    reset,
  } = useCreateTourGuideProfile();

  useEffect(() => {
    if (
      application?.status === "Pending" ||
      application?.status === "Accepted"
    ) {
      setShowForm(false);
      setApplicationStatus(application.status);
      setServerMessage(`Your application status is: ${application.status}`);
    } else if (application?.status === "Rejected") {
      setShowForm(false);
      setApplicationStatus("R");
      setServerMessage("Your application was R. You can apply again.");
    } else {
      setShowForm(true);
    }
  }, [application]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
    if (isError || isSuccess) reset();
  };

  const handleFileChange = (e, fieldName) => {
    const file = e.target.files[0];
    setFormData((prev) => ({ ...prev, [fieldName]: file }));
    if (isError || isSuccess) reset();
  };

  const addLanguage = () => {
    const lang = newLanguage.trim();
    if (lang && !formData.languages.includes(lang)) {
      setFormData((prev) => ({
        ...prev,
        languages: [...prev.languages, lang],
      }));
      setNewLanguage("");
    }
  };

  const removeLanguage = (langToRemove) => {
    setFormData((prev) => ({
      ...prev,
      languages: prev.languages.filter((l) => l !== langToRemove),
    }));
  };

  const validateForm = () => {
    if (!formData.Bio.trim()) return "Bio is required";
    if (!formData.YearsOfExperience) return "Years of experience is required";
    if (formData.languages.length === 0)
      return "At least one language is required";
    if (!formData.CV) return "CV is required";
    return null;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const validationError = validateForm();
    if (validationError) {
      alert(validationError);
      return;
    }

    const data = new FormData();
    data.append("Bio", formData.Bio);
    data.append("YearsOfExperience", formData.YearsOfExperience);
    data.append("hourlyRate", formData.hourlyRate || "");
    data.append("languages", JSON.stringify(formData.languages));
    if (formData.CV) data.append("CV", formData.CV);
    if (formData.ProfilePicture)
      data.append("ProfilePicture", formData.ProfilePicture);

    postProfile(data, {
      onSuccess: (response) => {
        setShowForm(false);
        setApplicationStatus(response.status || "Pending");
        setServerMessage(
          response.message || "Your application is now pending."
        );
      },
      onError: (error) => {
        const apiMessage =
          error?.response?.data?.message ||
          "Something went wrong, please try again.";
        setServerMessage(apiMessage);
      },
    });
  };

  const resetForm = () => {
    setFormData({
      Bio: "",
      YearsOfExperience: "",
      languages: [],
      hourlyRate: "",
      CV: null,
      ProfilePicture: null,
    });
    setNewLanguage("");
    setShowForm(true);
    setApplicationStatus("");
    setServerMessage("");
    reset();
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-2xl mx-auto">
        <div className="bg-white rounded-2xl shadow-xl overflow-hidden">
          <div className="bg-[#275878] px-8 py-6">
            <h1 className="text-3xl font-bold text-white text-center">
              It’s not just a job, it’s an adventure — Let's become a TourGuide
            </h1>
          </div>

          {!showForm && (
          
     <div className={`mx-8 mt-6 p-4 ${application?.status === "Accepted" ?"bg-green-600 border border-black": "bg-yellow-50 border border-yellow-200" } rounded-lg`}>

{/* {console.log("server",serverMessage)} */}
              <div className="flex items-center">
                <h3 className="text-sm font-medium text-black">
                  {serverMessage}
                </h3>
              </div>
              {applicationStatus === "Rejected" && (
                <button
                  onClick={() => setShowForm(true)}
                  className="mt-3 text-sm text-blue-800 hover:text-blue-900 underline"
                >
                  Apply Again
                </button>

              )}
            </div>
          )}

          {isSuccess && (
            <div className="mx-8 mt-6 p-4 bg-green-50 border border-green-200 rounded-lg">
              <div className="flex items-center">
                <CheckCircle className="w-5 h-5 text-green-600 mr-3" />
                <h3 className="text-sm font-medium text-green-800">
                  {serverMessage || "Profile created successfully!"}
                </h3>
              </div>
              <button
                onClick={resetForm}
                className="mt-3 text-sm text-green-800 hover:text-green-900 underline"
              >
                Create another profile
              </button>
            </div>
          )}

          {isError && (
            <div className="mx-8 mt-6 p-4 bg-red-50 border border-red-200 rounded-lg">
              <div className="flex items-center">
                <AlertCircle className="w-5 h-5 text-red-600 mr-3" />
                <div>
                  <h3 className="text-sm font-medium text-red-800">
                    An error occurred
                  </h3>
                  <p className="text-sm text-red-700 mt-1">{serverMessage}</p>
                </div>
              </div>
            </div>
          )}

          {showForm && (
            <form onSubmit={handleSubmit} className="p-8 space-y-8">
              {/* Bio */}
              <div className="space-y-2">
                <label className="flex items-center text-sm font-semibold text-gray-700">
                  <User className="w-4 h-4 mr-2 text-blue-600" />
                  Bio<span className="text-red-500 ml-1">*</span>
                </label>
                <textarea
                  name="Bio"
                  value={formData.Bio}
                  onChange={handleInputChange}
                  rows="4"
                  disabled={isLoading}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg resize-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Tell us about yourself and your experience..."
                />
              </div>

              <div className="space-y-2">
                <label className="flex items-center text-sm font-semibold text-gray-700">
                  <Briefcase className="w-4 h-4 mr-2 text-blue-600" />
                  Years of Experience
                  <span className="text-red-500 ml-1">*</span>
                </label>
                <input
                  type="number"
                  name="YearsOfExperience"
                  value={formData.YearsOfExperience}
                  onChange={handleInputChange}
                  min="0"
                  max="50"
                  disabled={isLoading}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  placeholder="e.g., 5"
                />
              </div>

              <div className="space-y-2">
                <label className="flex items-center text-sm font-semibold text-gray-700">
                  <Code className="w-4 h-4 mr-2 text-blue-600" />
                  Languages<span className="text-red-500 ml-1">*</span>
                </label>
                <div className="flex gap-2">
                  <input
                    type="text"
                    value={newLanguage}
                    onChange={(e) => setNewLanguage(e.target.value)}
                    onKeyDown={(e) =>
                      e.key === "Enter" && (e.preventDefault(), addLanguage())
                    }
                    disabled={isLoading}
                    className="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    placeholder="e.g., English"
                  />
                  <button
                    type="button"
                    onClick={addLanguage}
                    disabled={!newLanguage.trim() || isLoading}
                    className="px-6 py-3 bg-[#275878] text-white rounded-lg hover:bg-[#16374c]"
                  >
                    Add
                  </button>
                </div>
                {formData.languages.length > 0 && (
                  <div className="flex flex-wrap gap-2 mt-3">
                    {formData.languages.map((lang, index) => (
                      <span
                        key={index}
                        className="inline-flex items-center px-3 py-1 rounded-full bg-blue-100 text-blue-800 border border-blue-200 text-sm"
                      >
                        {lang}
                        <button
                          type="button"
                          onClick={() => removeLanguage(lang)}
                          disabled={isLoading}
                          className="ml-2 text-blue-600 hover:text-blue-800"
                        >
                          ×
                        </button>
                      </span>
                    ))}
                  </div>
                )}
              </div>

              <div className="space-y-2">
                <label className="flex items-center text-sm font-semibold text-gray-700">
                  <DollarSign className="w-4 h-4 mr-2 text-blue-600" />
                  Hourly Rate<span className="text-red-500 ml-1">*</span>
                </label>
                <div className="relative">
                  <input
                    type="number"
                    name="hourlyRate"
                    value={formData.hourlyRate}
                    onChange={handleInputChange}
                    min="0"
                    step="0.01"
                    disabled={isLoading}
                    className="w-full px-4 py-3 pr-12 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    placeholder="e.g., 25.00"
                  />
                  <span className="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-500">
                    $
                  </span>
                </div>
              </div>

              {/* CV Upload */}
              <div className="space-y-2">
                <label className="flex items-center text-sm font-semibold text-gray-700">
                  <FileText className="w-4 h-4 mr-2 text-blue-600" />
                  CV/Resume<span className="text-red-500 ml-1">*</span>
                </label>
                <div className="relative">
                  <input
                    type="file"
                    onChange={(e) => handleFileChange(e, "CV")}
                    accept=".pdf,.doc,.docx"
                    disabled={isLoading}
                    className="hidden"
                    id="cv-upload"
                  />
                  <label
                    htmlFor="cv-upload"
                    className={`flex items-center justify-center w-full px-4 py-6 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:border-blue-400 hover:bg-blue-50 ${
                      isLoading ? "cursor-not-allowed opacity-50" : ""
                    }`}
                  >
                    <div className="text-center">
                      <Upload className="w-8 h-8 mx-auto text-gray-400 mb-2" />
                      <span className="text-sm text-gray-600">
                        {formData.CV
                          ? formData.CV.name
                          : "Click to upload your CV/Resume"}
                      </span>
                      <p className="text-xs text-gray-400 mt-1">
                        PDF, DOC, DOCX
                      </p>
                    </div>
                  </label>
                </div>
              </div>

              {/* Profile Picture Upload */}
              <div className="space-y-2">
                <label className="flex items-center text-sm font-semibold text-gray-700">
                  <User className="w-4 h-4 mr-2 text-blue-600" />
                  Profile Picture
                </label>
                <div className="relative">
                  <input
                    type="file"
                    onChange={(e) => handleFileChange(e, "ProfilePicture")}
                    accept="image/*"
                    disabled={isLoading}
                    className="hidden"
                    id="profile-upload"
                  />
                  <label
                    htmlFor="profile-upload"
                    className={`flex items-center justify-center w-full px-4 py-6 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:border-blue-400 hover:bg-blue-50 ${
                      isLoading ? "cursor-not-allowed opacity-50" : ""
                    }`}
                  >
                    <div className="text-center">
                      <Upload className="w-8 h-8 mx-auto text-gray-400 mb-2" />
                      <span className="text-sm text-gray-600">
                        {formData.ProfilePicture
                          ? formData.ProfilePicture.name
                          : "Click to upload your profile picture"}
                      </span>
                      <p className="text-xs text-gray-400 mt-1">
                        JPG, PNG, GIF
                      </p>
                    </div>
                  </label>
                </div>
              </div>

              {/* Submit Button */}
              <div className="pt-6">
                <button
                  type="submit"
                  disabled={isLoading}
                  className="w-full bg-[#275878] text-white py-4 px-6 rounded-lg font-semibold text-lg hover:bg-[#16374c] focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
                >
                  {isLoading ? (
                    <span className="flex items-center justify-center">
                      <Loader2 className="w-5 h-5 mr-2 animate-spin" />
                      Submitting...
                    </span>
                  ) : (
                    "Create Profile"
                  )}
                </button>
              </div>
            </form>
          )}
        </div>

        <div className="text-center mt-8">
          <p className="text-gray-600 text-sm">
            All data is protected and encrypted with the highest security
            standards
          </p>
        </div>
      </div>
    </div>
  );
}
