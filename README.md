# Premium Air Monitor

An AQI monitor based on Open Weather API.

<img width="1511" alt="image" src="https://github.com/user-attachments/assets/5b0187c5-8b9a-4cd7-8247-e0391087e226" />

## Table of Contents

- [Methodology Used](#methodology)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Our Stack](#stack)
    - [Local Setup](#local)
    - [Tests](#tests)
- [Modules](#modules)
- [Further Improvement](#further-improvement)

## Methodology

The App follows UK Standard AQI calculation.

**Pollutants Considered in AQI**

The AQI is calculated based on the highest concentration band of the following pollutants:

- PM2.5 (Fine particulate matter)
- PM10 (Coarse particulate matter)
- O₃ (Ozone)
- NO₂ (Nitrogen dioxide)
- SO₂ (Sulfur dioxide)

**Air quality index levels scale in UK**

| Qualitative Name | Index | SO₂ (μg/m³) | NO₂ (μg/m³) | PM2.5 (μg/m³) | PM10 (μg/m³) | O₃ (μg/m³) |
|------------------|-------|------------|------------|--------------|-------------|------------|
| Low             | 1     | 0-88       | 0-67       | 0-11         | 0-16        | 0-33       |
| Low             | 2     | 89-177     | 68-134     | 12-23        | 17-33       | 34-66      |
| Low             | 3     | 178-266    | 135-200    | 24-35        | 34-50       | 67-100     |
| Moderate        | 4     | 267-354    | 201-267    | 36-41        | 52-58       | 101-120    |
| Moderate        | 5     | 355-443    | 268-334    | 42-47        | 59-66       | 121-140    |
| Moderate        | 6     | 444-532    | 335-400    | 48-53        | 67-75       | 141-160    |
| High           | 7     | 533-710    | 401-467    | 54-58        | 76-83       | 161-187    |
| High           | 8     | 711-887    | 468-534    | 59-64        | 84-91       | 188-213    |
| High           | 9     | 888-1064   | 535-600    | 65-70        | 92-100      | 214-240    |
| Very High      | 10    | ≥1065      | ≥601       | ≥71          | ≥101        | ≥241       |

**Final AQI Calculation**

The final AQI is determined by calculating the AQI for each pollutant and selecting the highest value as the overall AQI.

Example: `{"pm2_5" => 83.85, "pm10" => 96.91, "o3" => 64.37, "no2" => 17.14, "so2" => 12.28}`

Using the UK AQI bands:

- PM2.5 (83.85 μg/m³) → AQI 10 (Very High)
- PM10 (96.91 μg/m³) → AQI 9 (High)
- O3 (64.37 μg/m³) → AQI 2 (Low)
- NO2 (17.14 μg/m³) → AQI 1 (Low)
- SO2 (12.28 μg/m³) → AQI 1 (Low)

The highest AQI is 10 (from PM2.5). Hence AQI is considered as 10 and max_pollutant is PM2.5.

## Getting Started

This section provides a high-level quick setup guide.

### Prerequisites

- ruby (3.4.1)
- postgres (14+)

### Our Stack

- Rails (8.0.1)
- Solid Queue (1.0.1) for active job adapter
- TailwindCSS (4.0.3) for styling
- RSpec (with vcr, webmock, factorybot) for testing
- Faraday for http client
- ChartKick for graphing
- Flowbite tailwind components

### Local Setup

- Use ruby 3.4.1
- Run bin/setup
    - Installs gems
    - Creates DB
    - Run Migrates
    - Run DB seed

    ```
    cd premium_air
    bin/setup --skip-server
    ```
- Export master key
    ```
    echo {key} > config/master.key
    ```
- Import last year data
    ```
    bundle exec rails aqi:import
    ```
- Run rails server & job server
    ```
    bin/dev
    ```

### Tests
- Run RSpec
    ```
    bundle exec rspec spec
    ```

## Modules

**Location AQI [AqiController#index]**

<img width="1511" alt="image" src="https://github.com/user-attachments/assets/3191da27-649b-4d91-be6e-5977a598c736" />

- Metrics Recorded Card (Metric Count)
- Location Card (Location Count)
- States Card (State Count)

- Location AQI Table
    - Location name
    - Latest AQI
        ```
        >> Location.limit(10).includes(:latest_aqi) # lateral join
        ```
    - Average AQI till now
        ```
        >> Location.limit(10).includes(:avg_aqi) # lateral join
        ```
    - Latest AQI record time
    - Show more - redirects to location detail page
    - Pagination

**Location Detail [LocationsController#show]**

<img width="1511" alt="image" src="https://github.com/user-attachments/assets/5b0187c5-8b9a-4cd7-8247-e0391087e226" />

- Latest AQI Card
- Past Month AQI Card
- Current Month AQI Card
- Chart for Average AQI per month

**State AQI [StatesController#index]**

<img width="1511" alt="image" src="https://github.com/user-attachments/assets/e081b572-ed9e-4b28-8983-9c9d430b3306" />

- State AQI Table
    - State Name
    - Average AQI till now
        ```
        >> State.limit(10).includes(:avg_aqi) # lateral join
        ```

**Dark Mode**

Thanks to tailwind flowbite components, I got the dark mode for free! Its not perfect but still looks nice.

<img width="1511" alt="image" src="https://github.com/user-attachments/assets/99c3d51b-6bf9-4033-8165-7d6795196856" />
<img width="1511" alt="image" src="https://github.com/user-attachments/assets/6e223cfa-c1bb-48b3-b146-ce0c99af39ff" />
<img width="1511" alt="image" src="https://github.com/user-attachments/assets/c727b62b-df7e-4e44-aa56-e3370249780b" />

**Mission Control**

- Visit http://localhost:3000/jobs
- basic auth
    username = hello
    password = world

**Recurring Job**

Currently We have enqueued the recurring job for every 5 minutes (temp) to import last 1 hour AQI data for all location.

## Key Code Components

- OpenWeather Client
    lib/open_weather/client.rb
    lib/open_weather/api/air_pollution.rb
    spec/lib/open_weather/*_spec.rb

- Model
    app/models/air_quality_metric.rb

- AQI Calculator
    app/models/uk_aqi.rb
    spec/models/uk_aqi_spec.rb

- Importer Job & Cron
    app/models/air_quality_metric_importer.rb
    app/jobs/air_quality_import_cron_job.rb
    config/recurring.yml

## Further Improvement

- Need more Capybara specs
- Explore Async Load queries
- Polish AirQualityMetricImporter more
- Rate limiter for ImportJob
- Integrate GeoCode search API
