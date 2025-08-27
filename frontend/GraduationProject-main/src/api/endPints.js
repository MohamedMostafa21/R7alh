import axios from "axios";
import { useQuery } from "@tanstack/react-query";
import { useMutation } from "@tanstack/react-query";
//Login
export const loginApi = async (loginData) => {
  try {
    const response = await axios.post(`/api/Auth/login`, loginData);
    const token = response.data.token;
    if (token) {
      localStorage.setItem("token", token);
    }
    return response.data;
  } catch (error) {
    throw error.response ? error.response.data : { message: "Server Error" };
  }
};
//Register
export const registerApi = async (formData) => {
  try {
    const response = await axios.post(`/api/Auth/register`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return {
      data: response.data,
      message: response.data.message || "Registration successful!",
    };
  } catch (error) {
    throw {
      data: error.response?.data,
      message: error.response?.data?.message || "Registration Failed",
    };
  }
};

//Home Discover
export const getPlacessApi = async () => {
  const response = await axios.get(`/api/Places`);
  return response.data;
};
export const usePlaces = () => {
  return useQuery({
    queryKey: ["places"],
    queryFn: getPlacessApi,
  });
};

//api/Cities
export const getCitiesApi = async () => {
  const response = await axios.get(`/api/Cities`);
  return response.data;
};
export const useCities = () => {
  return useQuery({
    queryKey: ["cities"],
    queryFn: getCitiesApi,
  });
};
//api/Hotels
export const getHotelsApi = async () => {
  const response = await axios.get(`/api/Hotels`);
  return response.data;
};
export const useHotels = () => {
  return useQuery({
    queryKey: ["Hotels"],
    queryFn: getHotelsApi,
  });
};

//api/Restaurants
export const getRestaurantsApi = async () => {
  const response = await axios.get(`/api/Restaurants`);
  return response.data;
};
export const useRestaurants = () => {
  return useQuery({
    queryKey: ["Restaurants"],
    queryFn: getRestaurantsApi,
  });
};

const getPlanApi = async () => {
  const token = localStorage.getItem("token");

  const response = await axios.get(`/api/Plans`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });

  return response.data;
};

export const usePlans = () => {
  return useQuery({
    queryKey: ["Plans"],
    queryFn: getPlanApi,
  });
};

//api/TourGuides
export const getTourGuidesApi = async () => {
  const token = localStorage.getItem("token");

  const response = await axios.get(`/api/TourGuides`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });

  return response.data;
};
export const useTourGuides = () => {
  return useQuery({
    queryKey: ["TourGuides"],
    queryFn: getTourGuidesApi,
  });
};

// api/Places
export const useFetchPlaceDetails = (id) => {
  return useQuery({
    queryKey: ["place-details", id],
    queryFn: async () => {
      const response = await axios.get(`/api/Places/${id}`);
      return response.data;
    },
    enabled: !!id,
  });
};
//api/places/{id}/activities
export const useFetchPlaceActivityDetails = (id) => {
  return useQuery({
    queryKey: ["place-activity", id],
    queryFn: async () => {
      const response = await axios.get(`/api/Places/${id}/activities`);
      return response.data;
    },
    enabled: !!id,
  });
};

export const useFetchTourGuideDetails = (id) => {
  const token = localStorage.getItem("token");

  return useQuery({
    queryKey: ["TourGuide", id],
    queryFn: async () => {
      const response = await axios.get(`/api/TourGuides/${id}`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      return response.data;
    },
    enabled: !!id,
  });
};
//api/Cities/id
export const useFetchCitiesDetails = (id) => {
  return useQuery({
    queryKey: ["Cities", id],
    queryFn: async () => {
      const response = await axios.get(`/api/Cities/${id}`);
      return response.data;
    },
    enabled: !!id,
  });
};
//api/Hotels/id
export const useFetchHotelsDetails = (id) => {
  return useQuery({
    queryKey: ["Hotels", id],
    queryFn: async () => {
      const response = await axios.get(`/api/Hotels/${id}`);
      return response.data;
    },
    enabled: !!id,
  });
};
//api/Restaurants/id
export const useFetchRestaurantsDetails = (id) => {
  return useQuery({
    queryKey: ["Restaurants", id],
    queryFn: async () => {
      const response = await axios.get(`/api/Restaurants/${id}`);
      return response.data;
    },
    enabled: !!id,
  });
};
export const useFetchPlansDetails = (id) => {
  const token = localStorage.getItem("token");

  return useQuery({
    queryKey: ["Plans", id],
    queryFn: async () => {
      const response = await axios.get(`/api/Plans/${id}`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      return response.data;
    },
    enabled: !!id,
  });
};
// PUT City
export const useUpdateCity = () => {
  return useMutation({
    mutationFn: async ({ id, data }) => {
      const response = await axios.put(`/api/Cities/${id}`, data);
      return response.data;
    },
  });
};

// PUT Hotel
export const useUpdateHotel = () => {
  return useMutation({
    mutationFn: async ({ id, data }) => {
      const response = await axios.put(`/api/Hotels/${id}`, data);
      return response.data;
    },
  });
};
// PUT Restaurant
export const useUpdateRestaurant = () => {
  return useMutation({
    mutationFn: async ({ id, data }) => {
      const response = await axios.put(`/api/Restarants/${id}`, data);
      return response.data;
    },
  });
};
export const useUpdatePlan = () => {
  const token = localStorage.getItem("token");

  return useMutation({
    mutationFn: async ({ id, data }) => {
      const response = await axios.put(`/api/Plans/${id}`, data, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      return response.data;
    },
  });
};
// PUT Place
export const useUpdatePlace = () => {
  return useMutation({
    mutationFn: async ({ id, data }) => {
      const response = await axios.put(`/api/Places/${id}`, data);
      return response.data;
    },
  });
};
// post Place
export const useCreatePlace = () => {
  return useMutation({
    mutationFn: async (data) => {
      const token = localStorage.getItem("token");
      const response = await axios.post("/api/Plans", data, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      return response.data;
    },
  });
};

// post City
export const useCreateCity = () => {
  return useMutation({
    mutationFn: async (formData) => {
      const token = localStorage.getItem("token");
      const response = await axios.post("/api/Cities", formData, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      return response.data;
    },
  });
};

// post Hotel
export const useCreateHotel = () => {
  return useMutation({
    mutationFn: async (formData) => {
      const token = localStorage.getItem("token");
      const response = await axios.post("/api/Hotels", formData, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      return response.data;
    },
  });
};

//post Restaurant
export const useCreateRestaurant = () => {
  return useMutation({
    mutationFn: async (formData) => {
      const token = localStorage.getItem("token");
      const response = await axios.post("/api/Restaurants", formData, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      return response.data;
    },
  });
};

//post plan
export const useCreatePlan = () => {
  return useMutation({
    mutationFn: async (formData) => {
      const token = localStorage.getItem("token");
      const response = await axios.post("/api/Plans", formData, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      return response.data;
    },
  });
};

export const useCreateTourGuideProfile = () => {
  return useMutation({
    mutationFn: async (formData) => {
      const token = localStorage.getItem("token");

      const response = await axios.post("/api/TourGuides/apply", formData, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      return response.data;
    },
  });
};

//get status tourguide
export function useGetTourGuideStatus() {
  const token = localStorage.getItem("token");

  return useQuery({
    queryKey: ["tourGuideStatus"],
    queryFn: async () => {
      const response = await axios.get("/api/TourGuides/status", {
        headers: { Authorization: `Bearer ${token}` },
      });
      console.log("status",response.data);
      return response.data;
    },
  });
}

