from flask import Flask, request, jsonify
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from math import radians, cos, sin, asin, sqrt, acos
import math

app = Flask(__name__)

# ==== Load All Datasets ====
restaurant_df = pd.read_csv("cleaned_restaurant_data.csv")
hotel_df = pd.read_excel("Ho_Cleaned_Unique.xlsx")
tourism_df = pd.read_csv("places_data_processed.csv")

# ==== Restaurants Processing ====
restaurant_df.drop_duplicates(subset='name', inplace=True)
restaurant_df['name'] = restaurant_df['name'].astype(str).str.strip()
rest_numeric_features = [col for col in restaurant_df.columns if col not in ['name', 'lat', 'lng'] and restaurant_df[col].dtype in [np.int64, np.float64]]
rest_scaled = StandardScaler().fit_transform(restaurant_df[rest_numeric_features].fillna(0))

# ==== Hotels Processing ====
hotel_df.drop_duplicates(subset='Name', inplace=True)
hotel_df['Name'] = hotel_df['Name'].astype(str).str.strip()
hotel_numeric_features = [col for col in hotel_df.columns if col not in ['Name', 'Latitude', 'Longitude'] and hotel_df[col].dtype in [np.int64, np.float64]]
hotel_scaled = StandardScaler().fit_transform(hotel_df[hotel_numeric_features].fillna(0))

# ==== Tourism Places ====
tourism_features = tourism_df.drop(columns=['Name']).astype(float)
tourism_names = tourism_df['Name']

# ==== Similarity Functions ====
def ts_ss(a, b):
    a, b = np.array(a), np.array(b)
    cosine = np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b) + 1e-10)
    euclidean = np.linalg.norm(a - b)
    theta = math.acos(np.clip(cosine, -1.0, 1.0))
    return (1 - cosine) * euclidean * theta

def tsss_similarity(vec1, vec2):
    vec1 = np.array(vec1)
    vec2 = np.array(vec2)
    dot = np.dot(vec1, vec2)
    norm1 = np.linalg.norm(vec1)
    norm2 = np.linalg.norm(vec2)
    cosine_sim = dot / (norm1 * norm2 + 1e-10)
    angle = math.acos(min(1, max(-1, cosine_sim)))
    distance = np.linalg.norm(vec1 - vec2)
    return (1 + cosine_sim) * (1 / (1 + angle)) * (1 / (1 + distance))

def haversine(lat1, lon1, lat2, lon2):
    R = 6371
    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)
    a = sin(dlat/2)**2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon/2)**2
    return 2 * R * asin(sqrt(a))

# ==== Restaurant Recommendations ====
@app.route("/api/restaurants", methods=["GET", "POST"])
def recommend_restaurants():
    if request.method == "GET":
        mode = request.args.get("mode")
        name = request.args.get("name")
        if mode == "restaurants":
            return jsonify(restaurant_df.head(50)[['name']].to_dict(orient="records"))
        if name:
            name = name.strip()
            if name not in restaurant_df['name'].values:
                return jsonify({"error": f"Restaurant '{name}' not found."}), 404
            idx = restaurant_df[restaurant_df['name'] == name].index[0]
            base_vec = rest_scaled[idx]
            dists = [ts_ss(base_vec, rest_scaled[i]) for i in range(len(rest_scaled))]
            restaurant_df['score'] = dists
            top = restaurant_df[restaurant_df['name'] != name].sort_values(by='score').head(10)
            return jsonify(top[['name']].to_dict(orient="records"))
        return jsonify({"error": "Provide ?mode=restaurants or ?name=..."}), 400
    else:
        data = request.get_json()
        prefs = data.get("user_preferences", [])
        indices = [restaurant_df[restaurant_df['name'] == p].index[0] for p in prefs if p in restaurant_df['name'].values]
        if not indices:
            return jsonify({"error": "No matching restaurants found"}), 404
        combined = np.sum([1/(np.linalg.norm(rest_scaled[i] - rest_scaled, axis=1)+1e-10) for i in indices], axis=0)
        top_indices = np.argsort(combined)[::-1]
        excluded = set(prefs)
        result = restaurant_df.iloc[top_indices]
        result = result[~result['name'].isin(excluded)][['name']].drop_duplicates()
        return jsonify(result.head(50).to_dict(orient="records"))

