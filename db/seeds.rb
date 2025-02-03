# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[
  { "name" => "Dehradun", "lat" => 30.3255646, "lon" => 78.0436813, "country" => "India", "state" => "Uttarakhand" },
  { "name" => "Chennai", "lat" => 13.0836939, "lon" => 80.270186, "country" => "India", "state" => "Tamil Nadu" },
  { "name" => "Bengaluru", "lat" => 12.9767936, "lon" => 77.590082, "country" => "India", "state" => "Karnataka" },
  { "name" => "Bhubaneshwar", "lat" => 20.2602964, "lon" => 85.8394521, "country" => "India", "state" => "Odisha" },
  { "name" => "Kochi", "lat" => 9.9674277, "lon" => 76.2454436, "country" => "India", "state" => "Kerala" },
  { "name" => "Mumbai", "lat" => 19.0785451, "lon" => 72.878176, "country" => "India", "state" => "Maharashtra" },
  { "name" => "Chanakya Puri Tehsil", "lat" => 28.6138954, "lon" => 77.2090057, "country" => "India", "state" => "Delhi" },
  { "name" => "Delhi", "lat" => 42.4297057, "lon" => -91.3309112, "country" => "India", "state" => "Iowa" },
  { "name" => "Srinagar", "lat" => 34.0747444, "lon" => 74.8204443, "country" => "India", "state" => "Jammu and Kashmir" },
  { "name" => "Guwahati", "lat" => 26.1805978, "lon" => 91.753943, "country" => "India", "state" => "Assam" },
  { "name" => "Ahmedabad", "lat" => 23.0216238, "lon" => 72.5797068, "country" => "India", "state" => "Gujarat" },
  { "name" => "Vasna ", "lat" => 23.0025104, "lon" => 72.5463191, "country" => "India", "state" => "Gujarat" },
  { "name" => "Patna", "lat" => 25.6093239, "lon" => 85.1235252, "country" => "India", "state" => "Bihar" },
  { "name" => "Gangtok", "lat" => 27.329046, "lon" => 88.6122673, "country" => "India", "state" => "Sikkim" },
  { "name" => "Amritsar", "lat" => 31.6356659, "lon" => 74.8787496, "country" => "India", "state" => "Punjab" },
  { "name" => "Mysuru", "lat" => 12.3051828, "lon" => 76.6553609, "country" => "India", "state" => "Karnataka" },
  { "name" => "Kolkata", "lat" => 22.5414185, "lon" => 88.35769124388872, "country" => "India", "state" => "West Bengal" },
  { "name" => "Pune", "lat" => 18.521428, "lon" => 73.8544541, "country" => "India", "state" => "Maharashtra" },
  { "name" => "Hyderabad", "lat" => 17.360589, "lon" => 78.4740613, "country" => "India", "state" => "Telangana" },
  { "name" => "Nagpur", "lat" => 21.1498134, "lon" => 79.0820556, "country" => "India", "state" => "Maharashtra" },
  { "name" => "Nagpur (Chota)", "lat" => 20.0278508, "lon" => 79.2492771, "country" => "India", "state" => "Maharashtra" },
  { "name" => "Jaipur", "lat" => 26.9154576, "lon" => 75.8189817, "country" => "India", "state" => "Rajasthan" },
  { "name" => "Bhopal", "lat" => 23.2584857, "lon" => 77.401989, "country" => "India", "state" => "Madhya Pradesh" },
  { "name" => "Jabalpur", "lat" => 23.1608938, "lon" => 79.9497702, "country" => "India", "state" => "Madhya Pradesh" },
  { "name" => "Raipur", "lat" => 21.2380912, "lon" => 81.6336993, "country" => "India", "state" => "Chhattisgarh" },
  { "name" => "Surat", "lat" => 45.9383, "lon" => 3.2553, "country" => "India", "state" => "Auvergne-Rhône-Alpes" },
  { "name" => "Indore", "lat" => 22.7203616, "lon" => 75.8681996, "country" => "India", "state" => "Madhya Pradesh" },
  { "name" => "Simrol", "lat" => 22.539445, "lon" => 75.9115643, "country" => "India", "state" => "Madhya Pradesh" },
  { "name" => "Panaji", "lat" => 15.4989946, "lon" => 73.8282141, "country" => "India", "state" => "Goa" },
  { "name" => "Wagholi", "lat" => 20.70430215, "lon" => 77.74280838036458, "country" => "India", "state" => "Maharashtra" }
].each do |location|
  state = State.find_or_create_by!(name: location["state"])
  location = Location.find_or_create_by!(name: location["name"], latitude: location["lat"], longitude: location["lon"], state: state)
end
