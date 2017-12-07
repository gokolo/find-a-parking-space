alias Takso.{Repo,User,Taxi, ParkingPlace}

[%{name: "Fred Flintstone", username: "fred1", password: "parool", role: "customer"},
 %{name: "Barney Rubble", username: "barney", password: "parool", role: "customer"},
 %{name: "Bilbo Baggins", username: "bilbo", password: "parool", role: "taxi-driver"},
 %{name: "Frodo Baggins", username: "frodo", password: "parool", role: "taxi-driver"}]
|> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

[%{username: "bilbo", location: "Juhan Liivi 2", status: "available"},
 %{username: "frodo", location: "Raatuse 22", status: "available"}]
|> Enum.map(fn taxi_data -> Taxi.changeset(%Taxi{}, taxi_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

[%{startLat: 58.382548, startLng: 26.723975, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "A", pricePerHour: 2 ,pricePerMin: 0.2 },
%{startLat: 58.382810, startLng: 26.734172, endLat: 58.384231, endLng: 26.739822, type: "ROAD", region: "A", pricePerHour: 1 ,pricePerMin: 0.1 }]
|> Enum.map(fn parking_data -> ParkingPlace.changeset(%ParkingPlace{}, parking_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)