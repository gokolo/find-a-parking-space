defmodule Takso.Geolocator do
    require Integer
    @http_client Application.get_env(:takso, :http_client)
  
    def trip_duration(origin, destination) do
      url = "http://maps.googleapis.com/maps/api/distancematrix/json?origins=" <> trim_and_add(origin) <> "&destinations=" <> trim_and_add(destination)
      IO.inspect url
      %{body: body} = @http_client.get!(url)
      map = Poison.Parser.parse!(body)
      elementList = get_in(map, ["rows"])
      lowest_time = get_lowest_time(elementList, 10000)         
      Integer.to_string(lowest_time) <> " mins"
    end

    def trim_and_add(str) do
        str
        |> String.trim
        |> String.replace(" ", "+")
    end

    def get_lowest_time([],acc)do
        acc
    end
    def get_lowest_time([head|tail], acc) do
        time_duration = head
                        |> Map.get("elements")
                        |> List.first()
                        |> Map.get("duration")
                        |> Map.get("text")
        slitList = String.split time_duration
        {intTime, text} = Integer.parse(List.first(slitList))
        cond do
            acc > intTime -> get_lowest_time(tail,intTime)
            acc <= intTime -> get_lowest_time(tail, acc)
        end
    end

    def get_closest_taxi_index(origins, destination) do
        url = "http://maps.googleapis.com/maps/api/distancematrix/json?origins=" <> trim_and_add(origins) <> "&destinations=" <> trim_and_add(destination)
        IO.inspect url
        %{body: body} = @http_client.get!(url)
        map = Poison.Parser.parse!(body)
        elementList = get_in(map, ["rows"])
        get_lowest_index(elementList, 10000, 0, -1)         
        
      end
  
      def get_lowest_index([],acc, index, result)do
        result
      end
      def get_lowest_index([head|tail], acc, index, result) do
          time_duration = head
                          |> Map.get("elements")
                          |> List.first()
                          |> Map.get("duration")
                          |> Map.get("text")
          slitList = String.split time_duration
          {intTime, text} = Integer.parse(List.first(slitList))
          cond do
              acc > intTime -> get_lowest_index(tail,intTime, index+1, index)
              acc <= intTime -> get_lowest_index(tail, acc, index, result)
          end
       end
    
  end