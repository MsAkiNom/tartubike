defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers

  alias TartuBike.{Repo, Accounts.User, BikeSharing.Dock, BikeSharing.Bike, BikeSharing.Ride, Problems.Report}

  import Ecto.Query, only: [from: 2]

  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)
    %{}
  end
  scenario_starting_state fn _state ->
    Hound.start_session
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    %{}
  end
  scenario_finalize fn _status, _state ->
    Ecto.Adapters.SQL.Sandbox.checkin(Repo)
    Hound.end_session
  end

  ##### USER
  # Registration
  given_ ~r/^I click on register button$/, fn state ->
    navigate_to "/users/new"
    {:ok, state}
  end
  and_ ~r/^I set a username "(?<username>[^"]+)" with password "(?<password>[^"]+)"$/,
  fn state, %{username: username, password: password} ->
    {:ok, state |> Map.put(:username, username)
                |> Map.put(:password, password)
    }
  end
  and_ ~r/^I add my name "(?<name>[^"]+)", email "(?<email>[^"]+)", birthday "(?<dob>[^"]+)" $/,
  fn state, %{name: name,
              email: email,
              dob: dob} ->
    {:ok, state |> Map.put(:name, name)
                |> Map.put(:email, email)
                |> Map.put(:dob, dob)
    }
  end
  and_ ~r/^I have a credit card with number "(?<cc>[^"]+)" $/,
  fn state, %{cc: cc} ->
    {:ok, state |> Map.put(:cc, cc) }
  end
  and_ ~r/^I fill required information$/, fn state ->
    fill_field({:id, "username"}, state[:username])
    fill_field({:id, "password"}, state[:password])
    fill_field({:id, "name"}, state[:name])
    fill_field({:id, "email"}, state[:email])
    fill_field({:id, "dob"}, state[:dob])
    {:ok, state}
  end
  and_ ~r/^I add credit card information$/, fn state ->
    fill_field({:id, "credit_card_number"}, state[:cc])
    {:ok, state}
  end
  when_ ~r/^I click a submit button$/, fn state ->
    click({:id, "new_user_submit"})
    {:ok, state}
  end
  then_ ~r/^I should view confirmation message for register successfully$/, fn state ->
    assert visible_in_page? ~r/User created successfully./
    {:ok, state}
  end

  then_ ~r/^I should see no payment method detail error$/, fn state ->
    assert visible_in_page? ~r/Please enter your payment method/
    {:ok, state}
  end

  # Login
  given_ ~r/^the following users exist$/, fn state, %{table_data: table}  ->
    table
    |> Enum.map(fn user -> User.changeset(%User{}, user) end)
    |> Enum.each(fn changeset -> TartuBike.Repo.insert!(changeset) end)
  end

  and_ ~r/^I click on login button$/, fn state ->
    navigate_to("/sessions/new")
    {:ok, state}
  end

  and_ ~r/^I click on log out button$/, fn state ->
    click({:id, "logout"})
    {:ok, state}
  end

  and_ ~r/^I want to login to the account with username "(?<username>[^"]+)" and password "(?<password>[^"]+)"$/,
  fn state, %{username: username,password: password} ->

    {:ok, state |> Map.put(:username, username) |> Map.put(:password, password)}
  end

  and_ ~r/^I write my credentials$/, fn state ->
    fill_field({:id, "session_username"}, state[:username])
    fill_field({:id, "session_password"}, state[:password])
    {:ok, state}
  end

  when_ ~r/^I click a login submit button$/, fn state ->
    click({:id, "login-submit"})
    {:ok, state}
  end

  then_ ~r/^I should see a confirmation of authenthication$/, fn state ->
    assert visible_in_page? ~r/Welcome/
    {:ok, state}
  end

  ##### SEACH
  # Station map
  when_ ~r/^I click on station map$/, fn state ->
    navigate_to "/search"
    {:ok, state}
  end

  then_ ~r/^I should see a map with the locations of dock stations$/, fn state ->
    assert visible_in_page? ~r/Station map/
    {:ok, state}
  end
  # Available bike
  then_ ~r/^I should see a number of bike in each stations$/, fn state ->
    assert visible_in_page? ~r/58.37388226,26.7524598/
    assert visible_in_page? ~r/Classic Bike/
    assert visible_in_page? ~r/Electric Bike/
    {:ok, state}
  end




  when_ ~r/^I login to my page $/, fn state ->
    navigate_to "/memberships/new"
    {:ok, state}
  end

  then_ ~r/^I should be able to make a preferred membership selection$/, fn state ->
    navigate_to "/memberships/new"
    assert visible_in_page? ~r/1-year membership costs €30/
    {:ok, state}
  end


  # Renting bike
  given_ ~r/^the following dock exists$/, fn state, %{table_data: table} ->
    table
    |> Enum.map(fn dock -> Dock.changeset(%Dock{}, dock) end)
    |> Enum.each(fn changeset -> TartuBike.Repo.insert!(changeset) end)

    {:ok, state}
  end

  given_ ~r/^the following bikes exist in that dock$/, fn state, %{table_data: table}  ->
    dock = Repo.all(Dock) |> hd
    table
    |> Enum.map(fn bike -> Bike.changeset(%Bike{}, bike) end)
    |> Enum.each(fn changeset -> changeset  |> TartuBike.Repo.insert!()
                                            |>  Repo.preload(:dock)
                                            |> Ecto.Changeset.change
                                            |> Ecto.Changeset.put_assoc(:dock, dock)
                                            |> Repo.update! end)
    {:ok, state}
  end

  and_ ~r/^I want to select the bike with type "(?<type>[^"]+)"$/,
  fn state, %{type: type} ->
    query = from b in Bike,
            where: b.type == ^type and b.status == "available"
    bike = Repo.all(query) |> hd
    {:ok, state |> Map.put(:id, bike.id)}
  end

  and_ ~r/^I want to select the bike with non existent id$/, fn state ->
    query = from b in Bike,
              order_by: [desc: b.id],
              select: b.id
    max_id = Repo.all(query) |> hd
    {:ok, state |> Map.put(:id, max_id + 1)}
  end

  given_ ~r/^I rented the bike with type "(?<type>[^"]+)"$/,
  fn state, %{type: type} ->
    query = from b in Bike,
            where: b.type == ^type and b.status == "available"
    bike = Repo.all(query) |> hd
    user = Repo.get_by(User, username: state[:username])
    time = DateTime.utc_now() |> DateTime.truncate(:second)
    Repo.insert!(%Ride{user: user, bike: bike, started_at: time})
    {:ok, state |> Map.put(:id, bike.id)}
  end

  and_ ~r/^I go to rent the bike page$/, fn state ->
    navigate_to("/rent")
    {:ok, state}
  end

  and_ ~r/^I go to end the ride page$/, fn state ->
    navigate_to("/end")
    {:ok, state}
  end


  and_ ~r/^I enter id of the bike$/, fn state ->
    fill_field({:id, "id"}, state[:id])
    {:ok, state}
  end

  and_ ~r/^I enter id of the dock$/, fn state ->
    dock = Repo.all(Dock) |> hd
    fill_field({:id, "dock_id"}, dock.id)
    {:ok, state}
  end
  and_ ~r/^I enter id of the dock "(?<dock_id>[^"]+)"$/,
  fn state, %{dock_id: dock_id} ->
    fill_field({:id, "dock_id"}, dock_id)
    {:ok, state}
  end


  when_ ~r/^I click a rent button$/, fn state ->
    click({:id, "rent-submit"})
    {:ok, state}
  end

  when_ ~r/^I click a end button$/, fn state ->
    click({:id, "end-submit"})
    {:ok, state}
  end


  then_ ~r/^bike's status should change$/, fn state ->
    bike = Repo.get(Dock, state[:id])
    assert bike.status=="in-use"
    {:ok, state}
  end

  then_ ~r/^I should see a confirmation message$/, fn state ->
    assert visible_in_page?(~r/Happy ride/)
    {:ok, state}
  end

  then_ ~r/^I should see a rejection message$/, fn state ->
    assert visible_in_page?(~r/Failed to rent the bike./)
    {:ok, state}
  end

  then_ ~r/^I should see an ending ride confirmation message$/, fn state ->
    assert visible_in_page?(~r/You have successfully ended the ride/)
    {:ok, state}
  end
  then_ ~r/^I should see an ending ride error message$/, fn state ->
    assert visible_in_page?(~r/No empty dock at this station/)
    {:ok, state}
  end
  then_ ~r/^I should see a rejection message for return the previous one first$/, fn state ->
    assert visible_in_page?(~r/Please return the bike before renting a new one/)
    {:ok, state}
  end

  #summary

  # for user usage
  when_ ~r/^I click on UserUsage$/, fn state ->
    navigate_to("/usersummary")
    click({:id, "user_usage"})
    {:ok, state}
  end

  then_ ~r/^I should see an estimate of the total kilometres ridden, the CO2 saved, and the calories burned.$/, fn state ->
    assert visible_in_page? ~r/User Usage/
    {:ok, state}
  end

  # for ride history
  when_ ~r/^I click on RideHistory$/, fn state ->
    navigate_to("/usersummary")
    click({:id, "ride_history"})
    {:ok, state}
  end

  then_ ~r/^I should see a history of the rides made, including date and time, duration of the ride, starting and endpoint$/, fn state ->
    assert visible_in_page? ~r/Ride History/
    {:ok, state}
  end

  # for invoice history

  when_ ~r/^I click on InvoiceHistory$/, fn state ->
    navigate_to("/usersummary")
    click({:id, "invoice_history"})
    {:ok, state}
  end

  then_ ~r/^I should see a history of invoices along with invoice date$/, fn state ->
    assert visible_in_page? ~r/Invoice History/
    {:ok, state}
  end

  # Booking

  and_ ~r/^I go to book the bike page$/, fn state ->
    navigate_to("/book")
    {:ok, state}
  end

  when_ ~r/^I click a book button$/, fn state ->
    click({:id, "book-submit"})
    {:ok, state}
  end

  then_ ~r/^I should see a booking confirmation message$/, fn state ->
    assert visible_in_page?(~r/You have successfully booked the bike./)
    {:ok, state}
  end

  then_ ~r/^I should see a booking rejection message$/, fn state ->
    assert visible_in_page?(~r/Failed to book the bike./)
    {:ok, state}
  end

  # report an issue

  when_ ~r/^I click on report issue button$/, fn state ->
    navigate_to "/reports/new"
    {:ok, state}
  end

  and_ ~r/^I set a bikeid to "(?<bikeid>[^"]+)" with the title "(?<title>[^"]+)"$/,
  fn state, %{bikeid: bikeid,title: title} ->
    {:ok, state |> Map.put(:bikeid, bikeid)
                |> Map.put(:title, title)
    }

  end

  and_ ~r/^I set a bikeid to "(?<bikeid>[^"]+)"$/,
  fn state, %{bikeid: bikeid} ->
    {:ok, state |> Map.put(:bikeid, bikeid)}

  end

  and_ ~r/^I add my issue "(?<issue>[^"]+)" $/,
  fn state, %{issue: issue} ->
    {:ok, state |> Map.put(:issue, issue)}
  end

  and_ ~r/^I fill the necessary information$/, fn state ->
    fill_field({:id, "bikeid"}, state[:bikeid])
    fill_field({:id, "title"}, state[:title])
    fill_field({:id, "issue"}, state[:issue])
    {:ok, state}
  end

  when_ ~r/^I click on a save button$/, fn state ->
    click({:id, "report-submit"})
    {:ok, state}
  end

  then_ ~r/^I should see a successfully created report message along with the preview of the submitted report form$/, fn state ->
    assert visible_in_page?~r/Report created successfully./
    {:ok, state}
  end

  then_ ~r/^I should get a failure message$/, fn state ->
    assert visible_in_page?~r/Oops, something went wrong! Please check the errors below./
    {:ok, state}
  end

  # invoice


  then_ ~r/^I should see my invoice page$/, fn state ->
    assert visible_in_page?(~r/Invoice/)
    assert visible_in_page?(~r/ramil@gmail.com/)
    {:ok, state}
  end


  # Popular routes
  when_ ~r/^I click on popular routes$/, fn state ->
    navigate_to "/popular"
    {:ok, state}
  end

  then_ ~r/^I should see popular routes$/, fn state ->
    assert visible_in_page?(~r/Popular attractions/)
    {:ok, state}
  end

  # Search nearme
  given_ ~r/^I am viewing a station map$/, fn state ->
    navigate_to "/search"
    {:ok, state}
  end
  when_ ~r/^I click on use my location$/, fn state ->
    click({:id, "nearme-submit"})
    {:ok, state}
  end

  then_ ~r/^I should see the distance from your location to the closest dock$/, fn state ->
    assert visible_in_page?(~r/The distance from your location to the closest dock/)
    {:ok, state}
  end

end