# ==== Hotel Recommendations ====
@app.route("/api/hotels", methods=["GET", "POST"])
def recommend_hotels():
    if request.method == "GET":
        name = request.args.get("name")
        if not name:
            return jsonify({"error": "Missing 'name' parameter"}), 400
        if name.lower() == "hotels":
            return jsonify([{"name": n} for n in hotel_df['Name'].head(50)])
        if name not in hotel_df['Name'].values:
            return jsonify({"error": f"Hotel '{name}' not found."}), 404
        idx = hotel_df[hotel_df['Name'] == name].index[0]
        base_vec = hotel_scaled[idx]
        dists = [ts_ss(base_vec, hotel_scaled[i]) for i in range(len(hotel_scaled))]
        hotel_df['score'] = dists
        top = hotel_df[hotel_df['Name'] != name].sort_values(by='score').head(10)
        return jsonify([{"name": n} for n in top['Name']])
    else:
        data = request.get_json()
        prefs = data.get("hotels", [])
        indices = [hotel_df[hotel_df['Name'] == p].index[0] for p in prefs if p in hotel_df['Name'].values]
        if not indices:
            return jsonify({"error": "No valid hotel names found"}), 404
        combined = np.sum([1/(np.linalg.norm(hotel_scaled[i] - hotel_scaled, axis=1)+1e-10) for i in indices], axis=0)
        top_indices = np.argsort(combined)[::-1]
        results = []
        excluded_names = set(prefs)
        for i in top_indices:
            name = hotel_df.loc[i, 'Name']
            if name not in excluded_names:
                results.append({"name": name})
            if len(results) >= 50:
                break
        return jsonify(results)

# ==== Places Recommendations ====
@app.route("/api/places", methods=["GET", "POST"])
def recommend_places():
    if request.method == "GET":
        name = request.args.get("name")
        if name and name.lower() == "places":
            return jsonify([{"name": n} for n in tourism_df['Name'].head(50)])
        if not name or name not in tourism_df['Name'].values:
            return jsonify({"error": f"Place '{name}' not found."}), 404
        idx = tourism_df[tourism_df['Name'] == name].index[0]
        sims = [ts_ss(tourism_features.iloc[idx], tourism_features.iloc[i]) for i in range(len(tourism_df))]
        tourism_df['score'] = sims
        top = tourism_df[tourism_df['Name'] != name].sort_values(by='score').head(10)
        return jsonify({"results": [{"name": n} for n in top['Name']]})
    else:
        data = request.get_json()
        prefs = data.get("user_preferences", [])
        indices = [tourism_df[tourism_df['Name'] == p].index[0] for p in prefs if p in tourism_df['Name'].values]
        if not indices:
            return jsonify({"error": "No valid places found"}), 400
        avg_vec = tourism_features.iloc[indices].mean()
        excluded_names = set(prefs)
        scores = [
            (i, tsss_similarity(avg_vec, tourism_features.iloc[i]))
            for i in range(len(tourism_df))
            if tourism_df.iloc[i]['Name'] not in excluded_names
        ]
        scores.sort(key=lambda x: x[1], reverse=True)
        return jsonify({"results": [{"name": tourism_df.iloc[i]['Name']} for i, _ in scores[:50]]})

# ==== General Recommendation ====
@app.route("/recommend", methods=["POST"])
def general_recommend():
    data = request.json

    def get_top_k(names, df, scaled, label):
        names_set = set(names)
        indices = [df[df[label] == name].index[0] for name in names if name in df[label].values]
        if not indices:
            return [df[label].iloc[i] for i in range(len(df)) if df[label].iloc[i] not in names_set][:20]
        avg_vec = np.mean([scaled[i] for i in indices], axis=0)
        dists = [ts_ss(avg_vec, scaled[i]) for i in range(len(scaled))]
        df['score'] = dists
        filtered_df = df[~df[label].isin(names_set)]
        return filtered_df.sort_values(by='score')[label].head(20).tolist()

    return jsonify({
        "hotels": get_top_k(data.get("hotels", []), hotel_df, hotel_scaled, 'Name'),
        "restaurants": get_top_k(data.get("restaurants", []), restaurant_df, rest_scaled, 'name'),
        "tourist_places": get_top_k(data.get("tourist_places", []), tourism_df, tourism_features.values, 'Name')
    })

if __name__ == '__main__':
    app.run(debug=True)
