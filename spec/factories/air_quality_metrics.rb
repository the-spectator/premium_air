FactoryBot.define do
  factory :air_quality_metric do
    pm2_5 { 12.0 }
    pm10 { 20.0 }
    o3 { 30.0 }
    no2 { 15.0 }
    nh3 { 15.0 }
    so2 { 5.0 }
    co { 0.5 }
    recorded_at { Time.now }

    location
  end
end
