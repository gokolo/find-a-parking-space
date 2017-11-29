defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers
  alias Takso.{Repo,Taxi,User}
  @decision_timeout Application.get_env(:takso, :decision_timeout)
  
  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)    
    %{}
  end
  scenario_starting_state fn state ->
    Hound.start_session
    Ecto.Adapters.SQL.Sandbox.checkout(Takso.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Takso.Repo, {:shared, self()})
    %{}
  end
  scenario_finalize fn _status, _state ->
    Ecto.Adapters.SQL.Sandbox.checkin(Takso.Repo)
    # Hound.end_session
  end 

  scenario_timeouts fn _feature, _scenario ->
   300_000
  end
  given_ ~r/^the following taxis are on duty$/, 
  fn state, %{table_data: table} ->
    IO.puts "Decision timeout set to #{@decision_timeout} milliseconds"
    table
    |> Enum.map(fn taxi -> Taxi.changeset(%Taxi{}, taxi) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    {:ok, state}
  end

  and_ ~r/^the status of the taxis is "(?<statuses>[^"]+)"$/,
  fn state, %{statuses: statuses} ->
    String.split(statuses, ",")
    |> Enum.with_index
    |> Enum.map(fn {status, index} -> 
          Repo.get_by!(Taxi, username: "taxi#{index + 1}")
          |> Taxi.changeset(%{status: status})
          |> Repo.update!
        end)
    {:ok, state}
  end

  and_ ~r/^I want to go from "(?<pickup_address>[^"]+)" to "(?<dropoff_address>[^"]+)"$/,
  fn state, %{pickup_address: pickup_address, dropoff_address: dropoff_address} ->
    {:ok, state |> Map.put(:pickup_address, pickup_address) |> Map.put(:dropoff_address, dropoff_address)}
  end

  and_ ~r/^I enter the booking information on the STRS Customer app$/, fn state ->
   # 1. Insert a new user in the database (you can choose a username here
    [%{name: "Fred Flintstone", username: "fred", password: "parool", role: "customer"},
    %{name: "Bilbo Baggins", username: "taxi1", password: "parool", role: "taxi-driver"},
    %{name: "Bilbo Baggins", username: "taxi2", password: "parool", role: "taxi-driver"},
    %{name: "Frodo Baggins", username: "taxi3", password: "parool", role: "taxi-driver"}]
    |> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
    |> Enum.map(fn changeset -> User.encrypt_password(changeset) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    
    [%{name: "Bilbo Baggins", username: "taxi1", password: "parool", role: "taxi-driver"},
    %{name: "Bilbo Baggins", username: "taxi2", password: "parool", role: "taxi-driver"},
    %{name: "Frodo Baggins", username: "taxi3", password: "parool", role: "taxi-driver"}]
    |> Enum.map( fn user_data ->
    in_browser_session String.to_atom(user_data.username), fn ->
      navigate_to "/#/login"
      fill_field({:id, "username"}, user_data.username)
      fill_field({:id, "password"}, "parool")

      submit = find_element(:class, "btn")
      click(submit)
    end
    end)
 
    # (Session :default will be used by customer)
    in_browser_session :default, fn ->
      # 2. Log in the application with the user credentials
      navigate_to "/#/login"
       fill_field({:id, "username"}, "fred")
       fill_field({:id, "password"}, "parool")
      submit = find_element(:class, "btn")
      click(submit) 
      # Process.sleep(2000)
      # 3. Enter the information about the booking
      fill_field({:id, "pickup_address"}, state[:pickup_address])
      fill_field({:id, "dropoff_address"}, state[:dropoff_address])  
    end 
    {:ok, state}
  end

  when_ ~r/^I summit the booking request$/, fn state ->
    in_browser_session :default, fn ->
      submit = find_element(:class, "btn")
      click(submit)
      # click({:id, "submit_button"})
    end
    {:ok, state}
  end

  and_ ~r/^"(?<taxi_username>[^"]+)" is contacted$/,
  fn state, %{taxi_username: taxi_username} ->
    # 1. Insert a new user in the database for this taxi driver
    # changeset = User.changeset(%User{}, %{name: "Bilbo Baggins", username: taxi_username, password: "parool", role: "taxi-driver"}) 
    # changeset = User.encrypt_password(changeset)
    # Repo.insert!(changeset)

    # 2. Log in the application with the taxi driver credentials
    # -- Note that we are switching to a browser session for this taxi driver!
    
    {:ok, state}
  end

  and_ ~r/^"(?<taxi_username>[^"]+)" decides to "(?<decision>[^"]+)"$/,
  fn state, %{taxi_username: taxi_username, decision: decision} ->
    in_browser_session String.to_atom(taxi_username), fn ->
      take_screenshot()
      case decision do
        "reject" -> IO.puts "Taxi driver clicks reject button"
        reject = find_element(:class, "btn-danger")
        click(reject)
        #click({:id, "rejectbtn"})
        Process.sleep(2000)
        "accept" -> IO.puts "Taxi driver clicks accept button"
        _ -> 
        accept = find_element(:class, "btn-default")
        click(accept)
      end
    end
    {:ok, state}
  end

  then_ ~r/^I should be notified "(?<notification>[^"]+)"$/,
  fn state, %{notification: notification} ->
    in_browser_session :default, fn ->
      assert visible_in_page? Regex.compile!(notification)
    end
    {:ok, state}
  end
end
