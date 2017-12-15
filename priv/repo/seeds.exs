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

[%{startLat: 58.382548, startLng: 26.723975, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 2},
%{startLat: 58.382810, startLng: 26.734172, endLat: 58.384231, endLng: 26.739822, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 5},
%{startLat: 58.379386, startLng: 26.716583, endLat: 58.379740, endLng: 26.715178, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 18},
%{startLat: 58.379771, startLng: 26.715213, endLat: 58.379888, endLng: 26.715650, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 8},
%{startLat: 58.379409, startLng: 26.716764, endLat: 58.379812, endLng: 26.718773, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 25},
%{startLat: 58.379796, startLng: 26.718824, endLat: 58.379499, endLng: 26.719044, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 18},
%{startLat: 58.380195, startLng: 26.720923, endLat: 58.379751, endLng: 26.721732, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 12},
%{startLat: 58.380693, startLng: 26.719801, endLat: 58.380822, endLng: 26.720498, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 10},
%{startLat: 58.381055, startLng: 26.720434, endLat: 58.381476, endLng: 26.720380, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 8},
%{startLat: 58.381882, startLng: 26.713652, endLat: 58.382362, endLng: 26.714416, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 9},
%{startLat: 58.382293, startLng: 26.713142, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 3},
%{startLat: 58.377643, startLng: 26.717444, endLat: 58.378002, endLng: 26.719224, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 30},
%{startLat: 58.381073, startLng: 26.721941, endLat: 58.381260, endLng: 26.723257, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 18},
%{startLat: 58.384048, startLng: 26.723182, endLat: 58.379751, endLng: 26.721732, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 12},
%{startLat: 58.375094, startLng: 26.715048, endLat: 58.384211, endLng: 26.722688, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 10},
%{startLat: 58.381055, startLng: 26.720434, endLat: 58.381476, endLng: 26.720380, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 8},
%{startLat: 58.378906, startLng: 26.717076, endLat: 58.382679, endLng: 26.719346, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 9},
%{startLat: 58.378850, startLng: 26.724379, endLat: 58.378549, endLng: 26.724889, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 10},
%{startLat: 58.376714, startLng: 26.720434, endLat: 58.376906, endLng: 26.723778, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 8},
%{startLat: 58.376893, startLng: 26.725698, endLat: 58.376701, endLng: 26.726009, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 9},
%{startLat: 58.382809, startLng: 26.710188, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 7},
%{startLat: 58.379558, startLng: 26.705832, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 3},
%{startLat: 58.374311, startLng: 26.711164, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 3},
%{startLat: 58.380230, startLng: 26.701808, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 7},
%{startLat: 58.384946, startLng: 26.718202, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 10},
%{startLat: 58.379233, startLng: 26.715387, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 3},
%{startLat: 58.376129, startLng: 26.724103, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 7},
%{startLat: 58.372023, startLng: 26.727794, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 2},
%{startLat: 58.383803, startLng: 26.722354, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 2},
%{startLat: 58.383131, startLng: 26.714543, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 7},
%{startLat: 58.385018, startLng: 26.714487, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 2},
%{startLat: 58.381906, startLng: 26.711432, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 2},
%{startLat: 58.379007, startLng: 26.722597, endLat: 58.378599, endLng: 26.723048, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 10},
%{startLat: 58.379074, startLng: 26.722587, endLat: 58.379215, endLng: 26.723032, type: "ROAD", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 9},
%{startLat: 58.380078, startLng: 26.708538, endLat: 0.0, endLng: 0.0, type: "PLACE", region: "A", pricePerHour: 2 ,pricePerMin: 0.32, maximumSize: 3},
%{startLat: 58.371981, startLng: 26.713866, endLat: 58.371446, endLng: 26.714268, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 12},
%{startLat: 58.378148, startLng: 26.707224, endLat: 58.377647, endLng: 26.707503, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 14},
%{startLat: 58.377611, startLng: 26.705182, endLat: 58.377144, endLng: 58.377144, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 10},
%{startLat: 58.386376, startLng: 26.714957, endLat: 58.386798, endLng: 26.715343, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 12},
%{startLat: 58.382414, startLng: 26.703480, endLat: 58.382996, endLng: 26.704338, type: "ROAD", region: "B", pricePerHour: 1 ,pricePerMin: 0.16, maximumSize: 10}
]
|> Enum.map(fn parking_data -> ParkingPlace.changeset(%ParkingPlace{}, parking_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)


[%{estimated_cost: 5.50, estimated_time: 1200, paying_status: "paid", user_id: 5},
%{estimated_cost: 2.50, estimated_time: 0200, paying_status: "paid", user_id: 5},
%{estimated_cost: 1.00, estimated_time: 1400, paying_status: "paid", user_id: 5},
%{estimated_cost: 11.50, estimated_time: 0800, paying_status: "paid", user_id: 2}]
|> Enum.map(fn booking_data -> ParkingBooking.changeset(%ParkingBooking{}, booking_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)